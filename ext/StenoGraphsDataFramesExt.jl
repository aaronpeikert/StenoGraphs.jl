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
DataFrame_(x::Vector{<:AbstractNode}) = DataFrame_(x, "Node")
DataFrame_(x::Vector{<:Edge}) = DataFrame_(x, "Edge")
function DataFrames.DataFrame(g::Vector{<:AbstractEdge})
    hcat(
        DataFrame_(g, "Edge"),
        DataFrame_(keep.(g, Edge, StenoGraphs.Src), "Src"),
        DataFrame_(keep.(g, Edge, StenoGraphs.Dst), "Dst")
    )
end

end