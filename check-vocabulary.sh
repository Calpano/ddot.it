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
# Indexing is done by @calpano/ddot-parser (npx), the canonical JavaScript
# parser, whose token and event streams are asserted against the same
# cross-implementation corpus as the TextMate grammar. Override the command with
# $DDOT_INDEX to run a local checkout instead of the published package.
set -euo pipefail
cd "$(dirname "$0")"

SPEC=site/spec/ddot-it-vocabulary.adoc
GOLDEN=site/spec/ddot-it-vocabulary.ddot

update=false
[[ "${1:-}" == "--update" ]] && update=true

# --- locate the indexer ----------------------------------------------------
# Default: the published package, so this repository needs no sibling checkout
# and no access to any other repository. A local parser/ checkout can be used
# instead:  DDOT_INDEX="node ../ddot.it-syntax-tools/parser/bin/ddot-index.js"
if [[ -z "${DDOT_INDEX:-}" ]]; then
  if command -v npx >/dev/null 2>&1; then
    DDOT_INDEX="npx --yes @calpano/ddot-parser ddot-index"
  else
    echo "error: npx not found, and \$DDOT_INDEX is unset." >&2
    echo "  Install Node.js, or set DDOT_INDEX to a ddot-index command." >&2
    exit 127
  fi
fi

# --- index the spec --------------------------------------------------------
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
actual="$tmp/actual.ddot"

$DDOT_INDEX "$SPEC" -o "$actual"

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
