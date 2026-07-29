# Canonical token vocabulary

Token names used by `cases/*/expected.tokens.json`. Each implementation
maps its native scope/style names onto these canonical names.

**Scope — this file is normative for the _role_ layer only.** It defines what a
highlighter emits: which span is a `subject`, a `relation`, an `object`. It sits
on top of a *lexical* layer — the token alphabet (`DT2`, `DT4`, `CM2`, `SC2`,
`EM2`, `TX`, `WS`, `NL`), the grammar over it, and the parsing state machine —
which is specified normatively in
`ddot.it-java/doc/ddot.it-information-model.adoc`, and summarised for
highlighting purposes in `ddot.ebnf` next to this file. Where the two describe
the same thing, `cases/` decides.

| Token            | What it covers                                         | TextMate scope                            |
|------------------|--------------------------------------------------------|-------------------------------------------|
| `subject`        | First slot of a triple                                 | `entity.name.subject.ddot`                |
| `relation`       | Predicate slot of a typed triple                       | `entity.name.relation.ddot`               |
| `object`         | Object slot                                            | `entity.name.object.ddot`                 |
| `doubledot`      | `..`, `....` or `.. ..` separator                      | `keyword.operator.doubledot.ddot`         |
| `command`        | `ddot.it`, `ddot.it/<word>`, `!!`, `!!<word>`          | `keyword.control.command.ddot`            |
| `command-param`  | A command's query or fragment (`?end=`, `#frag`)       | `variable.parameter.command.ddot`         |
| `meta-delim`     | `,,` opening or closing metadata                       | `punctuation.section.meta.ddot`           |
| `meta-separator` | `;;` between inline (relation, object) pairs           | `punctuation.separator.meta.ddot`         |
| `meta-doubledot` | `..` / `....` inside metadata                          | `keyword.operator.doubledot.meta.ddot`    |
| `meta-relation`  | Predicate inside metadata                              | `entity.name.relation.meta.ddot`          |
| `meta-object`    | Object inside metadata                                 | `entity.name.object.meta.ddot`            |
| `meta-text`      | Free-form text inside a `,,` block (no triple match)   | `entity.name.object.meta.text.ddot`       |
| `excluded`       | Body of an `off`–`on` span (markers stay `command`)    | `comment.block.excluded.ddot`             |
| `verbatim`       | Body of a `!!block` span (opener stays `command`)      | `string.unquoted.block.ddot`              |
| `block-end`      | The `!!block?end=` marker — **both** occurrences        | `variable.parameter.block-end.ddot`       |

The scope column is normative for the canonical grammar,
`../ddot.it-syntax-tools/textmate/ddot.tmLanguage.json`; the mapping is applied in
reverse by that repository's `tools/conformance-textmate.mjs`. Metadata deliberately shares the
`entity.name.*` / `keyword.operator.*` roots with the main triple, so it renders as
**first-class content**, not as a comment. The trailing `.meta` component exists only
so a theme *can* single metadata out later.

## Rules

- **Quoted strings (`"..."`)** are NOT a separate token. Double quotes are
  legal, uninterpreted characters and belong to whichever slot encloses them
  (subject/relation/object/meta-*).
- **Whitespace** between tokens is not tokenized.
- **The `.. ..` operator form** is one `doubledot` token spanning the full
  literal `.. ..` (inner whitespace included). It is semantically
  equivalent to `....` — both denote an untyped link.
- **Commands inside slots**: when a slot text exactly matches a command form
  (e.g. `ddot.it/this` as a subject), it is emitted as `command`, not
  `subject`. In scope terms the command scope nests *inside* the slot scope,
  and the deepest scope wins.
- **Excluded span markers**: the off-marker (`ddot.it/off` or `!!off`) and
  the on-marker (`ddot.it/on` or `!!on`) themselves are emitted as
  `command`. Everything in between is one or more `excluded` tokens (one
  per non-empty line).
- **Verbatim span**: the `!!block` opener is a `command` in the object slot;
  each non-empty line until the terminator is one `verbatim` token. The
  terminator is the first blank line, or the literal `MARKER` line when the
  opener was `!!block?end=MARKER` (in which case blank lines do *not* end it).
  Neither terminator is itself `verbatim`.
- **`!!block?end=MARKER` yields three tokens**, not one: `command` (`!!block`),
  `command-param` (`?end=`) and `block-end` (`MARKER`). The closing marker line
  is a fourth `block-end`, so opener and terminator share a role and can be
  styled as a matching pair. The marker matches only as a whole line, compared
  literally after trimming surrounding whitespace. See
  [the `?end=` parameter](https://ddot.it/spec/ddot-it-parse.html#block-end-marker).
- **Every slot is whitespace-trimmed**, inline and block alike. Free-form meta
  text after a `,,` starts at its first non-whitespace character: the grammar
  writes `Meta := CM2 WS* MetaInline WS*`, so the space between `,,` and the
  text belongs to neither token.
