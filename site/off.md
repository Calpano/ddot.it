---
title: "ddot.it/off"
permalink: /off
nav_exclude: true
---
# ddot.it/off

`ddot.it/off` is a [command](user-guide.md#exclude-command) that marks the start of a region to **exclude** from ddot.it processing.

```
ddot.it/on
Project Eagle .. status .. active
ddot.it/off

This section is ignored by ddot.it readers.
```


The command is recognised **anywhere on a line**, so it can be written inside a host
language's comment — the usual way to place it in a Markdown, YAML, Java or HTML file:

```
<!-- ddot.it/off -->
# ddot.it/off
// !!off
```

A document may contain multiple `on`/`off` pairs to selectively process only certain regions.

See the [User Guide](user-guide.md#include-and-exclude) for the full reference.

## Highlighting
Only the command itself is highlighted; the surrounding comment markers are ignored. The
line carrying the command yields no triple, and the region starts on the **next** line.

NOTE: Because any line containing the command counts, a sentence *about* `!!off` also
triggers it. Inside a [`ddot.it/block`](block.md) commands are inert, which is the way to
write about them.

