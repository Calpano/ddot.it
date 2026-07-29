# CHANGELOG


## Version 1.3
Unreleased (as of 2026-07-01)
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
