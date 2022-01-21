function make_edge(ex)
    ex
end

function make_edge(ex::Expr)
    if ex.args[1] == :~
        ex.args[1] = :Edge
        return ex
    else
        for i in eachindex(ex.args)
            ex.args[i] = make_edge(ex.args[i])
        end
        return ex
    end
end

macro make_edge(ex)
    make_edge(ex)
end
