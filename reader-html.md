---
title: HTML Reader
parent: Developer Guide
nav_order: 3
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
