---
title: Syntax Overview
parent: Developer Guide
nav_order: 1
---
# ⚇ ddot.it &ndash; Syntax Overview

This page conveys the **rough structure** of ddot.it — the shape of the syntax, not its details.
For the exact rules, read the normative
[Parse Specification](spec/ddot-it-parse.html): it carries the token alphabet, the formal grammar
(EBNF, in `site/spec/ddot.it-parsing.ebnf`), the parse state automaton, the AST and the triple
event format.

Related normative documents: the
[Vocabulary](spec/ddot-it-vocabulary.html),
[Highlight](spec/ddot-it-highlight.html) and
[Autocomplete](spec/ddot-it-autocomplete.html) specifications. In case of doubt, the golden
corpus at `test-data/cases/` has the last word.

## The whole syntax in five operators

ddot.it is line-oriented. A document is a sequence of lines, and a line is either a triple or
ordinary text that is passed over. There is no document structure, no nesting, no escaping.

| Operator | Name | Role |
|----------|------|------|
| `..`     | double dot     | delimits the relation: `subject ..relation.. object` |
| `....`   | quad dot       | an untyped link — the relation is `links to` |
| `,,`     | double comma   | attaches metadata to the triple on its left |
| `;;`     | double semicolon | separates metadata entries on one line |
| `!!`     | double bang    | introduces a command |

Each is a run of **exactly** that many characters. One dot, three dots, a lone comma — ordinary
text. That is why `Node.js`, `Mr. Smith` and `U.S.A.` carry no operator and prose is safe.

## Triples

```
Project Eagle ..started in.. 2024
Project Eagle .... Moonshot
```

The object is mandatory. Fields may contain spaces; only the operators delimit them, and
surrounding whitespace is stripped. Omit the subject and the previous line's subject continues:

```
Project Eagle ..started in.. 2024
..doc site.. example.com/docbase/8dcjsid
```

## Metadata

`,,` attaches **entries** to a triple. An entry is either a (relation, object) pair or a
free-text note, and the two mix freely in any order. Inline, entries are separated by `;;`:

```
John Doe ..leads.. Project Eagle ,, ..since.. 2025 ;; a note ;; ..until.. 2027
```

In block form the triple line ends with `,,`, entries go one per line, and a `,,` on its own line
closes it. Newlines separate the entries there, so `;;` is ordinary text inside a block — which
is how you write a note that has to contain one:

```
Dirk Hagemann ..works at.. SAP ,,
..year.. 2010
a free-text note
,,
```

A note carries the built-in relation `text`; the untyped `,, .... value` form carries `links to`.
See the [Vocabulary Specification](spec/ddot-it-vocabulary.html).

## Commands

A command is a URL under `ddot.it/`, with four interchangeable spellings — `!!name`,
`ddot.it/name`, `http://ddot.it/name`, `https://ddot.it/name`. The **slash and a name are
required**; bare `ddot.it` is a document marker, not a command.

- [`ddot.it/this`](this.md) — the current document, as a triple subject
- [`ddot.it/off`](off.md) and [`ddot.it/on`](on.md) — exclude a region from parsing
- [`ddot.it/block`](block.md) — take the following lines verbatim as one field's value

`!!off`, `!!on` and `!!block` act before parsing; every other command is just part of the text of
the field holding it.

## Syntax example

```
Project Eagle..started in.. 2024
..doc site .. example.com/docbase/8dcjsid
John Doe..leads.. Project Eagle ,, ..since.. 2025
Project Eagle....Moonshot
```
This text is interpreted as this knowledge graph:

<p style="text-align: center;">
  <img src="images/triple-structure.svg" alt="Example" style="width: 65%" />
</p>

## Where the details are

| Topic | Document |
|-------|----------|
| Token alphabet, whitespace, counting rule | [Parse Spec — Lexical Layer](spec/ddot-it-parse.html#lexical_layer) |
| Formal grammar (EBNF) | `site/spec/ddot.it-parsing.ebnf`, included in [Parse Spec — Grammar](spec/ddot-it-parse.html#grammar) |
| Parse state automaton, AST | [Parse Spec](spec/ddot-it-parse.html#state-automaton) |
| Triple event JSON | [Parse Spec — Triple Events](spec/ddot-it-parse.html#events) |
| Relation names and their meaning | [Vocabulary Specification](spec/ddot-it-vocabulary.html) |
| Worked examples, input → events | `llms.txt` and `test-data/cases/` |
