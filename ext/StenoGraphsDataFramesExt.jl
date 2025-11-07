module StenoGraphsDataFramesExt

import DataFrames
import DataFrames: DataFrame, rename!
import Tables: dictcolumntable
using StenoGraphs

function DataFrame_(x::Vector{<:Union{AbstractEdge,AbstractNode}}, prefix="")
    df = DataFrame(dictcolumntable(StenoGraphs.modifiers.(x)))
    rename!(x -> prefix * x, df)
    df[!, prefix] = x
    return df
end

"""
    DataFrame(g::Vector{<:AbstractEdge})

!!! note "Package Extension"
    This method is provided by the `StenoGraphsDataFramesExt` extension.
    It requires loading DataFrames: `using DataFrames`

Convert a vector of edges (typically from `@StenoGraph`) to a `DataFrame`.

The resulting DataFrame contains columns for:
- Edge modifiers (prefixed with "Edge")
- Source node modifiers (prefixed with "Src")
- Destination node modifiers (prefixed with "Dst")
- The edges themselves in the "Edge" column
- The source nodes in the "Src" column
- The destination nodes in the "Dst" column

# Examples
```jldoctest
julia> using StenoGraphs, DataFrames

julia> struct Weight <: StenoGraphs.EdgeModifier w end

julia> g = @StenoGraph begin
           a → Weight(1)*b
           b → Weight(2)*c
       end;

julia> df = DataFrame(g);

julia> "EdgeWeight" ∈ names(df)
true

julia> size(df)
(2, 4)
```

See also [`StenoGraph(::DataFrame)`](@ref) for the inverse operation.
"""
function DataFrames.DataFrame(g::Vector{<:AbstractEdge})
    hcat(
        DataFrame_(g, "Edge"),
        DataFrame_(keep.(g, Edge, StenoGraphs.Src), "Src"),
        DataFrame_(keep.(g, Edge, StenoGraphs.Dst), "Dst")
    )
end

"""
    StenoGraph(df::DataFrame)

!!! note "Package Extension"
    This method is provided by the `StenoGraphsDataFramesExt` extension.
    It requires loading DataFrames: `using DataFrames`

Convert a `DataFrame` back to a vector of edges (StenoGraph).

Extracts the "Edge" column from the DataFrame, which should contain the edge objects.
This is the inverse operation of `DataFrame(::Vector{<:AbstractEdge})`.

# Examples
```jldoctest
julia> using StenoGraphs, DataFrames

julia> g = @StenoGraph begin
           a → b
           b → c
       end;

julia> df = DataFrame(g);

julia> g2 = StenoGraph(df);

julia> issetequal(g, g2)
true
```

See also [`DataFrame(::Vector{<:AbstractEdge})`](@ref) for the conversion to DataFrame.
"""
StenoGraph(x::DataFrame) = x.Edge

end