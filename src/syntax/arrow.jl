
# lhs = left hand side; rhs = right hand side
# src = source, dst = destination
# order is: lhs, rhs, src, dst
function Arrow(lhs, rhs, src, dst; edge_fun = DirectedEdge, cross = false)
    if cross
        edges = edge_fun(src, dst)
    else
        edges = edge_fun.(src, dst)
    end
    edges = isa(edges, VecOrMat) ? edges : [edges]
    edges = isa(edges, Matrix) ? vec(edges) : edges
    edges = isa(lhs, Arrow) ? vcat(lhs.edges..., edges...) : edges
    edges = isa(rhs, Arrow) ? vcat(edges..., rhs.edges...) : edges
    Arrow(edges, lhs, rhs)
end

"""
Single (broadcasting) arrow right (\\rightarrow, Alt Gr + i)

```jldoctest
julia> @StenoGraph a → b
a → b

julia> eltype(ans)
DirectedEdge{SimpleNode{Symbol}, SimpleNode{Symbol}}

julia> @StenoGraph [a b] → [c d]
a → c
b → d
```
"""
→(lhs, rhs) = Arrow(lhs, rhs, keep(lhs, Right, ModifiedNode), keep(rhs, Left, AbstractNode))

"""
Double (cross product) arrow right (\\Rightarrow)

```jldoctest
julia> @StenoGraph a ⇒ b
a → b

julia> eltype(ans)
DirectedEdge{SimpleNode{Symbol}, SimpleNode{Symbol}}

julia> @StenoGraph [a b] ⇒ [c d]
a → c
a → d
b → c
b → d
```
"""
⇒(lhs, rhs) = Arrow(lhs, rhs, keep(lhs, Right, ModifiedNode), keep(rhs, Left, AbstractNode); cross = true)

"""
Single (broadcasting) arrow left (\\leftarrow, Alt Gr + z)

```jldoctest
julia> @StenoGraph a ← b
b → a

julia> eltype(ans)
DirectedEdge{SimpleNode{Symbol}, SimpleNode{Symbol}}

julia> @StenoGraph [a b] ← [c d]
c → a
d → b
```
"""
←(lhs, rhs) = Arrow(lhs, rhs, keep(rhs, Left, ModifiedNode), keep(lhs, Right, AbstractNode))

"""
Double (cross product) arrow left (\\Leftarrow)

```jldoctest
julia> @StenoGraph a ⇐ b
b → a

julia> eltype(ans)
DirectedEdge{SimpleNode{Symbol}, SimpleNode{Symbol}}

julia> @StenoGraph [a b] ⇐ [c d]
c → a
c → b
d → a
d → b
```
"""
⇐(lhs, rhs) = Arrow(lhs, rhs, keep(rhs, Left, ModifiedNode), keep(lhs, Right, AbstractNode); cross = true)

"""
Single (broadcasting) arrow left-right (\\leftrightarrow)

```jldoctest
julia> @StenoGraph a ↔ b
a ↔ b

julia> eltype(ans)
UndirectedEdge{SimpleNode{Symbol}, SimpleNode{Symbol}}

julia> @StenoGraph [a b] ↔ [c d]
a ↔ c
b ↔ d
```
"""
↔(lhs, rhs) = Arrow(lhs, rhs, keep(lhs, Right, ModifiedNode), keep(rhs, Left, AbstractNode); edge_fun = UndirectedEdge)

"""
Double (cross product) arrow left-right (\\Leftrightarrow)

```jldoctest
julia> @StenoGraph a ⇔ b
a ↔ b

julia> eltype(ans)
UndirectedEdge{SimpleNode{Symbol}, SimpleNode{Symbol}}

julia> @StenoGraph [a b] ⇔ [c d]
a ↔ c
a ↔ d
b ↔ c
b ↔ d
```
"""
⇔(lhs, rhs) = Arrow(lhs, rhs, keep(lhs, Right, ModifiedNode), keep(rhs, Left, AbstractNode); edge_fun = UndirectedEdge, cross = true)

# if either lhs or rhs are a single node, broadcast arrow (barrow) behave like cross arrow (carrow)
barrows = [:→, :←, :↔]
carrows = [:⇒, :⇐, :⇔]
for (barrow, carrow) in zip(barrows,  carrows)
    @eval $barrow(lhs::Union{AbstractNode, Symbol}, rhs::Union{AbstractNode, Symbol}) = $carrow(lhs, rhs)
    @eval $barrow(lhs::Union{AbstractNode, Symbol}, rhs) = $carrow(lhs, rhs)
    @eval $barrow(lhs, rhs::Union{AbstractNode, Symbol}) = $carrow(lhs, rhs)
end
