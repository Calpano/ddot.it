# ⚇ ddot.it – Connect anything with everything

> **Full documentation: [ddot.it](https://ddot.it)**

**What is it?**
- ddot.it (double dot) is a **simple syntax** you can use wherever you can enter text.
- Syntax consists only of `..` and `,,`.
    - ⌨️ Ergonomic, easy to type, even on mobile keyboards.
    - 🤖 AI ready: Token-efficient and Markdown-compatible.
- It has a simple, uniform 'triple' structure for **typed links**, **simple links**, and **properties**. \
  In ddot.it, these are all the same:
    - subject - predicate - object
    - entity - property - value
    - object - key - value
    - from - type - to
- By using the same concepts in different docs, a web of knowledge is formed – **across tool boundaries**.

You get a decentralized enterprise (or personal) **knowledge graph**.
Now, humans and agents can collaborate on a shared understanding of core concepts.

## Example
<!-- ddot.it/off -->
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

![Triple structure](site/images/triple-structure.svg)

**How does it work?**

1. A **ddot reader** knows how to read a kind of source and extracts your typed triples.
2. A **ddot collector** uses a number of readers to read all sources, periodically.
    - Your sources remain the single source of truth. Triples are just cached.
3. All triples are **combined into a single knowledge graph** in [Connected JSON](https://j-s-o-n.org) (CJ) format.

## Quick Ref

- Universal **typed link** and **property** syntax is `aaa .. bbb.. ccc`.
  - Link type can be left out: Use `aaa .... ccc` for a simple link.
  - Append more to same subject with `..bbb.. ccc` lines.
  - **Meta-data** can be appended behind `,,`.
- Spaces and tabs don't matter. Incomplete triples are ignored. Two blank lines reset a ddot.it reader.
- Annotate a document: `ddot.it/this` refers to the doc in which ddot.it is used.

See the [User Guide](https://ddot.it/user-guide.html) and [Developer Guide](https://ddot.it/developer-guide.html) on [ddot.it](https://ddot.it).

---

*Version 1, 2026-02-24 · License: Apache 2.0*

<!-- ddot.it/on
ddot.it/this
..version.. 1
..date.. 2026-03-03
-->
