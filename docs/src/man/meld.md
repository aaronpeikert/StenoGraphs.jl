# Meld/Merge

Every StenoGraph starts out as a a vector of [`Edge`](@ref)s.
Key part of building a graph from this vector is homogenize the nodes and edges from this vector.
This homogenization is driven by the two functions [`meld`](@ref) and [`merge`](@ref):

```@docs
meld
merge
```
