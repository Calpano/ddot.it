---
title: PowerPoint Reader
parent: Developer Guide
nav_order: 7
---
# ⚇ ddot.it PowerPoint Reader

A ddot.it [reader](developer-guide.md#reader) for PowerPoint files (`.pptx`).
It recognizes triples in [slide text](#slide-text) and [speaker notes](#speaker-notes).

NOTE: Some examples use the [ddot.it/this](user-guide.md#this-command) command.

## Standard Syntax

### Slide Text
Any text box or shape text on a slide can contain ddot.it triples.

```
ddot.it/this ..project.. Code Red
..status.. active
```

Triples can appear alongside normal slide content. The reader ignores lines that do not match ddot.it syntax.

### Speaker Notes
Speaker notes are the preferred location for ddot.it triples, as they do not affect the visual presentation of the slide.

```
This slide covers the onboarding flow.

ddot.it/this ..project.. Code Red
..author.. Alice
..reviewed by.. Bob
```

## Notes on .pptx Format
PowerPoint `.pptx` files are ZIP archives containing XML. The reader processes:
- `ppt/slides/slide*.xml` — slide text content
- `ppt/notesSlides/notesSlide*.xml` — speaker notes
