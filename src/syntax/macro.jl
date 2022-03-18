macro StenoGraph(ex)
    if ex.head == :block "Please use a multiline block, e.g. @StenoGraph begin ... end"
        exs = filter(x -> !isa(x, LineNumberNode), ex.args)
        exs = StenoGraphs.quote_symbols.(exs)
        exs = StenoGraphs.addition_to_vector.(exs)
        vec = Expr(:call, :vcat, exs...)
        return esc(:(vcat(unarrow.($vec)...)))
    else
        exs = StenoGraphs.quote_symbols(ex)
        exs = StenoGraphs.addition_to_vector(ex)
        return esc(:(unarrow($ex)))
    end
end
