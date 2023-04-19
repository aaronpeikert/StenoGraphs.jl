# StenoGraphs.jl ― A concise language to write meta graphs

[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://aaronpeikert.github.io/StenoGraphs.jl/dev)
[![Build Status](https://github.com/aaronpeikert/StenoGraphs.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/aaronpeikert/StenoGraphs.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/aaronpeikert/StenoGraphs.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/aaronpeikert/StenoGraphs.jl)

> **Stenography**: a quick way of writing using special signs or abbreviations

`StenoGraphs.jl` lets you quickly write meta graphs.
As with shorthand, it is optimized for writing quickly (by humans) but is less quickly read (by computers).

To install `StenoGraphs.jl`:

```julia
import Pkg; Pkg.add("StenoGraphs")
```

Your first `@StenoGraph` using `StenoGraphs`:

```@example 1
using StenoGraphs
@StenoGraph a → b
```

By the way, typing arrows can be done quickly on Linux by using `Alt Gr + I` resulting in `←` and `Alt GR + I` resulting in `→` .
All other platforms must use `\leftarrow` + `Tab` or `\rightarrow` + `Tab`.

## Multiple Nodes

Multiple nodes on one side lead to multiple edges:

```@example 1
@StenoGraph [a b] → c
```

There are two desirable outcomes for multiple edges on both sides, either element-wise edges or cross-product. The single line arrow (`→`) means element-wise and double line arrow (`⇒`) means cross-product (don't tell anyone but for a single node on one side `→` is converted to `⇒` for convinience).

```@example 1
@StenoGraph [a b] → [c d]
```

```@example 1
@StenoGraph [a b] ⇒ [c d]
```

## Modification


Modification is done by overloading `*` for types of Modifier.

Let's define a `Modifier`:

```@example mod
using StenoGraphs #hide
struct Weight <: EdgeModifier
    w::Number
end
```

An  `EdgeModifier` can be directly applied to edges:

```@example mod
@StenoGraph (a → b) * Weight(1)
```

Multiplying a `Node` with an `EdgeModifier` leads to a `ModifyingNode`.

```@example mod
:b * Weight(1)
```

A `ModifyingNode` will modify its edges:

```@example mod
@StenoGraph a → b * Weight(1)
```

To modify Nodes directly with a `NodeModifier` to create a `ModifiedNode` (instead of `ModifyingNode`) we overload `^`:

```@example nodemod
using StenoGraphs #hide
struct NodeLabel <: NodeModifier
    l
end

@StenoGraph a → b^NodeLabel("Dickes B")
```

## Related Software

The R programming language has formulas of the form `a ~ b` to specify regressions.
This inspired Yves Rosseel to create a very concise, yet expressive syntax for Structural Equation Models for [`lavaan`](https://lavaan.ugent.be/tutorial/syntax1.html).
`Stenographs.jl` tries to maintain the best features of this syntax while creating Julia Objects that represent a graph (i.e., similar to [MetaGraphs](https://github.com/JuliaGraphs/MetaGraphs.jl)).

