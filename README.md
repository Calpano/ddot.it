---
---
# ⚇ ddot.it &ndash; Connect anything with everything
<!--
ddot.it ..author.. Max Völkel ,, ..year.. 2026
.... wiki syntax
..logo.. ⚇
..license..Apache 2.0
-->

**What is it?**

A decentralized enterprise (or personal) **knowledge graph**

- Double dot (ddot) is a **simple syntax** you can use wherever you can enter text.
- It has a simple, uniform triple structure for **typed links**, **simple links**, and **properties**.
- By using the same concepts in different docs, a web of knowledge is formed &ndash; **across tool boundaries**.
 
Humans and agents can collaborate on a shared understanding of core concepts.

- 🤖 AI ready: Token-efficient and Markdown-compatible.
- ⌨️ Ergonomic: Easy to type, even on mobile keyboards.

**How does it work?**
 
1. A **ddot collector** reads your scattered sources and files and extracts triples. 
2. All triples are **combined into a single knowledge graph** in [Connected JSON](https://j-s-o-n.org]) (CJ) format. \
CJ &ndash; a graph exchange format &ndash; can be converted to many other graph formats at [Graph&nbsp;In&nbsp;Out.com](https://graphinout.com).

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
they are interpreted as this single knowledge graph:

<p style="text-align: center;">
  <img src="triple-structure.svg" alt="Example" style="width: 65%" />
</p>


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
<span style="font-size: 180px; color:#ccc">⚇</span><br />
ddot.it &ndash; just d..dot it!</h2>  

Version 1, 2026-02-24
