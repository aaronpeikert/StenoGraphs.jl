macro StenoGraph(ex)
    if ex.head == :block
        exs = filter(x -> !isa(x, LineNumberNode), ex.args)
        exs = StenoGraphs.quote_symbols!.(exs)
        exs = StenoGraphs.addition_to_vector!.(exs)
        vec = Expr(:call, :vcat, exs...)
        return esc(:(vcat(unarrow.($vec)...)))
    else
        StenoGraphs.quote_symbols!(ex)
        StenoGraphs.addition_to_vector!(ex)
        return esc(:(unarrow($ex)))
    end
end
