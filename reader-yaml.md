---
title: YAML Reader
parent: Developer Guide
nav_order: 8
---
# ⚇ ddot.it YAML Reader

A ddot.it [reader](developer-guide.md#reader) for YAML files, including `docker-compose.yml` and other YAML-based formats.
It recognizes triples in [comments](#comments) and [string values](#string-values).

NOTE: Some examples use the [ddot.it/this](user-guide.md#this-command) command.

## Standard Syntax

### Comments
```yaml
# ddot.it/this ..project.. Code Red
```

Multi-line comment block:
```yaml
# ddot.it/this ..project.. Code Red
# ..team.. Platform
# ..status.. active
```

### String Values
Ddot.it triples inside scalar string values:
```yaml
description: "ddot.it/this ..project.. Code Red"
```

Each string value is considered its own snippet and resets the parse context.

## Extra Syntax

### Docker Compose
In `docker-compose.yml`, labels are the natural place for ddot.it triples.

```yaml
services:
  web:
    # ddot.it/this ..type.. service
    # ..depends on.. database
    image: nginx
    labels:
      - "ddot.it/this ..owner.. platform-team"
```
