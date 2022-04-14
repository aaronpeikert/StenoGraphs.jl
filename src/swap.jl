swap_node(x::Node, old::Node, new::Node) = x == old ? new : KeyError(old)
swap_node(x, oldnew::Pair) = swap_node(x, oldnew...)
swap_node(x::T, old, new) where {T <: Union{ModifiedNode, ModifyingNode}} = T(swap_node(keep(x, Node), old, new), modifiers(x))

