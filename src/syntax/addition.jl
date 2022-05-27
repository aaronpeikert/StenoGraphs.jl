function addition_to_vector!(ex)
    ex
end

function addition_to_vector!(ex::Expr)
    if ex.args[1] == :+
        return Expr(:hcat, ex.args[2:end]...)
    else
        for i in eachindex(ex.args)
            ex.args[i] = addition_to_vector!(ex.args[i])
        end
        return ex
    end
end

macro addition_to_vector(ex)
    addition_to_vector!(ex)
end
