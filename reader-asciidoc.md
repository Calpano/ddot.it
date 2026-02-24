# ⚇ ddot.it AsciiDoc Reader

A ddot.it [reader](developer-guide.md#reader) for AsciiDoc text.
It recognizes triples in [plain text](#plain-text), [comments](#comments), [code blocks](#code-blocks), and [block attributes](#block-attributes).

NOTE: Some examples use the [ddot.it/this](user-guide.md#this-command) command.

## Standard Syntax

### Plain Text
```
My nice document.
ddot.it/this ..project.. Code Red
```

### Comments
Single-line comment:
```
// ddot.it/this ..project.. Code Red
```

Block comment:
```
////
ddot.it/this ..project.. Code Red
////
```

### Code Blocks
```
----
ddot.it/this ..project.. Code Red
----
```

## Extra Syntax
Ddot.it extracts triples from block and section attributes, too.

### Block Attributes
AsciiDoc supports custom IDs and roles on sections and blocks.

Syntax:
```asciidoc
[#my-tag#my-other-tag.my-class.my-other-class]
== My Section
```
these are interpreted as
```ddot.it
My Section ..has tag.. my-tag
..has tag.. my-other-tag
..has type.. my-class
..has type.. my-other-class
```
