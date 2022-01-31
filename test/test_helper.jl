# stolen from https://discourse.julialang.org/t/what-general-purpose-commands-do-you-usually-end-up-adding-to-your-projects/4889/2

#@generated function ≂(x, y)
#    if !isempty(fieldnames(x)) && x == y
#        mapreduce(n -> :(x.$n ≂ y.$n), (a,b)->:($a && $b), fieldnames(x))
#    else
#        :(x == y)
#    end
#end

#function ≂(x::Vector, y::Vector)
#    if length(x) == length(y)
#        all(x[i] ≂ y[i] for i in 1:length(x))
#    else
#        false
#    end
#end
