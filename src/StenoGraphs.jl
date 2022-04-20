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
    export EdgeModifier
    export NodeModifier
    export NodeOrEdgeModifier
    export ModifiedEdge
    export ModifyingNode
    export ModifiedNode
    export @StenoGraph
    export *
    export convert
    export promote_rule
    export →, ←, ↔, ⇒, ⇐, ⇔
    export ==
    export unmeta
    export unarrow
    export show
    export merge
    export swap_node

    include("graph_types.jl")
    include("syntax/variable_as_node.jl")
    include("syntax/arrow.jl")
    include("syntax/addition.jl")
    include("broadcast.jl")
    include("macro_communative.jl")
    include("syntax/macro.jl")
    include("modification.jl")
    include("conversion.jl")
    include("compare.jl")
    include("keep.jl")
    include("show.jl")
    include("id.jl")
    include("meld.jl")
    include("swap.jl")

    include("deprecate.jl")

end
