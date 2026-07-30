---
title: Common Relation Names
parent: Developer Guide
nav_order: 11
permalink: /rel
---
# ⚇ ddot.it Relations

Some relations are so commonly used, we suggest some standard names here:

| Name          | Aliases                  |   | Semantics (A .. relation .. B)                                                                                                                                                                                                                                     |
|---------------|--------------------------|:--|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `related`     | `rel`, <br/>`is related` |   | Undirected link connecting A and B.                                                                                                                                                                                                                                |
| `same as`     | `is same as`             |   | A and B are referring to the same concept.                                                                                                                                                                                                                         |
| `is alias of` |                          |   | Like `same as`, but with a clear main concept.<br/>This is like a sym-link.                                                                                                                                                                                        |
| `links to`    | `link`,<br/>`see also`   |   | Directed, untyped link from A to B. <br/>Default link type when four dots (`....`) are used.                                                                                                                                                                       |
| `has tag`     | `tag`                    |   | A has the tag B. <br/>Tags are not transitive.                                                                                                                                                                                                                     |
| `has type`    | `type`,<br/>`is a`       |   | A has the type B. Like [rdf:type](https://www.w3.org/TR/rdf12-schema/#ch_type). <br/>Types are inherited via `has subtype`.                                                                                                                                        |
| `has subtype` | `subtype`                |   | The type A has a more specialised type B.<br/>Transitive relation.<br/>If it forms a cycle, all participants of the cycle are considered to be the same entity (`same as`).                                                                                        |
| `prefix`      | --                       |   | When parsing a name like `A:foo` (starting with prefix an colon) the `A:` should be replaced by `B`. This is only needed for [RDF](/rdf) processing. This processing is just a recommended way to interpret a ddot.it triple base. Not needed in non-RDF contexts. |
| `has content` | `content`                |   | A has content B. In this case, B is usually a longer string. Maybe including line breaks (`<br>`). Maybe stated via https://ddot.it/block.                                                                                                                         |

## Binaries: Images, Videos, Audio, 3D, ...
How should a text-based format like ddot.it handle binaries?
Looking at HTML, which is also a text-based format and the implied model of Markdown and AsciiDoc, we have several options:

- Base64-encoded `data:` URIs
- Links to local (relative links)
- Links to remote (absolute links) files
 
Ddot.it can support all of these. However, `data:` URIs (and other inline approaches) don't fit the lightweight human touch of ddot.it well.
So we suggest using links, ideally relative one. 
That way, ddot.it files or files with ddot.it tripels int them can be packed together with the linked resources in a single zip archive.

## Commands as Relations
The relation of a triple can also be a [command](user-guide.md#commands). A parser lexes it as a
command wherever it appears, but what a command *means* is decided downstream — an unknown or
retired name simply keeps its text as the relation value.

`label` used to be such a command (`a ..!!label.. Alice`). It is now an ordinary relation
(`a ..label.. Alice`), defined in the
[Vocabulary Specification](spec/ddot-it-vocabulary.html#label).
