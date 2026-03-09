---
title: Resource Description Framework (RDF)
parent: Developer Guide
nav_order: 10
---
# ⚇ ddot.it and RDF

RDF is also using triples, but RDF has more features -- and is more complex.
RDF is not even a syntax, but a datamodel with several syntax. ddot.it compares probably best to [Turtle](https://en.wikipedia.org/wiki/Turtle_(syntax).

```turtle
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix dc: <http://purl.org/dc/elements/1.1/> .
@prefix ex: <http://example.org/stuff/1.0/> .

<http://www.w3.org/TR/rdf-syntax-grammar>
  dc:title "RDF/XML Syntax Specification (Revised)" ;
  ex:editor [
    ex:fullname "Dave Beckett";
    ex:homePage <http://purl.org/net/dajobe/>
  ] .
```

which translates directly to basic ddot.it as

```
http://www.w3.org/TR/rdf-syntax-grammar ..dc:title.. RDF/XML Syntax Specification (Revised)
..ex:editor.. _:b1
_:b1 ..ex:fullname.. Dave Beckett
..ex:homePage.. http://purl.org/net/dajobe/
```

But more realistically, in ddot.it one would write

```
RDF/XML Syntax Specification (Revised) ..url.. http://www.w3.org/TR/rdf-syntax-grammar
..editor.. Dave Beckett
Dave Beckett ..url.. http://purl.org/net/dajobe/
```
- `url` is shorter to type than `homePage`.
- there is usually no need to use namespace prefixes at all. If ddot.it is used at a large company, that whole large company can define in upstream processing to map `title` to `dc:title`. But such formalities are out of scope for the simple ddot.it syntax.
- Instead of giving a URL a title, ddot.it gives the title a url. Human labels are the leading identifiers.
To deal with arising id ambiguity, one can simply state
- The term `Dave Beckett` was repeated. That is not so nice to type, but keeps the syntax readable and memorable.

## Namespaces
To really represent the RDF from the example, we would also need to encode the namespace mapping.
A 'natural' option in ddot.it would be

```
rdf ..prefix.. http://www.w3.org/1999/02/22-rdf-syntax-ns#
dc ..prefix.. http://purl.org/dc/elements/1.1/
ex ..prefix.. http://example.org/stuff/1.0/
```
which, if you look at it, doesn't look to bad.
