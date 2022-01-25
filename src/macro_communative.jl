macro communative(ex)
    switched = copy(ex)
    @assert ex.head ∈ (:function, :(=))
    switched.args[1].args[2] = ex.args[1].args[3]
    switched.args[1].args[3] = ex.args[1].args[2]
    quote
        $(esc(ex))
        $(esc(switched))
    end
end
