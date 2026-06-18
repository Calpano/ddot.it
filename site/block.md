---
title: "ddot.it/block"
permalink: /block
nav_exclude: true
---
# ddot.it/block

`ddot.it/block` is a [command](user-guide.md#commands) that starts a multi-line block object literal.

Use it to make longer string values with multiple lines nicer to read.
Each newline **in** the block, which separates lines, is included in the value string.

Example for using `ddot.it/block` and newlines
```
john ..address.. ddot.it/block
Broadway 1
Berlin
Germany

john ..age.. 11
```
You can abbreviate `ddot.it/block` as `!!block`.

### Newlines
The general pattern for newlines is
```
aaa ..bbb.. ddot.it/block?end=END
line-1
line-2
...
line-n-1
line-n
END
```
that only newlines between line-1 and line-2, line-2 and line-3, ..., line-n-1 and line-n are included in the value string.
If the block contains only one line, the value of the triples is the same as the value of the single line.

```
aaa ..bbb.. ddot.it/block?end=123
Hello World
123
```
is exactly the same as 
```
aaa ..bbb.. Hello World
```




### End Marker 
The default block end is a blank line.
You can defined a custom block end with `ddot.it/block?end=myString`, or shorter as `!!block?end=myString`. The block end marker is not included in the block content.
It may not contain newlines or other whitespace characters.
The block end marker must be used on its own line.

```
john ..address.. ddot.it/block?end=THE-END
Broadway 1
Berlin
Germany
THE-END
john ..age.. 11
```

- Newlines in a block are copied as newline characters (Unicode `\n`) into the triple object.
- The block content starts on the first line **after** the block start.
- The block content ends with the last line before the block end.   

Within a block, ddot.it triples MAY NOT be recognized.

See the [User Guide](user-guide.md#this-command) for the full reference.
