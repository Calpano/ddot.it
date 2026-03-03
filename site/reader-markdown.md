---
title: Markdown Reader
parent: Developer Guide
nav_order: 2
---
# ⚇ ddot.it Markdown Reader

A ddot.it [reader](developer-guide.md#reader) for Markdown text.
It recognizes triples in [plain text](#plain-text), [comments](#comments), [code blocks](#code-blocks), and [section attributes](#section-attributes). 

NOTE: Some examples use the [ddot.it/this](user-guide.md#this-command) command.

## Standard Syntax

### Plain Text
```
My nice document.
ddot.it/this ..project.. Code Red
```

### Comments
```
<!-- ddot.it/this ..project.. Code Red -->
```

### Code Blocks
````
My nice document
```
ddot.it/this ..project.. Code Red
```
````

## Extra Syntax
Ddot.it extracts triples from section attributes, too.

### Section Attributes
Additionally, some extended Markdown dialects allow **custom attributes for sections**.
They are supported in _Markdown Extra_ (as in PHP Markdown Extra), _Pandoc_, and _Kramdown_ (used in _Jekyll_), _Hugo_ (via _Goldmark_ with attribute extension enabled).

Syntax:
```markdown
## My Section {#my-tag #my-other-tag .my-class .my-other-class}
```
these are interpreted as
```ddot.it
My Section ..has tag.. my-tag
..has tag.. my-other-tag
..has type.. my-class
..has type.. my-other-class
```
