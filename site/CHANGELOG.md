# CHANGELOG


## Version 1.3
Unreleased (as of 2026-07-01)

- **Relaxed operator parsing so objects may contain `..`.** A `..` (or `....`)
  is only an operator where it delimits a triple slot; everything after the
  relation's closing `..` is the object, taken verbatim. This makes relative
  paths and similar values legal objects, e.g.
  ```
  a ..path.. ../../foo.txt
  ```
  is the triple (`a`, `path`, `../../foo.txt`). The **space** separating the
  relation's closing `..` from an object that itself begins with `..` is what
  keeps this unambiguous (`..path..` `../../foo.txt`, not `..path....../…`).
  See the [Parse Specification](spec/ddot-it-parse.html) for the exact rule.

- **Inline metadata now captures multiple pairs, separated by `;;`.** A single
  inline metadata section may state several `..type.. value` pairs after `,,`,
  each separated by a double semicolon:
  ```
  aaa ..bbb.. ccc ,, ..since.. 2010 ;; ..until.. 2020
  ```
  attaches both `{since: 2010}` and `{until: 2020}`. Previously only one pair
  was recognised (and a line with more than one was dropped entirely). This is a
  change in metadata semantics.

  The separator is **required**. A metadata value runs to the end of the line or
  to the next `;;`, and may itself contain `..`, so without the separator
  ```
  aaa ..bbb.. ccc ,, ..since.. 2010 ..until.. 2020
  ```
  is a single pair whose value is the literal text `2010 ..until.. 2020`.
  (Inside a multi-line `,,` block there is no separator at all: each value there
  runs to the end of its own line, so a `;;` is ordinary text.)

- **Dropped the planned `ddot.it/verbatim` command.**
  [`ddot.it/block`](https://ddot.it/block) already takes its body verbatim —
  no triples, metadata or commands are recognized inside it — so a second
  escaping command would have been a redundant way to say the same thing.

## Version 1.2
Released on 2026-06-22

- Added `ddot.it/label` command, which is used as a relation.
- Define how ddot.it handles binaries

## Version 1.1
Released on 2026-06-18

- Added [`ddot.it/block`](https://ddot.it/block) command
- New `has content` relation
- Added custom element syntax (`<ddot-it>`) to [HTML reader](reader-html.md)

## Version 1.0
Released on 2026-02-20

* Core triple syntax with `..`
* Meta data with `,,`
* Command with `https://ddot.it/` or `!!`
* Initial [relations list](https://ddot.it/rel)
