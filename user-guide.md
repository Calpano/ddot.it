---
title: User Guide
nav_order: 1
---
# ⚇ ddot.it &ndash; User Guide
## Contents

<!-- TOC -->
* [⚇ ddot.it &ndash; User Guide](#-ddotit--user-guide)
  * [Contents](#contents)
  * [Syntax Elements](#syntax-elements)
  * [Typed Link](#typed-link)
  * [Untyped Link](#untyped-link)
  * [Additional Properties](#additional-properties)
  * [Metadata](#metadata)
  * [Commands](#commands)
    * [File Type Indicator](#file-type-indicator)
    * [Include and Exclude](#include-and-exclude)
      * [Include Command](#include-command)
      * [Exclude Command](#exclude-command-)
    * [Include/Exclude Regions](#includeexclude-regions)
    * [This Command](#this-command)
  * [Relation Types](#relation-types)
<!-- TOC -->

## Syntax Elements
- Double dot (`..`) → [typed links](#typed-link)
- Quad dot (`....`) → [untyped links](#untyped-link)
- Newline → [additional properties](#additional-properties)
- Double comma (`,,`) → [metadata](#metadata)
- URLs starting with `ddot.it` → [commands](#commands)
- Double exclamation mark (`!!`) → [commands](#commands)

NOTE: Spaces don't matter.
Any number of spaces (or NBSPs) before and after the double dot is allowed.
There must be exactly two dots for typed links and exactly four dots for untyped links.

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
A ddot reader can process

- All marked documents (all with `ddot.it` or `ddot.it/on`, but excluding `ddot.it/off` ) -- This is the default
- Only included documents (Only those with `ddot.it/on`)
- All documents (Overriding document commands for include/exclude)

#### Include Command
- Syntax: `ddot.it/on`
- Effect: Include document in double-dot-processing. 

#### Exclude Command 
- Syntax: `ddot.it/off`
- Effect: Exclude this document from double-dot-processing

### Include/Exclude Regions
A document may use multiple `on` ([include](#include-command)) and `off` ([exclude](#exclude-command)) commands, indicating regions for double dot processing. The command goes from start of document until the end of the doc or a counter-command. 


### This Command
- Syntax: `ddot.it/this`
- Effect: Use this command the the subject (first part( of a triple to annotate the current document.


## Relation Types
Some relations are so commonly used, we suggest some standard names here:

| Name          | Aliases                  | Semantics (A .. relation .. B)                                                                                                                                              |
|---------------|--------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `related`     | `rel`, <br/>`is related` | Undirected link connecting A and B.                                                                                                                                         |
| `same as`     | `is same as`             | A and B are referring to the same concept.                                                                                                                                  |
| `is alias of` |                          | Like `same as`, but with a clear main concept.<br/>This is like a sym-link.                                                                                                 |
| `links to`    | `link`,<br/>`see also`   | Directed, untyped link from A to B. <br/>Default link type when four dots (`....`) are used.                                                                                |
| `has tag`     | `tag`                    | A has the tag B. <br/>Tags are not transitive.                                                                                                                              |
| `has type`    | `type`,<br/>`is a`       | A has the type B. Like [rdf:type](https://www.w3.org/TR/rdf12-schema/#ch_type). <br/>Types are inherited via `has subtype`.                                                 |
| `has subtype` | `subtype`                | The type A has a more specialised type B.<br/>Transitive relation.<br/>If it forms a cycle, all participants of the cycle are considered to be the same entity (`same as`). |
