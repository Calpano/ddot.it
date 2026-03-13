---
title: "Author Guide"
permalink: /write
nav_exclude: false
---
# How to write correct and pretty ddot.it
<!-- ddot.it/off -->

For a full triple, make the spacing like this:
```
aaa ..bbb.. ccc
```

For additional triples, let it look like this:
```
myObject ..myRel.. myValue
..myNextRel.. myNextValue
```

Remember, there are no shorthands.
To say a, b, and c have the type service, the only possible way to write that is
```
a ..type.. service
b ..type.. service
c ..type.. service
```

- Unsure which relations to use?
Inspire yourself with the [relation guide](/relations).
- Need more control, which lines of a text are d-dotted and which are excluded? Use [ddot.it/off](off.md) and [ddot.it/on](on.md).
- Wanting to express RDF-like data? See [ddot.it and RDF](/rdf).
