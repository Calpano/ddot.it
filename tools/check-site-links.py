#!/usr/bin/env python3
"""Fail the build on a broken internal link in the generated site.

    python3 tools/check-site-links.py _site
    python3 tools/check-site-links.py --self-test

Why this exists, and why it works the way it does — every point below is a
failure mode that was actually hit while writing it:

1. It runs on the BUILT SITE, not on the sources. Asciidoctor has no
   source-level validation of cross-references: an unresolved `<<foo>>` is
   reported by no warning, no `-v`, and no `--failure-level`. It renders as an
   ordinary-looking link. The built HTML is the only place the truth shows up,
   and it also covers Markdown and the theme's own navigation in one pass.

2. It checks SAME-PAGE anchors (`href="#x"`). Skipping them is tempting — they
   look local and harmless — and it hides the single most common defect:
   an anchor that silently failed to register (see 4).

3. It checks ANCHORS, not just files. `foo.html` existing says nothing about
   whether `#bar` is in it.

4. It resolves SITE-ABSOLUTE paths (`/spec/x.html`) against the site root, and
   DIRECTORY urls (`/spec/`) to `index.html`. Getting either wrong produces a
   flood of false positives from the nav — which trains you to ignore the tool.

5. It SELF-TESTS (`--self-test`). A link checker that cannot fail proves
   nothing, and two earlier attempts at this check passed happily while real
   breakage sat in the tree.

Common AsciiDoc mistakes it catches, none of which warn at build time:
  * `[[a]]` and `[[b]]` on consecutive lines — only the LAST one registers.
  * `[[a]]` directly before a list item — does not attach; use an inline anchor.
  * `<<Block Title>>` — a `.Block Title` is not a cross-reference target; only
    section titles and explicit ids are.
  * an anchor placed AFTER its section title — it lands on the next block.
"""

from __future__ import annotations

import os
import re
import sys
import tempfile
from pathlib import Path

ID_RE = re.compile(r'\sid="([^"]+)"')
HREF_RE = re.compile(r'\shref="([^"]+)"')
SKIP_SCHEME = ("http://", "https://", "mailto:", "javascript:", "data:", "tel:")


def collect(site: Path) -> dict[str, set[str]]:
    """Map each page's site-absolute path to the set of ids it defines."""
    ids: dict[str, set[str]] = {}
    for path in site.rglob("*.html"):
        key = "/" + path.relative_to(site).as_posix()
        ids[key] = set(ID_RE.findall(path.read_text(encoding="utf-8", errors="replace")))
    return ids


def resolve(href: str, page: str) -> str | None:
    """Site-absolute path a link points at, or None if it is not ours to check."""
    target, _, _ = href.partition("#")
    if target == "":
        return page                                   # same-page anchor
    if target.endswith("/"):
        target += "index.html"                        # permalink directory
    if not target.endswith(".html"):
        return None                                   # assets, feeds, downloads
    if target.startswith("/"):
        return os.path.normpath(target)
    return "/" + os.path.normpath(os.path.join(os.path.dirname(page.lstrip("/")), target))


def check(site: Path) -> list[str]:
    ids = collect(site)
    broken: list[str] = []
    for path in sorted(site.rglob("*.html")):
        page = "/" + path.relative_to(site).as_posix()
        html = path.read_text(encoding="utf-8", errors="replace")
        for href in HREF_RE.findall(html):
            if not href or href.startswith(SKIP_SCHEME):
                continue
            key = resolve(href, page)
            if key is None:
                continue
            anchor = href.partition("#")[2]
            if key not in ids:
                broken.append(f"{page} -> {href}   (no such page: {key})")
            elif anchor and anchor not in ids[key]:
                broken.append(f"{page} -> {href}   (no such anchor: #{anchor})")
    return broken


def self_test() -> int:
    """Prove the checker can fail: it must find exactly the planted breakage."""
    with tempfile.TemporaryDirectory() as tmp:
        site = Path(tmp)
        (site / "spec").mkdir()
        (site / "index.html").write_text(
            '<a href="/spec/">dir url</a>'                    # ok -> spec/index.html
            '<a href="spec/page.html#real">rel+anchor</a>'    # ok
            '<a href="#self">same page</a>'                   # ok
            '<a id="self"></a>'
            '<a href="https://example.com/x.html">ext</a>'    # ignored
            '<a href="/assets/app.css">asset</a>'             # ignored
            '<a href="/nope.html">bad page</a>'               # BROKEN
        )
        (site / "spec" / "index.html").write_text("<h1>spec</h1>")
        (site / "spec" / "page.html").write_text(
            '<h2 id="real">Real</h2><a href="#ghost">bad anchor</a>'  # BROKEN
        )
        found = check(site)
        want = {"no such page: /nope.html", "no such anchor: #ghost"}
        got = {f.split("(")[1].rstrip(")") for f in found}
        if got == want:
            print("self-test: PASS (detects a bad page and a bad anchor; "
                  "ignores external, assets, and valid dir/relative/same-page links)")
            return 0
        print(f"self-test: FAIL\n  expected {sorted(want)}\n  got      {sorted(got)}")
        for f in found:
            print("   ", f)
        return 1


def main() -> int:
    args = sys.argv[1:]
    if "--self-test" in args:
        return self_test()
    if len(args) != 1:
        print(__doc__.strip().splitlines()[0])
        print("usage: check-site-links.py <site-dir> | --self-test")
        return 2
    site = Path(args[0])
    if not site.is_dir():
        print(f"not a directory: {site}")
        return 2
    if self_test() != 0:
        print("refusing to trust a checker that failed its own self-test")
        return 1
    broken = check(site)
    pages = sum(1 for _ in site.rglob("*.html"))
    if broken:
        print(f"\n{len(broken)} broken internal link(s) across {pages} page(s):\n")
        for b in broken:
            print("  " + b)
        return 1
    print(f"\nok: no broken internal links ({pages} pages)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
