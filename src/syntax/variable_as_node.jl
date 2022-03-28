function variable_as_node!(ex, node::Type{T} where {T <: AbstractNode})
    ex
end

function variable_as_node!(ex::Symbol, node::Type{T} where {T <: AbstractNode})
    Expr(:call, node, QuoteNode(ex))
end

function variable_as_node!(ex::Expr, node::Type{T} where {T <: AbstractNode})
    to_quote = eachindex(ex.args)

    if ex.head == :call
        if ex.args[1] == :_ 
            length(ex.args) > 2 ? error("Unqote only a single argument. Right: `_(x)`, Wrong: `_(x, y)`.") : nothing
            return ex.args[2]
        end
        to_quote = to_quote[2:end]
    end
    for i in to_quote
        ex.args[i] = variable_as_node!(ex.args[i], node)
    end
    ex
end

variable_as_node!(ex) = variable_as_node!(ex, SimpleNode)

macro variable_as_node(ex)
    esc(variable_as_node!(ex, SimpleNode))
end
