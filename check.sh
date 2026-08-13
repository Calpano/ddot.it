#!/usr/bin/env bash
# Build the site and run every check that .github/workflows/pages.yml runs,
# so a green run here means a green deploy.
#
# Usage:
#   ./check.sh              # clean build + all checks
#   ./check.sh --fast       # skip the clean, reuse _site (incremental artefacts)
#
# It runs all checks even after one fails, and reports at the end: fixing a
# broken link only to discover an unlexable code block on the next run wastes a
# build each time. Exit status is non-zero if any check failed.
#
# Not called by CI. CI builds with its own --baseurl and then runs the same two
# checks; this script exists so the same failures show up before pushing.
set -uo pipefail
cd "$(dirname "$0")"

fast=false
[[ "${1:-}" == "--fast" ]] && fast=true

failed=()

run() {  # run <name> <command...>
  local name=$1; shift
  printf '\n\033[1m==> %s\033[0m\n' "$name"
  if "$@"; then
    printf '\033[32mok\033[0m: %s\n' "$name"
  else
    printf '\033[31mFAILED\033[0m: %s\n' "$name"
    failed+=("$name")
  fi
}

# --- build -----------------------------------------------------------------
# Asciidoctor reports out-of-sequence section levels and level-0 sections here
# and nowhere else, so the build log is itself a check -- but Jekyll exits 0 on
# an Asciidoctor ERROR, so those never fail the build on their own. Surface them.
$fast || bundle exec jekyll clean
build_log=$(mktemp)
printf '\n\033[1m==> build\033[0m\n'
if bundle exec jekyll build 2>&1 | tee "$build_log"; then
  if grep -qE '^asciidoctor: (ERROR|WARNING)' "$build_log"; then
    printf '\033[31mFAILED\033[0m: build (Asciidoctor diagnostics above)\n'
    failed+=("build (Asciidoctor diagnostics)")
  else
    printf '\033[32mok\033[0m: build\n'
  fi
else
  failed+=("build")
fi
rm -f "$build_log"

# --- links, anchors, images, assets ----------------------------------------
run "links" ./check-links.sh

# --- unlexable code --------------------------------------------------------
# Rouge emits `<span class="err">` for input it could not lex: either a
# malformed code sample or a genuine lexer bug on valid input. Since the
# ddot.it blocks are lexed by rouge-ddot, released from another repository,
# this also catches a bad lexer upgrade reaching the site.
check_rouge() {
  local matches
  matches=$(grep -rn '<span class="err">' _site --include='*.html' || true)
  [[ -z "$matches" ]] && { echo "no Rouge error spans"; return 0; }
  echo "Rouge could not lex some code; each line below holds an unlexable span"
  printf '%s\n' "$matches" | cut -c1-240
  return 1
}
run "rouge" check_rouge

# --- report ----------------------------------------------------------------
echo
if ((${#failed[@]})); then
  printf '\033[31m%d check(s) failed:\033[0m\n' "${#failed[@]}"
  printf '  - %s\n' "${failed[@]}"
  exit 1
fi
printf '\033[32mall checks passed\033[0m\n'
