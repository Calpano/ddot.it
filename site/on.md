---
title: "ddot.it/on"
permalink: /on
nav_exclude: true
---
# ddot.it/on

`ddot.it/on` is a [command](user-guide.md#include-command) that marks the start of a region to **include** in ddot.it processing.

```
ddot.it/on
Project Eagle .. status .. active
.. started in .. 2024
ddot.it/off
```


The command is recognised **anywhere on a line**, so it can be written inside a host
language's comment — the usual way to place it in a Markdown, YAML, Java or HTML file:

```
<!-- ddot.it/on -->
# ddot.it/on
// !!on
```

A document may contain multiple `on`/`off` pairs to selectively process only certain regions.
Without any `on`/`off` commands, the whole document is processed by default.

See the [User Guide](user-guide.md#include-and-exclude) for the full reference.

## Highlighting
Only the command itself is highlighted; the surrounding comment markers are ignored. The
line carrying the command yields no triple, and the region starts on the **next** line.

NOTE: Because any line containing the command counts, a sentence *about* `!!on` also
triggers it. Inside a [`ddot.it/block`](block.md) commands are inert, which is the way to
write about them.

