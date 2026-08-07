# CHANGELOG


## Version 1.3
Released on 2026-08-07

### Reading and commands

- **Readers now scan every file by default.** Previously the default was "all
  marked documents" — those carrying `ddot.it` or `ddot.it/on`. ddot.it is meant
  to augment text you already have, so requiring a marker missed most of it:
  triples are found and reported wherever they occur. The `ddot.it` marker and
  the `ddot.it/on` command no longer switch parsing on; they are hints for humans
  and agents, and select files only when a reader is explicitly run in the
  optional *exclude non-marked files* mode.

- **`ddot.it/off` and `ddot.it/on` are recognised anywhere on a line**, not only
  when alone on one. This is what makes them usable in the documents ddot.it is
  designed to annotate, where a command normally sits inside a host-language
  comment:
  ```
  <!-- ddot.it/off -->
  # ddot.it/off
  // !!on
  ```
  Only the command itself is highlighted; the line yields no triple, and the
  region begins on the **next** line. The command *name* is still matched
  exactly, so `!!office` is not `!!off`.

  **Caution:** any line containing the command triggers it — including prose
  *about* the command. A document that discusses ddot.it syntax should keep such
  mentions inside a [`ddot.it/block`](https://ddot.it/block), where commands are
  inert, or accept that the rest of the file is excluded.

- **A command requires the slash and a name.** Bare `ddot.it` is a *document
  marker*, not a command. The four spellings `https://ddot.it/NAME`,
  `http://ddot.it/NAME`, `ddot.it/NAME` and `!!NAME` are interchangeable. `?` and
  `#` no longer terminate a command — they introduce its query and fragment, so
  `!!block?end=EOS` is a single command. A command is part of the text of the
  field holding it, not a replacement for that field.

### Syntax

- **There is no block or chunking construct, and the subject never resets.** The
  grammar previously chunked text at three consecutive newlines and reset the
  current subject and meta-mode at each chunk boundary. A document is simply a
  sequence of lines; an omitted subject continues the subject of the previous
  line, across blank lines and to the end of the file.
  ```
  Alice ..knows.. Bob

  ..likes.. Tea
  ```
  states `Alice ..likes.. Tea`.

- **Whitespace is Tab plus every Unicode space separator.** `WS` was space and tab; it is now
  `[\t\p{Zs}]` — so NBSP (U+00A0), NARROW NO-BREAK SPACE (U+202F), IDEOGRAPHIC SPACE (U+3000) and
  the rest count as whitespace wherever a space does. These characters are *visually
  indistinguishable* from a space and are inserted routinely by word processors, wikis, PDF
  copy-paste and macOS Option+Space; treating them as ordinary text silently produced a
  *different* node that looked identical to the intended one:
  ```
  Berlin ..has type.. City      ← a plain space
  Berlin ..has type.. City      ← a NBSP: previously the subject "Berlin<NBSP>"
  ```
  Zero-width characters (U+200B, U+FEFF) are category `Cf`, **not** `Zs`, and remain ordinary
  text — except a single leading U+FEFF, which is stripped as a byte-order mark during chunk
  preprocessing. Implementations must not rely on their language's built-in trim: JavaScript's
  over-strips U+FEFF, and Java's `String.strip` *excludes* U+00A0 and U+202F. See the
  [Parse Specification](spec/ddot-it-parse.html#whitespace).

- **Symbol runs are operators only at their exact length.** `.`, `,`, `;` and `!`
  are grouped into maximal runs; a run is a special token only at its special
  length (two dots, four dots, two commas, two semicolons, two exclamation
  marks). Every other run is ordinary text, so `Node.js`, `Mr. Smith`, `U.S.A.`
  and an ellipsis carry no operator and never form a triple by accident.

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

### Metadata

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

- **A `,,` part holds *entries*, and pairs and free-text notes mix freely.**
  An entry is either a (relation, object) pair or a note; both may occur, any
  number of times, in any order, and the event keeps the **written order**.
  Previously a metadata part was one or the other, never both.
  ```
  aaa ..bbb.. ccc ,, ..since.. 2016 ;; a note ;; .... Walldorf ;; ..until.. 2020
  ```
  is four entries: a typed pair, a note, an untyped pair, a typed pair. The same
  mix works in the block form, one entry per line. Corpus cases
  `36-inline-meta-notes`, `37-inline-meta-mixed`, `38-block-meta-notes`,
  `39-block-meta-mixed`.

- **`;;` separates inline entries unconditionally.** It ends a free-text note
  exactly as it ends a pair's object — there is no rule about what follows it and
  no lookahead:
  ```
  aaa ..bbb.. ccc ,, first note ;; second note
  ```
  is **two** notes. An earlier draft let a note carry a `;;` unless `..` or
  `....` followed; that made two notes impossible to write apart, gave the
  separator two meanings, and required an unbounded lookahead a single-line
  highlighter cannot express. The consequence: a note containing a literal `;;`
  cannot be written inline — use the `,,` … `,,` block form, where newlines
  separate the entries and `;;` is ordinary text everywhere
  (`28-semicolon-in-meta-block`).

- **Adjacent note lines in a `,,` block are one note**, joined by newlines, so a
  pasted paragraph survives intact. A pair line ends the run; the next text line
  after it starts a new note. Two *adjacent* notes are therefore not writable in
  a block — the inline `;;` form is how you write them apart.

- **Free metadata text carries the built-in relation `text`.** Prose after `,,`
  that holds no triple — inline or as a multi-line block — is a metadata entry
  whose type is `text`, not an untyped link:
  ```
  aaa ..bbb.. ccc ,, see also the appendix
  ```
  yields `{"type": "text", "to": "see also the appendix"}`. The untyped form
  `,, .... 2025` is the one meaning `links to`, and is emitted as
  `{"type": "links to", "to": "2025"}` — **written out**, not as a missing field.
  There are exactly two built-in relations: `text` and `links to`.

- **The logical line resumes after a `ddot.it/block`.** When a block fills a
  field, the line after the block's terminator continues that same triple if it
  starts with the token the interrupted position accepts — `..` after a block
  subject, `,,` after a block object, `;;` after a block meta object:
  ```
  john ..address.. ddot.it/block
  Broadway 1
  Berlin

  ,, ..year.. 2123
  ```
  attaches `year = 2123` to the `john ..address.. …` triple. Previously such a
  line was read as a *new* triple whose subject was the literal `,,` or `;;`.

- **A continuation line may itself open a block**, so one logical line can carry
  several blocks — for example a block subject *and* a block object:
  ```
  !!block
  Alice
  Anderson

  ..knows.. !!block
  Bob
  Baker
  ```
  reads as `Alice⏎Anderson ..knows.. Bob⏎Baker`.

- **A `ddot.it/block` body is the field's value.** Readers now emit the block's
  text as the subject, object or metadata object it fills. Previously the literal
  string `ddot.it/block` was emitted as the value and the body was dropped.

- **Dropped the planned `ddot.it/verbatim` command.**
  [`ddot.it/block`](https://ddot.it/block) already takes its body verbatim —
  no triples, metadata or commands are recognized inside it — so a second
  escaping command would have been a redundant way to say the same thing.

### Vocabulary

- **`property` and `relation` are types.** A relation can now be classified with
  `..has type.. property` (or `relation`), which is what lets a reader recover
  the *thing* / *value* distinction that ddot.it's single string datatype cannot
  express. See the [Vocabulary Specification](spec/ddot-it-vocabulary.html).

- **Cardinality**, borrowed from ECore, written as two independent bounds on the
  triple's metadata rather than as a range:
  ```
  Person ..has address.. Address ,, ..min cardinality.. 1 ;; ..max cardinality.. 3
  ```
  An omitted `max cardinality` means unbounded — there is no `*` or `-1`
  sentinel. The `cardinality` shorthand sets both bounds at once. A range must
  **not** be written as a single value such as `+1..3+`: it parses where it
  stands, but the same string used as a subject silently misparses.

### For implementers

- **The triple event format has one home and one key vocabulary.** The wire format is now
  specified normatively in the
  [Parse Specification](spec/ddot-it-parse.html#events) — fields, meta-pair shape, key order and
  escaping — and the Developer Guide section is a summary that links to it. The separate
  "collector document format", which stored the same triples under `sourceUri` plus `{s, p, o}`
  with `{p, o}` meta pairs, is **retired**: a triple is `from` / `type` / `to` on both sides of
  the pipe. Anything still emitting or consuming `s`/`p`/`o` needs updating.

- **`meta` is the only optional field on an event.** `type` is now **always written**: an
  untyped `....` link carries `links to` and a free-text note carries `text`, so a consumer never
  defaults a missing relation and a collector no longer has that resolution step. Emitters that
  omitted `type` for untyped links must change — with the field absent, `,, a note` and
  `,, .... a note` both collapsed to `{"to": "a note"}` and became indistinguishable. `meta`
  itself is omitted when empty, never emitted as `[]`, and each meta pair requires both `type`
  and `to`.

- **The grammar is written in the EBNF of [XML 1.0, section 6](https://www.w3.org/TR/xml/#sec-notation).**
  It lives in `site/spec/ddot.it-parsing.ebnf` and is included into the Parse Specification.
  `:=` became `::=`, `//` comments became `/* … */`, and the ad-hoc `TextExcept{…}` shorthand is
  gone — field bounds are now written with the notation's own subtraction operator (an `Object`
  is `Word - CM2`). `|` is still read as an ordered choice and `?`/`*`/`+` as greedy, which the
  file states explicitly.

- **`ddot.it/label` has no page of its own.** `label` is an ordinary relation, so it is
  documented with the other relations in the
  [Vocabulary Specification](spec/ddot-it-vocabulary.html#label); `https://ddot.it/label` no
  longer resolves.

- **`ddot.it/block` fills four positions, not three.** Subject, object, meta-object **and** the
  free meta text after `,,`. The meta-text form is redundant — the `,,` … `,,` block form already
  expresses a multi-line meta text — but it is permitted, because meta text is a value like the
  other three. It is still *not* an opener in a relation or a meta-relation, which hold names.
  The TextMate grammar gained the missing `block-metatext` rules; corpus case
  `34-block-meta-text` pins the position.

- **Canonical highlighter token names changed** in `test-data/tokens.md`:
  `operator` → `doubledot`, `meta-operator` → `meta-doubledot`, `disabled` →
  `excluded`, plus new `meta-separator`, `command-param`, `block-end` and
  `verbatim` tokens. Highlighters and themes keyed on the old names need
  updating. The golden corpus grew to 39 cases and is the conformance contract
  for all implementations.

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
