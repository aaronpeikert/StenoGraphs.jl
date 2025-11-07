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
function DataFrames.DataFrame(x::Vector{<:AbstractEdge})
    hcat(
        DataFrame_(x, "Edge"),
        DataFrame_(keep.(e, (StenoGraphs.Src,)), "Src"),
        DataFrame_(keep.(e, (StenoGraphs.Dst,)), "Dst")
    )
end

end