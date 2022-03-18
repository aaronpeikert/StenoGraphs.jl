macro StenoGraph(ex)
    ex = quote_symbols(ex)
    ex = addition_to_vector(ex)
    esc(ex)
end