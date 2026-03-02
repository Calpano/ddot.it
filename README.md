# ⚇ ddot.it &ndash; Connect anything with everything
<!--
ddot.it ..author.. Max Völkel ,, ..year.. 2026
.... wiki syntax
..logo.. ⚇
..license..Apache 2.0
-->
[ 🤖 Your are a helpful coding agent? See [https://ddot.it/llms.txt](https://ddot.it/llms.txt) ]

**What is it?**
- Double dot (ddot) is a **simple syntax** you can use wherever you can enter text.
- ⌨️Ergonomic syntax consists only of `..` and `,,`.
    - ⌨️ Easy to type, even on mobile keyboards.
    - 🤖 AI ready: Token-efficient and Markdown-compatible.
- It has a simple, uniform triple structure for **typed links**, **simple links**, and **properties**.
    - In ddot.it, these are the same: (subject - predicate - object), (entity - property - value), (object - key - value)
- By using the same concepts in different docs, a web of knowledge is formed &ndash; **across tool boundaries**.

You get a decentralized enterprise (or personal) **knowledge graph**.
Now, humans and agents can collaborate on a shared understanding of core concepts.

## Example
Given some files like \
**README.md**:
```markdown
## Project Eagle
..started in.. 2024
..doc site .. example.com/docbase/8dcjsid

John Doe..leads.. Project Eagle ,, ..since.. 2025
```
**compose.yml**:
```yaml
# Project Eagle....Moonshot
services:
  ...
```
they are interpreted by a ddot collector as this single knowledge graph:

<p style="text-align: center;">
  <img src="triple-structure.svg" alt="Example" style="width: 65%" />
</p>

**How does it work?**

1. A **ddot reader** knows how to read a kind of source and extracts your typed triples.
2. A **ddot collector** uses a number of readers to read all sources, periodically.
    - Your sources remain the single source of truth. Triples are just cached.
3. All triples are **combined into a single knowledge graph** in [Connected JSON](https://j-s-o-n.org) (CJ) format. \
CJ &ndash; a graph exchange format &ndash; can be converted to many other graph formats at [Graph&nbsp;In&nbsp;Out.com](https://graphinout.com).

## Quick Ref
- Universal **typed link** and **property** syntax is `aaa .. bbb.. ccc`.
  - Link type can be left out: Use `aaa .... ccc` for a simple link.
  - Append more to same subject with `..bbb.. ccc` lines.
  - **Meta-data** can be appended behind `,,`.
- Spaces and tabs don't matter. Incomplete triples are ignored. Two blank lines reset a ddot.it reader.
- Annotate a document: `ddot.it/this` refers to the doc in which ddot.it is used.

See the [User Guide](user-guide.md) for the full syntax reference and more [commands](user-guide.md#commands) (`ddot.it/COMMAND`).

See the [Developer Guide](developer-guide.md) on how to implement your own readers and collectors.


<h2 style="text-align: center;">
<span style="font-size: 180px; color:#AB68FF">⚇</span><br />
ddot.it &ndash; just d..dot it!</h2>

Version 1, 2026-02-24
