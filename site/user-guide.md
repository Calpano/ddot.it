---
title: User Guide
nav_order: 1
---
# ⚇ ddot.it &ndash; User Guide
## Contents

<!-- TOC -->
* [⚇ ddot.it &ndash; User Guide](#-ddotit--user-guide)
  * [Contents](#contents)
  * [About this Document](#about-this-document)
  * [Syntax Elements](#syntax-elements)
  * [Typed Link](#typed-link)
  * [Untyped Link](#untyped-link)
  * [Additional Properties](#additional-properties)
  * [Metadata](#metadata)
  * [Commands](#commands)
    * [File Type Indicator](#file-type-indicator)
    * [Include and Exclude](#include-and-exclude)
      * [Include Command](#include-command)
      * [Exclude Command](#exclude-command)
    * [Include/Exclude Regions](#includeexclude-regions)
    * [This Command](#this-command)
  * [Relation Types](#relation-types)
<!-- TOC -->

## About this Document
- Version: 1.2
- Release Date: 2026-07-28
- see [Changelog](/changelog)

## Syntax Elements
- Double dot (`..`) → [typed links](#typed-link)
- Quad dot (`....`) → [untyped links](#untyped-link)
- Newline → [additional properties](#additional-properties)
- Double comma (`,,`) → [metadata](#metadata)
- URLs starting with `ddot.it` → [commands](#commands)
- Double exclamation mark (`!!`) → [commands](#commands)

NOTE: Spaces don't matter.
Any number of whitespace characters before and after the double dot is allowed — that means Tab
and every Unicode space separator, so a NBSP pasted in from Word or a PDF works exactly like a
plain space ([why](spec/ddot-it-parse.html#whitespace)).
There must be **exactly** two dots for a typed link. An untyped link is written either as exactly
four dots (`....`) or as two dot-pairs separated by whitespace (`.. ..`) — the same operator, two
spellings. A run of three or five dots is ordinary text, not an operator.

## Typed Link
- Syntax: `aaa .. bbb .. ccc`
- Effect: "aaa" links to "ccc" with link type "bbb"

Typed Link with Meta Data:
- Syntax: `aaa .. bbb .. ccc ,, ddd`
- Effect: "aaa" links to "ccc" with link type "bbb" and the whole link has meta-data "ddd" attached.

## Untyped Link
Just leave out the type.

- Syntax: `aaa .... ccc`
- Effect: "aaa" links to "ccc" with default link type "links to"

Untyped Link with Meta Data
- Syntax: `aaa .... ccc ,, ddd`
- Effect: "aaa" links to "ccc" and the whole link has meta-data "ddd" attached.

## Additional Properties
To state more properties on the same subject (`aaa`) add more lines leaving out the subject.

Syntax:
```
Dirk Hagemann .. works at .. SAP
.. knows .. Claudia Stern
.. is part of .. NEPOMUK
.. phone.. 123-456-789
```

## Metadata
It is possible to use triple syntax in the metadata part.
The triple is the subject of the following triples.
To add a lot of metadata, just use `,,` behind a triple or on a new line, followed by a newline, then as many meta lines as you need, terminated with a single `,,` line.

The metadata itself can be

- a single string (`we need to check with Mr. Smith`)
- annotating the preceding triple (typed: `..since.. 2010`; simple: `.... Project Eagle`)

Short Metadata:
```
Dirk Hagemann .. works at .. SAP ,, ..year..2010
```

Several inline metadata pairs are separated with a double semicolon (`;;`):
```
John Doe ..leads.. Project Eagle ,, ..since.. 2025 ;; ..until.. 2027
```
(Inside a multi-line `,,` block a `;;` is ordinary text, because there each metadata value runs
to the end of its line.)

Longer Metadata:
```
Dirk Hagemann .. works at .. SAP ,,
..year..2010
..fictive.. yes
..project.. NEPOMUK
,,
```


## Commands
Commands allow fine-tuning ddot.it behavior.

- `ddot.it/` can be abbreviated with `!!` (double exclamation mark), but the longer form is self-documenting (URL explains more)


### File Type Indicator
- Syntax: `ddot.it`
- Effect: Marks a document as double-dotted. Helps human readers and agents to find the documentation.

### Include and Exclude
**By default a ddot reader scans every file it is given.** ddot.it is meant to augment any text
you already have, so requiring a marker would mean missing most of it: triples are found and
reported wherever they occur.

The `ddot.it` marker and the `ddot.it/on` command therefore do *not* switch parsing on. They are
hints for humans and agents, and they only select files when a reader is explicitly run in the
optional **"exclude non-marked files"** mode.

Within a file, `ddot.it/off` and `ddot.it/on` always apply — see
[Include/Exclude Regions](#includeexclude-regions).

#### Include Command
- Syntax: `ddot.it/on` (or `!!on`)
- Effect: Resume ddot.it processing from this line on.

#### Exclude Command
- Syntax: `ddot.it/off` (or `!!off`)
- Effect: Stop ddot.it processing from this line on. Nothing between an `off` and the next `on`
  is parsed — not even commands.

### Include/Exclude Regions
A document may use multiple `on` ([include](#include-command)) and `off` ([exclude](#exclude-command)) commands, indicating regions for double dot processing. The command goes from start of document until the end of the doc or a counter-command.


### This Command
- Syntax: `ddot.it/this`
- Effect: Use this command the the subject (first part of a triple) to annotate the current document.


## Relation Types
For common relation names, see [Common Relation Names](/relations).

