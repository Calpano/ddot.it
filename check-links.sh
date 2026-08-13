#!/usr/bin/env bash
# Fail on a reference in the built site that resolves to nothing.
#
# Usage:
#   ./check-links.sh              # internal links, anchors, images, assets
#   ./check-links.sh --external   # additionally dial out to every http(s) URL
#
# It runs on the BUILT SITE, not on the sources, because Asciidoctor has no
# source-level validation of cross-references: an unresolved `<<foo>>` produces
# no warning, no `-v` output and no `--failure-level` hit -- it renders as an
# ordinary-looking link. The built HTML is the only place the truth shows up,
# and it covers Markdown, AsciiDoc and the theme's own navigation in one pass.
#
# Mistakes this catches that nothing warns about at build time:
#   * `[[a]]` and `[[b]]` on consecutive lines -- only the LAST one registers.
#   * `[[a]]` directly before a list item -- does not attach; use an inline anchor.
#   * `<<Block Title>>` -- a `.Block Title` is not a cross-reference target; only
#     section titles and explicit ids are.
#   * an anchor placed AFTER its section title -- it lands on the next block.
#   * a `link:` macro pointing at a source path (`../CHANGELOG.md`): only
#     jekyll-relative-links rewrites those, and only inside Markdown pages,
#     never in AsciiDoc output.
#   * a link to a permalink that has since changed (`/relations` vs `/rel`).
#
# External checking is opt-in: it is slow and goes red when somebody else's
# server has a bad day, which is not a reason to block a deploy.
set -euo pipefail
cd "$(dirname "$0")"

SITE=_site

# The failure mode that makes a link checker worthless is passing because it
# found nothing to check. Assert the build actually landed before trusting a
# green result.
if [[ ! -f "$SITE/index.html" ]]; then
  echo "no $SITE/index.html -- run 'bundle exec jekyll build' first" >&2
  exit 2
fi

# --allow-missing-href: Asciidoctor emits `<a id="block-as-field"></a>` inline
# anchors, which are href-less by design and not broken links.
#
# --no-enforce-https: this checks whether a reference RESOLVES; whether a
# working external link should have been https is an editorial call, and
# enforce_https fires even under --disable-external, where nothing was dialed.
opts=(--allow-missing-href --no-enforce-https)

[[ "${1:-}" == "--external" ]] || opts+=(--disable-external)

bundle exec htmlproofer "$SITE" "${opts[@]}"
