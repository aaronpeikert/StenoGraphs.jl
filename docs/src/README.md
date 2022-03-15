# StenoGraphs.jl ― A concise language to write meta graphs

[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://aaronpeikert.github.io/StenoGraphs.jl/dev)
[![Build Status](https://github.com/aaronpeikert/Semi.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/aaronpeikert/Semi.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/aaronpeikert/Semi.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/aaronpeikert/Semi.jl)

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

## Multiple Nodes

Multiple nodes on one side lead to multiple edges:

```@example 1
@StenoGraph [a b] → c
```

There are two desirable outcomes for multible edges on both sides, either elementwise edges or cross product.
The single line arrow (`→`) means element wise and double line arrow (`⇒`) means crossproduct.

```@example 1
@StenoGraph [a b] → [c d]
@StenoGraph [a b] ⇒ [c d]
```

## Modification


Modification is done by overloading '*' for types of Modifier.

Let's define a `Modifier`:

```@example mod
using StenoGraphs #hide
struct Weight <: Modifier
    w::Number
end
```

A modifier can be directly applied to edges:

```@example mod
@StenoGraph (a → b) * Weight(1)
```

Multiplying a `Node` with a `Modifier` leads to a `ModifyingNode`.

```@example mod
:b * Weight(1)
```

A `ModifyingNode` will modify its edges:

```@example mod
@StenoGraph a → b * Weight(1)
```

To modify Nodes directly to create a `ModifyingNode` (instead of `ModifyingNode`), the following syntax is planned, but not implemented:

```julia
a^modifier()
```

## Related Software

The R programming language has formulas of the form `a ~ b` to specify regressions.
This inspired Yves Rosseel to create a very concise, yet expressive syntax for Structural Equation Models for [`lavaan`](https://lavaan.ugent.be/tutorial/syntax1.html).
`Stenographs.jl` tries to maintain the best features of this syntax while creating Julia Objects that represent a graph (i.e., similar to [MetaGraphs](https://github.com/JuliaGraphs/MetaGraphs.jl)).

