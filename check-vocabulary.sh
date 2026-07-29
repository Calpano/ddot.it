#!/usr/bin/env bash
# Verify that the vocabulary spec yields exactly the checked-in built-in triples.
#
# The spec turns ddot.it parsing off for the whole document and switches it on only
# around the built-in blocks (see "Declaration Conventions"). Indexing it must
# therefore produce the built-ins and nothing else -- no prose, no `link:` macros,
# no examples. This script asserts that.
#
# Usage:
#   ./check-vocabulary.sh            # verify; non-zero exit on mismatch
#   ./check-vocabulary.sh --update   # accept the current output as the new baseline
#
# The ddot CLI is looked up in $DDOT, then ../ddot.it-java/ddot, then $PATH.
set -euo pipefail
cd "$(dirname "$0")"

SPEC=site/spec/ddot-it-vocabulary.adoc
GOLDEN=site/spec/ddot-it-vocabulary.ddot

update=false
[[ "${1:-}" == "--update" ]] && update=true

# --- locate the ddot CLI ---------------------------------------------------
if [[ -z "${DDOT:-}" ]]; then
  if [[ -x ../ddot.it-java/ddot ]]; then
    DDOT=../ddot.it-java/ddot
  elif command -v ddot >/dev/null 2>&1; then
    DDOT=$(command -v ddot)
  else
    echo "error: ddot CLI not found." >&2
    echo "  Set \$DDOT, or check out https://github.com/Calpano/ddot.it-java" >&2
    echo "  next to this repo and run its ./build-ddot.sh" >&2
    exit 127
  fi
fi

# --- index the spec --------------------------------------------------------
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
actual="$tmp/actual.ddot"

"$DDOT" index -f "$actual" --ext adoc "$SPEC" >/dev/null

count=$(grep -c . "$actual" || true)
if [[ "$count" -eq 0 ]]; then
  echo "error: indexing $SPEC produced no triples at all." >&2
  echo "  A stray https://ddot.it/off probably swallowed the built-in blocks." >&2
  exit 1
fi

# --- compare ---------------------------------------------------------------
if $update; then
  cp "$actual" "$GOLDEN"
  echo "updated $GOLDEN ($count triples)"
  exit 0
fi

if diff -u "$GOLDEN" "$actual" > "$tmp/diff"; then
  echo "OK: $SPEC yields exactly the $count built-in triples in $GOLDEN"
  exit 0
fi

echo "FAIL: triples indexed from $SPEC differ from $GOLDEN" >&2
echo >&2
sed -e "s|^--- .*|--- $GOLDEN (checked in)|" \
    -e "s|^+++ .*|+++ indexed from $SPEC|" "$tmp/diff" >&2
echo >&2
echo "A '+' line that is prose, a link: macro or an example means the text escaped" >&2
echo "the https://ddot.it/off gating. A '-' line means a built-in was lost or renamed." >&2
echo "If the change is intended, run: ./check-vocabulary.sh --update" >&2
exit 1
