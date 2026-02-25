---
title: XML Reader
parent: Developer Guide
nav_order: 7
---
# ⚇ ddot.it XML Reader

A ddot.it [reader](developer-guide.md#reader) for XML files, including `pom.xml` (Maven) and other XML-based formats.
It recognizes triples in [comments](#comments) and [string values](#string-values).

NOTE: Some examples use the [ddot.it/this](user-guide.md#this-command) command.

## Standard Syntax

### Comments
```xml
<!-- ddot.it/this ..project.. Code Red -->
```

Multi-line comment:
```xml
<!--
ddot.it/this ..project.. Code Red
..team.. Platform
-->
```

### String Values
Ddot.it triples inside element text content:
```xml
<description>ddot.it/this ..project.. Code Red</description>
```

## Extra Syntax

### Maven pom.xml
In `pom.xml` files, the `<description>` element and XML comments are the natural places for ddot.it triples.

```xml
<project>
  <description>
    ddot.it/this ..type.. library
    ..team.. Platform
  </description>

  <!-- ddot.it/this ..status.. active -->
</project>
```
NOTE: The description is even published to places like Sonatype, where other tools can discover it and extract triples from there. Ddot.it works everywhere.
