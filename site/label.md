---
title: "ddot.it/label"
permalink: /label
nav_exclude: true
---
# ddot.it/label

`ddot.it/label` is a [command](user-guide.md#include-command) that can be used to make more complex knopwledge graphs defined in one file easier to modify. It separates the node identity (subject and object of triples) from the label. 

The distinction between node id and label only plays a role in downstream tools, which have label support.
In [graphinout.com](https://graphinout.com), all incoming graph data, including ddot.it syntax is first converted to [connected json (CJ)](https://j-s-o-n.org), which has label support, and then to the desired target format.

The following two graphs have the same structure and the same node content (labels):

```
Alice ..knows.. Bob
Bob ..knows.. Carol
```
and now using `ddot.it/label`:
```
a ..knows.. b
b ..knows.. c
a ..!!label.. Alice
b ..!!label.. Bob
c ..!!label.. Carol 
```

The first example is more ddot-ish, but the second one is easier to modify when labels are still in flux.
