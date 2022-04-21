swap_node(x::AbstractNode, old::AbstractNode, new::AbstractNode) = x == old ? new : throw(KeyError(old))
swap_node(x, oldnew::Pair) = swap_node(x, oldnew...)
swap_node(x::T, old::Node, new::Node) where {T <: Union{ModifiedNode, ModifyingNode}} = T(swap_node(keep(x, Node), old, new), modifiers(x))
function swap_node(x::T, old, new) where {T <: Edge}
    if keep(x, Src) == old
        return T(swap_node(keep(x, Src), old, new), keep(x, Dst))
    elseif keep(x, Dst) == old
        return T(keep(x, Src), swap_node(keep(x, Dst), old, new))
    else
        throw(KeyError(old))
    end
end
swap_node(x::ModifiedEdge, old, new) = ModifiedEdge(swap_node(keep(x, Edge), old, new), modifiers(x))

swap_edge(x::AbstractEdge, old::AbstractEdge, new::AbstractEdge) = x == old ? new : throw(KeyError(old))
swap_edge(x, oldnew::Pair) = swap_edge(x, oldnew...)
swap_edge(x::ModifiedEdge, old::T, new::T) where {T <: Union{DirectedEdge, UndirectedEdge}} = ModifiedEdge(swap_edge(keep(x, Edge), old, new), modifiers(x))
