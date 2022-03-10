macro StenoGraph(ex)
    @assert ex.head == :block "Please use a multiline block, e.g. @StenoGraph begin ... end"
    exs = filter(x -> !isa(x, LineNumberNode), ex.args)
    exs = StenoGraphs.quote_symbols.(exs)
    exs = StenoGraphs.addition_to_vector.(exs)
    vec = Expr(:call, :vcat, exs...)
    esc(:(vcat(unarrow.($vec)...)))
end
