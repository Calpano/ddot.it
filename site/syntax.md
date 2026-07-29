---
title: Syntax Specification
parent: Developer Guide
nav_order: 1
---
# ⚇ ddot.it &ndash; Syntax Specification

This page summarises the syntax. The **normative** definition is the
[Parse Specification](spec/ddot-it-parse.html) — where the two disagree, the Parse Specification
wins. Related normative documents: the
[Vocabulary](spec/ddot-it-vocabulary.html),
[Highlight](spec/ddot-it-highlight.html) and
[Autocomplete](spec/ddot-it-autocomplete.html) specifications.

## Codepoints
Ddot.it syntax assumes newline normalisation:

1. 'CR LF' -> NL;
2. Single 'LF' -> NL;
3. Single 'CR' -> NL.

| Name             |  Character  | Code Point | Usage                   |
|------------------|:-----------:|-----------:|-------------------------|
| Tab              |    `\t`     |          9 | Sometimes stripped      |
| Newline          | NL (LF, CR) |     10, 13 | Line separation         |
| Space            |     ` `     |         32 | Sometimes stripped      |
| Exclamation mark |     `!`     |         33 | Commands (`!!`)         |
| Comma            |     `,`     |         44 | Metadata                |
| Dot              |     `.`     |         46 | Triples                 |
| Semicolon        |     `;`     |         59 | Metadata pair separator |

## Tokens
Symbol characters (`.`, `,`, `;`, `!`) are grouped into **maximal runs** of the same character,
and a run is a special token only at its special length:

| Token | Meaning                       | Regex                |
|-------|-------------------------------|----------------------|
| `DT2` | exactly two dots              | `(?<!\.)\.{2}(?!\.)` |
| `DT4` | exactly four dots             | `(?<!\.)\.{4}(?!\.)` |
| `CM2` | exactly two commas            | `(?<!,),{2}(?!,)`    |
| `SC2` | exactly two semicolons        | `(?<!;);{2}(?!;)`    |
| `EM2` | exactly two exclamation marks | `(?<!!)!{2}(?!!)`    |
| `TX`  | everything else               | —                    |

Every other run — a single `.`, three or five dots, a lone `,` — is ordinary text (`TX`).
So `Node.js`, `Mr. Smith` and `U.S.A.` are plain values containing no operator.

## Grammar
A document is simply a sequence of lines. There is **no** chunking construct: an omitted subject
continues the subject of the previous line.

```
Snippet     := Line*

// Ordered choice: a Line is a Triple if one can be derived, otherwise NotATriple.
Line        := WS* Triple WS* NL
              | NotATriple NL

NotATriple  := (WS | DT2 | DT4 | CM2 | SC2 | EM2 | TX)*

DoubleDot   := WS* DT2 WS*
QuadDot     := WS* ( DT4 | DT2 WS+ DT2 ) WS*

Triple      := Subject?
               ( DoubleDot Relation DoubleDot | QuadDot )
               Object
               WS* Meta?

Subject     := TextExcept{NL,DT2,DT4}
Relation    := TextExcept{NL,DT2,DT4}
Object      := TextExcept{NL,CM2}
```

- `Subject?` is optional: an omitted subject means _continue with the subject of the previous line_.
- `Object` is mandatory and non-empty: `a ..b..` with nothing after the closing `..` is not a triple.
- `QuadDot` is the shorthand for an implicit relation: `a....b` and `a .. .. b` both mean
  `a ..links to.. b`. The two spellings are the same operator, not two operators.
- Space and Tab are stripped from the start and end of every field, so
  `Dirk Hagemann   .. works at ..  Big Corp` yields (`Dirk Hagemann`, `works at`, `Big Corp`).
  A field **may contain spaces** — only the operators delimit it.

### Metadata

```
Meta              := CM2 WS* MetaInline WS*
                   | MetaBlockOpen NL (MetaBlock NL)? WS* CM2 WS*

MetaBlockOpen     := CM2 | NL WS* CM2

MetaInline        := ( MetaTripleInline (SC2 MetaTripleInline)* )
                   | MetaTextInline

MetaTripleInline  := DoubleDot MetaRelation DoubleDot MetaObjectInline
                   | QuadDot MetaObjectInline

MetaBlock         := MetaTripleInBlock (NL MetaTripleInBlock)*
                   | MetaTextBlock
```

- `;;` separates **inline** metadata pairs: `,, ..since.. 2025 ;; ..until.. 2027` is two pairs.
  Inside a `,,` block a `;;` is ordinary text, because a block's metadata object runs to the end
  of its line.
- A metadata part holds **either** triples **or** free text, never both. Free text carries the
  built-in relation `text`; the untyped `,, .... value` form carries `links to`. See the
  [Vocabulary Specification](spec/ddot-it-vocabulary.html).

### Commands
A command has four interchangeable spellings, and the **slash is required** — bare `ddot.it` is a
document marker, not a command:

```
command-begin := ( 'https://ddot.it/' | 'http://ddot.it/' | 'ddot.it/' | '!!' )
command       := command-begin command-name uri-query? uri-fragment?
command-name  := one or more characters that are not WS, NL, '?' or '#'
uri-query     := '?' then any characters up to WS, NL or '#'
uri-fragment  := '#' then any characters up to WS or NL
```

`?` and `#` do **not** terminate a command — they introduce its query and fragment, so
`!!block?end=EOS` is one command. A command is part of the text of the field holding it, not a
replacement for it.

See [`ddot.it/on`](on.md), [`ddot.it/off`](off.md), [`ddot.it/this`](this.md) and
[`ddot.it/block`](block.md).

## Syntax Example

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
