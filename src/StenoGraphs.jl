module StenoGraphs

    export Node
    export SimpleNode
    export Edge
    export DirectedEdge
    export UndirectedEdge
    export Modifier
    export ModifiedEdge
    export ModifyingNode
    export @StenoGraph
    export *
    export convert
    export promote_rule
    export →, ←, ↔
    export ==

    include("graph_types.jl")
    include("syntax/symbol.jl")
    include("syntax/edge.jl")
    include("syntax/addition.jl")
    include("broadcast.jl")
    include("macro_communative.jl")
    include("syntax/macro.jl")
    include("modification.jl")
    include("symbol_as_node.jl")
    #include("compare.jl")
end
