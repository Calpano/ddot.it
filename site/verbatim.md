---
title: "ddot.it/verbatim"
permalink: /verbatim
nav_exclude: true
---
# ddot.it/verbatim

`ddot.it/verbatim` is a [command](user-guide.md#commands) that takes its object **verbatim**: special
tokens such as `,,` (metadata) and `..` (operators), and even other commands, are **not** interpreted —
they are literal characters of the object value.

Use it when an object must contain characters that ddot.it would otherwise interpret.

You can abbreviate `ddot.it/verbatim` as `!!verbatim`.

## Inline form

Place the command in the object; everything after it on the line is taken verbatim. **Exactly one
whitespace immediately after the verbatim command is always removed.**

```
a ..knows.. typography !!verbatim?,, nerd
```
is the triple

- subject: `a`
- predicate: `knows`
- object: `typography ,,nerd`

The `,,` is a literal part of the object, not a metadata separator.

## Block form

If a line **ends** with `!!verbatim`, then all following lines, up to the first blank line, are taken
verbatim and joined into the object value. The verbatim block always starts on the **next** line.

```
a ..knows.. !!verbatim
line one ,, still literal
line two .. also literal

```
Here the object is `line one ,, still literal\nline two .. also literal` — the `,,` and `..` are literal.

### Default end marker
The default block end marker is a blank (whitespace-only) line.

### Custom end marker
A custom end line can be set with `!!verbatim?end=MY-END`. The end-marker line is not included in the
value. Anything after the command **on the same line is ignored**:

```
a ..knows.. !!verbatim?end=FOO bar baz
the value starts here
,, and .. are literal
FOO
```
Here `bar baz` are ignored; the object is `the value starts here\n,, and .. are literal`.

## Newlines
As with [`ddot.it/block`](/block), newlines **between** the content lines are included in the value
string as Unicode `\n`; the end marker (blank line or custom) is not.

## Relation to `ddot.it/block`
[`ddot.it/block`](/block) builds a multi-line string value. `ddot.it/verbatim` additionally **escapes**
ddot.it syntax (`,,`, `..`, commands) within the object — inline (rest of line) or as a block. Use
`verbatim` whenever the value would otherwise be mis-read as metadata, an operator, or a command.

## Further Reading
See the [User Guide](user-guide.md#commands) and [`ddot.it/block`](/block).
