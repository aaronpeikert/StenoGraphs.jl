
<!– README.md is generated from docs/src/README.md. Please edit that file and rebuild with `cd docs/ && julia make_readme.jl`–>


<a id='StenoGraphs.jl-―-A-concise-language-to-write-meta-graphs'></a>

<a id='StenoGraphs.jl-―-A-concise-language-to-write-meta-graphs-1'></a>

# StenoGraphs.jl ― A concise language to write meta graphs


<!– badges: start –>


[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://aaronpeikert.github.io/StenoGraphs.jl/dev) [![Build Status](https://github.com/aaronpeikert/Semi.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/aaronpeikert/Semi.jl/actions/workflows/CI.yml?query=branch%3Amain) [![Coverage](https://codecov.io/gh/aaronpeikert/Semi.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/aaronpeikert/Semi.jl)


<!– badges: end –>


> **Stenography**: a quick way of writing using special signs or abbreviations



`StenoGraphs.jl` lets you quickly write meta graphs. As with shorthand, it is optimized for writing quickly (by humans) but is less quickly read (by computers).


To install `StenoGraphs.jl`:


```julia
import Pkg; Pkg.add(url="https://github.com/aaronpeikert/StenoGraphs.jl.git")
"
```


Your first `@StenoGraph` using `StenoGraphs`:


```julia
using StenoGraphs
@StenoGraph a → b
```


```
StenoGraphs.DirectedEdge{StenoGraphs.SimpleNode{Symbol}, StenoGraphs.SimpleNode{Symbol}}(StenoGraphs.SimpleNode{Symbol}(:a), StenoGraphs.SimpleNode{Symbol}(:b))
```


<a id='Multiple-Nodes'></a>

<a id='Multiple-Nodes-1'></a>

## Multiple Nodes


Multiple nodes on one side lead to multiple edges:


```julia
@StenoGraph [a b] → c
```


```
2-element Vector{StenoGraphs.DirectedEdge{StenoGraphs.SimpleNode{Symbol}, StenoGraphs.SimpleNode{Symbol}}}:
 StenoGraphs.DirectedEdge{StenoGraphs.SimpleNode{Symbol}, StenoGraphs.SimpleNode{Symbol}}(StenoGraphs.SimpleNode{Symbol}(:a), StenoGraphs.SimpleNode{Symbol}(:c))
 StenoGraphs.DirectedEdge{StenoGraphs.SimpleNode{Symbol}, StenoGraphs.SimpleNode{Symbol}}(StenoGraphs.SimpleNode{Symbol}(:b), StenoGraphs.SimpleNode{Symbol}(:c))
```


Multiple nodes on both sides lead to the cross product of edges:


```julia
@StenoGraph [a b] → [c d]
```


```
4-element Vector{StenoGraphs.DirectedEdge{StenoGraphs.SimpleNode{Symbol}, StenoGraphs.SimpleNode{Symbol}}}:
 StenoGraphs.DirectedEdge{StenoGraphs.SimpleNode{Symbol}, StenoGraphs.SimpleNode{Symbol}}(StenoGraphs.SimpleNode{Symbol}(:a), StenoGraphs.SimpleNode{Symbol}(:c))
 StenoGraphs.DirectedEdge{StenoGraphs.SimpleNode{Symbol}, StenoGraphs.SimpleNode{Symbol}}(StenoGraphs.SimpleNode{Symbol}(:a), StenoGraphs.SimpleNode{Symbol}(:d))
 StenoGraphs.DirectedEdge{StenoGraphs.SimpleNode{Symbol}, StenoGraphs.SimpleNode{Symbol}}(StenoGraphs.SimpleNode{Symbol}(:b), StenoGraphs.SimpleNode{Symbol}(:c))
 StenoGraphs.DirectedEdge{StenoGraphs.SimpleNode{Symbol}, StenoGraphs.SimpleNode{Symbol}}(StenoGraphs.SimpleNode{Symbol}(:b), StenoGraphs.SimpleNode{Symbol}(:d))
```


Unless you specifically broadcast:


```julia
@StenoGraph [a, b] .→ [c, d]
```


```
2-element Vector{StenoGraphs.DirectedEdge{StenoGraphs.SimpleNode{Symbol}, StenoGraphs.SimpleNode{Symbol}}}:
 StenoGraphs.DirectedEdge{StenoGraphs.SimpleNode{Symbol}, StenoGraphs.SimpleNode{Symbol}}(StenoGraphs.SimpleNode{Symbol}(:a), StenoGraphs.SimpleNode{Symbol}(:c))
 StenoGraphs.DirectedEdge{StenoGraphs.SimpleNode{Symbol}, StenoGraphs.SimpleNode{Symbol}}(StenoGraphs.SimpleNode{Symbol}(:b), StenoGraphs.SimpleNode{Symbol}(:d))
```


<a id='Modification'></a>

<a id='Modification-1'></a>

## Modification


Modification is done by overloading '*' for types of Modifier.


Let's define a `Modifier`:


```julia
struct Weight <: Modifier
    w::Number
end
```


A modifier can be directly applied to edges:


```julia
@StenoGraph (a → b) * Weight(1)
```


```
StenoGraphs.ModifiedEdge{StenoGraphs.DirectedEdge{StenoGraphs.SimpleNode{Symbol}, StenoGraphs.SimpleNode{Symbol}}, Vector{Main.Weight}}(StenoGraphs.DirectedEdge{StenoGraphs.SimpleNode{Symbol}, StenoGraphs.SimpleNode{Symbol}}(StenoGraphs.SimpleNode{Symbol}(:a), StenoGraphs.SimpleNode{Symbol}(:b)), Main.Weight[Main.Weight(1)])
```


Multiplying a `Node` with a `Modifier` leads to a `ModifyingNode`.


```julia
@StenoGraph b * Weight(1)
```


```
StenoGraphs.ModifyingNode{StenoGraphs.SimpleNode{Symbol}, Vector{Main.Weight}}(StenoGraphs.SimpleNode{Symbol}(:b), Main.Weight[Main.Weight(1)])
```


A `ModifyingNode` will modify its edges:


```julia
@StenoGraph a → b * Weight(1)
```


```
StenoGraphs.ModifiedEdge{StenoGraphs.DirectedEdge{StenoGraphs.SimpleNode{Symbol}, StenoGraphs.SimpleNode{Symbol}}, Vector{Main.Weight}}(StenoGraphs.DirectedEdge{StenoGraphs.SimpleNode{Symbol}, StenoGraphs.SimpleNode{Symbol}}(StenoGraphs.SimpleNode{Symbol}(:a), StenoGraphs.SimpleNode{Symbol}(:b)), Main.Weight[Main.Weight(1)])
```


To modify Nodes directly to create a `ModifyingNode` (instead of `ModifyingNode`), the following syntax is planned, but not implemented:


```julia
a^modifier()
```


<a id='Related-Software'></a>

<a id='Related-Software-1'></a>

## Related Software


The R programming language has formulas of the form `a ~ b` to specify regressions. This inspired Yves Rosseel to create a very concise, yet expressive syntax for Structural Equation Models for [`lavaan`](https://lavaan.ugent.be/tutorial/syntax1.html). `Stenographs.jl` tries to maintain the best features of this syntax while creating Julia Objects that represent a graph (i.e., similar to [MetaGraphs](https://github.com/JuliaGraphs/MetaGraphs.jl)).

