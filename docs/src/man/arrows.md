# → Arrows ←

```@meta
DocTestSetup = quote
    using StenoGraphs
end
```

Arrows are key for typing edges quickly in `StenoGraphs.jl`.
They differ from edges fundamentally because they "remember" what you wrote (syntax, what was on the left side and right side), while edges represent only what you meant (semantic).
Usual objects should not depend on how they were syntactically defined. However, arrows require syntactic information in order to be chainable.
A hard and fast rule is: "for typing: use arrows; for programming: use edges".

It is unfortunate to make this distinction, but if we ignore syntactical information, this:

```jldoctest
julia> @StenoGraph a ← b → c
b → a
b → c
```

Would result in:

```
b → a
a → c # <-- crazy
```

The underlying reason for this weird behaviour is left to right evaluation.
Parenthesis make this clearer `(a ← b) → c`.
So `a ← b` is evaluated first (in prefix notation: `←(a, b)`), resulting in the edge `b → a`.
In a second step, on the resulting edge, this is evaluated: `→(b → a, c)`.
An ordinary edge is defined by its `Src` (`b`) and `Dst` (`a`) and has no recollection of how it was defined (for programming, this is a good thing!).
However, forming a new edge on top of it, would result in very strange things, with arrows in different directions.
For that reason, we have `StenoGraphs.Arrow`.
`Arrow`s do store syntactic information to echew this problem.
However, they are "ephemeral", so we strip syntactical information as soon as we can (e.g. the `@StenoGraph` macro `unarrow`s its results).
For that reason, `Arrow` is unexported.

```@docs
→
⇒
←
⇐
↔
⇔
```