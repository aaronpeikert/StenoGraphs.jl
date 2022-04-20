swap_node(x::Node, old::Node, new::Node) = x == old ? new : KeyError(old)
swap_node(x, oldnew::Pair) = swap_node(x, oldnew...)
swap_node(x::T, old, new) where {T <: Union{ModifiedNode, ModifyingNode}} = T(swap_node(keep(x, Node), old, new), modifiers(x))

function swap_node(x::T, old::Node, new::Node) where {T <: Edge}
    if keep(x, Src) == old
        return T(swap_node(keep(x, Src), old, new), keep(x, Dst))
    elseif keep(x, Dst) == old
        return T(keep(x, Src), swap_node(keep(x, Dst), old, new))
    else
        KeyError(old)
    end
end
