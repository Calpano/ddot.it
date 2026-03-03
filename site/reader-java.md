---
title: Java Reader
parent: Developer Guide
nav_order: 5
---
# ⚇ ddot.it Java Reader

A ddot.it [reader](developer-guide.md#reader) for Java source files.
It recognizes triples in [line comments](#line-comments), [block comments](#block-comments), and [Javadoc comments](#javadoc-comments).

NOTE: Some examples use the [ddot.it/this](user-guide.md#this-command) command.

## Standard Syntax

### Line Comments
```java
// ddot.it/this ..project.. Code Red
```

### Block Comments
```java
/*
 * ddot.it/this ..project.. Code Red
 * ..team.. Platform
 */
```

### Javadoc Comments
```java
/**
 * Processes the incoming request.
 *
 * ddot.it/this ..type.. service
 * ..depends on.. UserRepository
 */
public class RequestProcessor {
```

## Extra Syntax

### Annotations
Ddot.it triples can be embedded in string-valued annotation attributes.
This requires creating a custom annotation.
The Java reader ignores the annotation package. Any annotation named `DdotIt` works. It may take one or multiple string values.
Multiple string values are considered newline-separated.

```java
@DdotIt("ddot.it/this ..status.. deprecated ..replacement.. NewProcessor")
public class MyFactory {
    
}
```
#### Annotation Code

```java
package it.ddot;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Annotation to embed ddot.it triples into Java bytecode.
 */
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.TYPE, ElementType.FIELD, ElementType.METHOD, ElementType.PARAMETER, ElementType.PACKAGE})
public @interface DdotIt {
    String[] value();
}
```
