macro semi(ex)
    ex = quote_symbols(ex)
    ex = addition_to_vector(ex)
    ex = make_edge(ex)
    ex
end