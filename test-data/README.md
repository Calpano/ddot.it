# test-data

Cross-implementation golden corpus for ddot.it. One set of `.ddot` inputs,
multiple sibling `expected.<format>` files per case, each consumed by
multiple implementations to keep them in lockstep.

## Layout

```
test-data/
├── tokens.md                         # canonical highlighter token vocabulary
├── ddot.ebnf                         # lexical grammar
├── regenerate-html.rb                # writes expected.body.html (Ruby renderer)
└── cases/
    ├── 01-simple-triple/
    │   ├── input.ddot                # the .ddot source
    │   ├── expected.body.html        # body-only HTML preview (no <style>/<pre>)
    │   ├── expected.events.jsonl     # triple events per https://ddot.it/developer-guide.html#events
    │   └── expected.tokens.json      # canonical highlighter tokens (line/start/end/token/text)
    ├── 02-untyped-link/
    └── ...
```

Each case asserts (currently) three things; an implementation only needs
to consume the `expected.*` files relevant to its concern.

## `expected.body.html` — preview HTML

The **inner** role-classed `<span>` markup emitted by
`DdotIt::Render.body(input)`. It deliberately excludes:

- the surrounding `<style>` block (colour palette is configurable per
  call-site),
- the `<pre class="ddot-fence"><code>...</code></pre>` wrapper (Markdown vs
  AsciiDoc emit different shells).

Two implementations must produce byte-identical output:

1. **Ruby (canonical)** — `ddot.it-intellij/src/main/resources/com/calpano/ddot/asciidoc/ddot-render.rb`.
   `regenerate-html.rb` runs this to refresh `expected.body.html`. The same
   file is also installed into `<project>/.asciidoctor/lib/` by the IntelliJ
   plugin to render `[ddot]` blocks in the AsciiDoc preview.
2. **Java** — `com.calpano.ddot.preview.DdotMarkdownPreviewRenderer.body(...)`
   in the IntelliJ plugin. Renders `` ```ddot `` fences in the Markdown
   preview pane. The plugin's `PreviewHtmlGoldenTest` walks this corpus and
   asserts byte equality.

## `expected.events.jsonl` — triple events

The newline-separated event stream defined at
https://ddot.it/developer-guide.html#events, produced by
`com.calpano.ddot.export.DdotEventExporter` (the canonical Java parser, a
direct port of the VS Code extension's `parseDocument`). Fixed context
fields: `kind="ddot"`, `source="input.ddot"`. `location` is 1-based source
line.

Refresh after changing `DdotEventExporter`:

```sh
(cd ../ddot.it-intellij && mvn test -Dgolden.regen=true)
```

If a future Ruby (or other-language) parser is added, it must produce the
same JSONL for every case.

## `expected.tokens.json` — canonical highlighter tokens

The token stream a syntax highlighter must produce, as a flat array of
`{line, start, end, token, text}` (zero-indexed, end-exclusive). Whitespace
is not tokenized; lines that produce no tokens are absent. The set of
permitted `token` values is defined in [`tokens.md`](tokens.md). The
formal lexical grammar is in [`ddot.ebnf`](ddot.ebnf).

The canonical generator is the TextMate grammar at
`../../ddot.it-syntax-tools/textmate/ddot.tmLanguage.json` (published as
the npm package `@calpano/ddot-textmate-grammar`). The regenerator
script lives in the syntax-tools repo (it depends on `vscode-textmate`
+ `vscode-oniguruma`) at
`../../ddot.it-syntax-tools/tools/regenerate-tokens.mjs`. It writes back
into this corpus.

Other highlighter implementations (Pygments, Chroma, highlight.js, Prism,
Rouge, Shiki) live in `../../ddot.it-syntax-tools/` and are asserted to
produce the same canonical token stream after mapping their native scope
names. See `ddot.it-syntax-tools/tools/conformance-textmate.mjs` for the
current TextMate harness; one harness per ecosystem will land alongside.

Refresh after changing the TextMate grammar:

```sh
(cd ../ddot.it-syntax-tools && npm run regenerate:tokens)
```

## Workflow

```sh
# After changing the Ruby renderer (ddot-render.rb):
ruby test-data/regenerate-html.rb              # refresh expected.body.html
ruby test-data/regenerate-html.rb --check      # CI: fail on stale

# After changing DdotEventExporter:
(cd ../ddot.it-intellij && mvn test -Dgolden.regen=true)   # refresh expected.events.jsonl

# After changing the TextMate grammar (../ddot.it-vscode/syntaxes/…):
(cd ../ddot.it-syntax-tools && npm run regenerate:tokens)         # refresh expected.tokens.json
(cd ../ddot.it-syntax-tools && npm run regenerate:tokens:check)   # CI: fail on stale

# Normal test run (asserts HTML + JSONL):
(cd ../ddot.it-intellij && mvn test)
```

The regen scripts and `PreviewHtmlGoldenTest` expect `ddot.it`,
`ddot.it-intellij`, `ddot.it-vscode`, and `ddot.it-syntax-tools` to live
as siblings under the same parent directory. Override the path on the
IntelliJ side with `-Dddot.test-data.dir=/abs/path/to/test-data`.

## Adding a case

1. `mkdir test-data/cases/NN-short-name/`
2. Write `input.ddot` exercising the new behaviour. One concern per case.
3. Generate the expected files you want to commit:
   ```sh
   ruby test-data/regenerate-html.rb
   (cd ../ddot.it-syntax-tools && npm run regenerate:tokens)
   (cd ../ddot.it-intellij && mvn test -Dgolden.regen=true)
   ```
4. **Review the generated files carefully** — they become the contract.
5. Commit `input.ddot` + every `expected.*` file together.
