---
title: Developer Guide
nav_order: 2
has_children: true
---
# ⚇ ddot.it &ndash; Developer Guide

Contents:
[Architecture](#architecture)
| [Syntax Specification](#syntax)
| [Reader](#reader)
| [Events](#events)
| [Collector](#collector)


## Architecture

1. A [reader](#reader) knows how to process a kind of source (e.g. Markdown or YAML)
2. and fires [triple events](#events) to a [collector](#collector).
3. The [collector](#collector) sends the resulting knowledge graph to a file or a pre-configured destination.

<p style="text-align: center">
<img src="images/architecture.svg" style="width: 75%;"  alt="Example"/>
</p>


## Syntax Specification

See [Syntax Specification](syntax.md).


## Reader
A [ddot](README.md) reader reads a kind of document and fires triple events.

You type ddot.it syntax in the text syntax of a **host language**.
Each host language has its own way to process double-dot syntax.
It is common for ddot syntax to be used in comments, but in Markdown and AsciiDoc, source code blocks can also be used.

ddot readers exist or are planned for these document types:

- [Markdown](reader-markdown.md) (1)
- AsciiDoc (1)
- xml (for `pom.xml` files) (1)
- yaml (e.g. for docker compose files) (1)
- Java source files (either as comments or annotations)
- plain text files (1)
- HTML files (1)
- PowerPoint files

These require authentication:

- Google Contacts notes field
- Google Keep (1)
- Google Calendar entries (1)
- Todoist tasks (1)

(1) These can be realised as a browser extension. Aggregating triples locally for (a) download, (b) sending to an API endpoint (locally or graphinout.com account).


ddot readers must

- respect [ddot.it commands](user-guide.md#commands)
  - Process only included lines as defined by `ddot.it/on` and `ddot.it/off`.
- fire events for each recognized triple, as defined in the next section.


## Events
Triple events are JSON-formatted and have the following structure:

| Property   | Required | Description                                                                                                                   | Example                                |
|------------|----------|-------------------------------------------------------------------------------------------------------------------------------|----------------------------------------|
| `from`     | yes      | ⓢ Subject of triple (the object about which we say something)                                                                 | `ddot`                                 |
| `type`     | &mdash;  | Ⓟ Type (property) of triple. <br/>Defaults to `links to`.                                                                     | `url`                                  |
| `to`       | yes      | ⓞ Object of triple.                                                                                                           | `ddot.it`                              |
| `meta`     | &mdash;  | Additional properties on a triple.<br/>Formatted as an array of objects, each with `type` and `to`, just like normal triples. | `[{"type":"year",`<br/>`"to":"2026"}]` |
| `kind`     | yes      | Kind of source                                                                                                                | `markdown`                             |
| `source`   | yes      | Source of text.                                                                                                               | `/README.md`                           |
| `location` | yes      | Line number                                                                                                                   | `76`                                   |

### Command Handling
- `ddot.it/this`: At this level, `ddot.it/this` is just a `from` value.
Replacement happens in the [collector](#collector).
- `ddot.it/on` and `ddot.it/off`: These commands have been processed by the reader and are not emitted as events.

### Triple Event Example
```json
[
  { "from": "Project Eagle", "type": "started in", "to": "2024",
    "kind": "markdown", "source": "/README.md", "location": 1 },

  { "from": "Project Eagle", "type": "doc site", "to": "example.com/docbase/8dcjsid",
    "kind": "markdown", "source": "/README.md", "location": 2 },

  { "from": "John Doe", "type": "leads", "to": "Project Eagle",
    "meta": { "type": "since", "to": "2025" },
    "kind": "markdown", "source": "/README.md", "location": 3 },

  { "from": "Project Eagle", "type": "links to", "to": "Moonshot",
    "kind": "markdown", "source": "/README.md", "location": 4 }
]
```


## Collector
The collector combines all triple events and represents them as a single knowledge graph, expressed in [**Connected JSON** (CJ)](https://j-s-o-n.org) format.
At [GraphInOut.com](https://graphinout.com) CJ can be converted in a number of other graph formats.

<p style="text-align: center">
<img src="images/data-model.svg" style="width: 85%;"  alt="Example"/>
</p>

Triples logically form a tree: **entity** → **type** → **value** → Set of entries.
An entry contains source information (source kind, source url, source line) and optional triple metadata (string).
Duplicate triples thus result in multiple entries (each with a different source location) for the same triple.
