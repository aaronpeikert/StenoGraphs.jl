function StenoGraph(ex)
    if ex.head == :block
        exs = filter(x -> !isa(x, LineNumberNode), ex.args)
        exs = StenoGraphs.variable_as_node!.(exs)
        exs = StenoGraphs.addition_to_vector!.(exs)
        vec = Expr(:call, :vcat, exs...)
        return esc(:(meld(vcat(StenoGraphs.unarrow.($vec)...))))
    else
        StenoGraph(Expr(:block, ex))
    end
end

macro StenoGraph(ex)
    StenoGraph(ex)
end
