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

# --- unresolved cross-references -------------------------------------------
# A dangling `<<foo>>` renders as an ordinary-looking link, so it has to be
# asked for: Asciidoctor reports it only at INFO level (hence -v), and only
# when it writes a real file -- with `-o /dev/null` the check silently never
# runs. One file per invocation, because the message carries no source location
# and would otherwise be unattributable.
#
# This does NOT replace check-links.sh. It sees every source file and every
# `<<...>>`, but it is blind to cross-file `xref:other.adoc#id` and to the
# theme's navigation; only the built site shows those.
#
# "possible" is meant literally. An inline `[[id]]` is registered when its own
# line is converted, so a reference appearing *earlier* in the file is reported
# even though it resolves -- `dd-excluded` in ddot-it-highlight.adoc is one.
# Those are filtered by asking whether the file defines the id anywhere at all.
# The blind spot that leaves -- an id defined only inside a listing block, so
# never registered -- is caught by check-links.sh against the built HTML.
#
# `idprefix`/`idseparator` mirror jekyll-asciidoc's DefaultAttributes, since
# they decide the generated section ids that `<<...>>` resolves against; with
# stock Asciidoctor defaults every multi-word title would mismatch. The other
# attributes mirror _config.yml. asciidoctor-diagram is deliberately not
# required: `[plantuml]` blocks then fall back to literal blocks, whose content
# is not scanned for references anyway, and the check stays free of Java.
check_xrefs() {
  local out found=0 tmp rx f id
  tmp=$(mktemp -d)
  while IFS= read -r f; do
    out=$(bundle exec asciidoctor -v -S unsafe -o "$tmp/out.html" \
            -a idprefix= -a idseparator=- -a linkattrs=@ \
            -a source-highlighter=rouge -a icons=font -a toc=macro \
            -a sectanchors -a imagesdir=/images -a diagram-format=svg \
            "$f" 2>&1 | sed -n 's/.*possible invalid reference: //p' | sort -u)
    [[ -z "$out" ]] && continue
    while IFS= read -r id; do
      # Defined somewhere in the file? Then it resolves; only the order fooled
      # the reporter. Matches `[[id]]`, `[[id,reftext]]`, `[#id]` and `[#id.role]`.
      rx=$(printf '%s' "$id" | sed 's/[.[\*^$\\]/\\&/g')
      grep -qE "\[\[${rx}(,|\]\])|\[#${rx}([],.%#])" "$f" && continue
      printf '  %s: <<%s>> resolves to nothing\n' "$f" "$id"
      found=1
    done <<< "$out"
  done < <(find site -name '*.adoc' | sort)
  rm -rf "$tmp"
  ((found)) && { echo "each reference above has no matching anchor or section title"; return 1; }
  echo "every <<xref>> resolves"
  return 0
}
run "xrefs" check_xrefs

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
