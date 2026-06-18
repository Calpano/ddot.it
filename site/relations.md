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
