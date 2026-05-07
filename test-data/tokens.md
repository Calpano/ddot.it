# Canonical token vocabulary

Token names used by `cases/*/expected.tokens.json`. Each implementation
maps its native scope/style names onto these canonical names.

| Token            | What it covers                                              | TextMate scope hint                   |
|------------------|-------------------------------------------------------------|---------------------------------------|
| `subject`        | First slot of a triple                                      | `entity.name.subject.ddot`            |
| `relation`       | Predicate slot of a typed triple                            | `entity.name.relation.ddot`           |
| `object`         | Object slot                                                 | `entity.name.object.ddot`             |
| `operator`       | `..` or `....` separator                                    | `entity.name.operator.ddot`           |
| `command`        | `ddot.it`, `ddot.it/<word>`, `!!`, `!!<word>`               | `keyword.control.ddot`                |
| `meta-delim`     | `,,` opening or closing metadata                            | `punctuation.definition.comment.ddot` |
| `meta-operator`  | `..` / `....` inside metadata                               | child of `comment.metadata.ddot`      |
| `meta-relation`  | Predicate inside metadata                                   | child of `comment.metadata.ddot`      |
| `meta-object`    | Object inside metadata                                      | child of `comment.metadata.ddot`      |
| `meta-text`      | Free-form text inside a `,,` block (no triple match)        | `comment.metadata.ddot`               |
| `disabled`       | Body of an `off`–`on` span (markers stay `command`)         | `comment.block.disabled.ddot`         |

## Rules

- **Quoted strings (`"..."`)** are NOT a separate token. Double quotes are
  legal, uninterpreted characters and belong to whichever slot encloses them
  (subject/relation/object/meta-*).
- **Whitespace** between tokens is not tokenized.
- **The `.. ..` operator form** is one `operator` token spanning the full
  literal `.. ..` (inner whitespace included). It is semantically
  equivalent to `....` — both denote an untyped link.
- **Commands inside slots**: when a slot text exactly matches a command form
  (e.g. `ddot.it/this` as a subject), it is emitted as `command`, not
  `subject`. The slot is otherwise unmarked text.
- **Disabled span markers**: the off-marker (`ddot.it/off` or `!!off`) and
  the on-marker (`ddot.it/on` or `!!on`) themselves are emitted as
  `command`. Everything in between is one or more `disabled` tokens (one
  per non-empty line).
