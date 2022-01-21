function quote_symbols(ex)
    ex
end

function quote_symbols(ex::Symbol)
    QuoteNode(ex)
end

function quote_symbols(ex::Expr)
    to_quote = eachindex(ex.args)

    if ex.head == :call
        to_quote = to_quote[2:end]
    end
    for i in to_quote
        ex.args[i] = quote_symbols(ex.args[i])
    end
    ex
end

macro quote_symbols(ex)
    quote_symbols(ex)
end
