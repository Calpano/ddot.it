# The ddot.it Manifesto
<!-- !!this ..authored on.. 2026-07-04 -->

## Reading over Writing
Knowledge and code should be read more often than written.  
 
- **Human Readers First** 
- **Easy for Agents, too** \
  Agents can **read** the syntax of ddot.it without any skills, plugins or instruction.

## Easy to Write 
The basic syntax of ddot.it can be taught in 20 seconds:

- all knowledge is triples
- Example: ddot.it  ..has type.. language
- Structure: subject .. relation .. object ,, here is optionally metadata about the triple

Programs can emit ddot.it trivially. Just ensure no double-dot appears in subjects or relations.

## Less is More
The fewer syntax elements ddot.it has, the easier it is to learn. And use.
That's why ddot.it has no syntax for lists.
The only syntax sugar is an *omitted subject*.

## More is Better
If in some cases, text which was not meant to be a triple is interpreted as a triple, there is usually no downside to it. Yes, a search would find some noise.
On the other hand, data meant to be triples should not be hard to type.
If knowledge is hard to type, it will not get typed.

## Be a Nice Guest
Don't ask what you can embed in ddot.it, ask where you can embed ddot.it into.
Ddot.it is a *guest language* in a *host language*.

**Example**: \
Instead of putting HTML values in a ddot.it `!!block`, write an HTML file and annotate it with ddot.it tags. Use the HTML-specific ways, like custom component syntax or data attributes syntax.

## Connect the Dots
By re-using the same subjects, relation and/or objects in multiple places, a web of knowledge is created.

## Make Simple Things Simple and Advanced Things Possible
The headline says it all.
