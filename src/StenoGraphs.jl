module StenoGraphs

    export AbstractNode
    export Node
    export MetaNode
    export SimpleNode
    export AbstractEdge
    export Edge
    export MetaEdge
    export DirectedEdge
    export UndirectedEdge
    export Modifier
    export ModifiedEdge
    export ModifyingNode
    export @StenoGraph
    export *
    export convert
    export promote_rule
    export →, ←, ↔, ⇒, ⇐, ⇔
    export ==
    export unmeta
    export unarrow

    include("graph_types.jl")
    include("syntax/symbol.jl")
    include("syntax/arrow.jl")
    include("syntax/addition.jl")
    include("broadcast.jl")
    include("macro_communative.jl")
    include("syntax/macro.jl")
    include("modification.jl")
    include("symbol_as_node.jl")
    include("compare.jl")
    include("keep.jl")
end
