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
function DataFrames.DataFrame(g::Vector{<:AbstractEdge})
    hcat(
        DataFrame_(g, "Edge"),
        DataFrame_(keep.(g, Edge, StenoGraphs.Src), "Src"),
        DataFrame_(keep.(g, Edge, StenoGraphs.Dst), "Dst")
    )
end

StenoGraph(x::DataFrame) = x.Edge

end