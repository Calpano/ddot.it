---
title: HTML Reader
parent: Developer Guide
nav_order: 4
---
# ⚇ ddot.it HTML Reader

A ddot.it [reader](developer-guide.md#reader) for HTML files.
It recognizes triples in [comments](#comments), [element text](#element-text), and [data attributes](#data-attributes).

NOTE: Some examples use the [ddot.it/this](user-guide.md#this-command) command.

## Standard Syntax

### Comments
```html
<!-- ddot.it/this ..project.. Code Red -->
```

Multi-line comment:
```html
<!--
  ddot.it/this ..project.. Code Red
  ..team.. Platform
-->
```

### Element Text
Ddot.it triples inside visible or metadata text elements:
```html
<meta name="description" content="ddot.it/this ..project.. Code Red">

<p hidden>ddot.it/this ..author.. Alice</p>
```
Hidden is, of course, optional.

## Extra Syntax

### Data Attributes
HTML elements can carry ddot.it triples in `data-ddot` attributes.

```html
<section data-ddot="ddot.it/this ..has tag.. intro ..has type.. overview">
  <h1>Welcome</h1>
</section>
```
these are interpreted as
```ddot.it
ddot.it/this ..has tag.. intro
..has type.. overview
```

### Custom Elements
A custom element named `<ddot-it>` is interpreted as ddot.it content, if it states its subject via the `subject` (or `id` or `name`) attribute.

```
<ddot-it subject='aaa' key1='value1' key2='value2'>
Hello Mr. <em>Smith</em>!
See this <a href='https://example.com'>link</a>.
</ddot-it>  
```
is interpreted as
```ddot.it
aaa ..key1.. value1
aaa ..key2.. value2 
aaa ..has content.. Hello Mr. <em>Smith</em>!\nSee this <a href='https://example.com'>link</a>.
```
Note that `\n` is representing a real newline character here, not `\` and `n`. In normal ddot.it triples, there cannot be newlines in the value. Only the https://ddot.it/block command can be used to insert newlines.


If no key `subject` is given, the value of `id` is used as the subject. If that is also not set, the value of `name` is used.
If that is also not set, the content of the element, including all attributes, is ignored.

