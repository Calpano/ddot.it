# test-data

Cross-implementation golden corpora for ddot.it. Each subdirectory holds one
class of fixtures, consumed by **multiple** implementations to keep them in
lockstep.

## Layout

```
test-data/
└── preview-html/                      # role-coloured HTML preview rendering
    ├── regenerate.rb                  # canonical generator (Ruby renderer)
    └── cases/
        ├── 01-simple-triple/
        │   ├── input.ddot                 # the .ddot source
        │   ├── expected.body.html         # body-only HTML (no <style>/<pre>)
        │   └── expected.events.jsonl      # triple events per https://ddot.it/developer-guide.html#events
        ├── 02-untyped-link/
        ├── ...
```

## `preview-html/` contract

Each case asserts two things:

### `expected.body.html` — preview HTML

The **inner** role-classed `<span>` markup emitted by
`DdotIt::Render.body(input)`. It deliberately excludes:

- the surrounding `<style>` block (colour palette is configurable per
  call-site),
- the `<pre class="ddot-fence"><code>...</code></pre>` wrapper (Markdown vs
  AsciiDoc emit different shells).

Two implementations must produce byte-identical output:

1. **Ruby (canonical)** — `ddot.it-intellij/src/main/resources/com/calpano/ddot/asciidoc/ddot-render.rb`.
   `regenerate.rb` runs this to refresh `expected.body.html`. The same file
   is also installed into `<project>/.asciidoctor/lib/` by the IntelliJ
   plugin to render `[ddot]` blocks in the AsciiDoc preview.
2. **Java** — `com.calpano.ddot.preview.DdotMarkdownPreviewRenderer.body(...)`
   in the IntelliJ plugin. Renders `` ```ddot `` fences in the Markdown
   preview pane. The plugin's `PreviewHtmlGoldenTest` walks this corpus and
   asserts byte equality.

### `expected.events.jsonl` — triple events

The newline-separated event stream defined at
https://ddot.it/developer-guide.html#events, produced by
`com.calpano.ddot.export.DdotEventExporter` (the canonical Java parser, a
direct port of the VS Code extension's `parseDocument`). Fixed
context fields: `kind="ddot"`, `source="input.ddot"`. `location` is
1-based source line.

Refresh after changing `DdotEventExporter`:

```sh
cd ddot.it-intellij && mvn test -Dgolden.regen=true
```

If a future Ruby (or other-language) parser is added, it must produce the
same JSONL for every case.


## Workflow

```sh
# After changing the Ruby renderer (ddot-render.rb):
ruby test-data/preview-html/regenerate.rb              # refresh expected.body.html
ruby test-data/preview-html/regenerate.rb --check      # CI: fail on stale

# After changing DdotEventExporter:
(cd ../ddot.it-intellij && mvn test -Dgolden.regen=true)   # refresh expected.events.jsonl

# Normal test run (asserts both):
(cd ../ddot.it-intellij && mvn test)
```

`regenerate.rb` and `PreviewHtmlGoldenTest` both expect this repo
(`ddot.it`) and the plugin repo (`ddot.it-intellij`) to live as siblings
under the same parent directory. Override the path on the IntelliJ side
with `-Dddot.test-data.dir=/abs/path/to/test-data`.

## Adding a case

1. `mkdir test-data/preview-html/cases/NN-short-name/`
2. Write `input.ddot` exercising the new behaviour. One concern per case.
3. Generate expected files:
   ```sh
   ruby test-data/preview-html/regenerate.rb
   (cd ../ddot.it-intellij && mvn test -Dgolden.regen=true)
   ```
4. **Review the generated files carefully** — they become the contract.
5. Commit input + both expected files together.
