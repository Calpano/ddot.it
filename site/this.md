---
title: "ddot.it/this"
permalink: /this
nav_exclude: true
---
# ddot.it/this

`ddot.it/this` is a [command](user-guide.md#commands) that refers to the **current document** as the subject of a triple.

Use it to annotate the file itself, rather than naming a subject explicitly:

```
ddot.it/this .. project .. Code Red
ddot.it/this .. author .. Alice
ddot.it/this .. status .. active
```

This is equivalent to writing the document's own URL or path as the subject.
The [collector](developer-guide.md#collector) replaces `ddot.it/this` with the actual source URL when building the knowledge graph.

See the [User Guide](user-guide.md#this-command) for the full reference.
