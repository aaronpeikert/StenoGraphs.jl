import Base.show

# fallback for Abstract
function show(io::IO, a::AbstractEdge)
    print(io, "$(a.edge)")
end

function show(io::IO, a::AbstractNode)
    print(io, "$(a.node)")
end

function show(io::IO, a::SimpleNode)
    print(io, "$(a.node)")
end

function show(io::IO, a::ModifyingNode)
    print(io, "$(a.node) * $(a.modifiers)")
end

function show(io::IO, a::DirectedEdge)
    print(io, "$(a.src) → $(a.dst)")
end

function show(io::IO, a::UndirectedEdge)
    print(io, "$(a.src) ↔ $(a.dst)")
end

function show(io::IO, a::Vector{E}) where {E <: AbstractEdge}
    for e in a
       print(io, "$(e)\n")
    end
end

function show(io::IO, ::MIME"text/plain", a::Vector{E}) where {E <: AbstractEdge}
    show(io, a)
end

function show(io::IO, a::Arrow)
    print(io, "$(a.edges)")
end

function show(io::IO, a::ModifiedEdge)
    print(io, "$(a.edge) * $(a.modifiers)")
end

function show(io::IO, a::ModifiedNode)
    print(io, "$(a.node)^$(a.modifiers)")    
end

function show(io::IO, a::Dict{Symbol, M}) where {M <: Modifier}
    if length(a) > 0
        keyset = [k for k in keys(a)]
        if length(keyset) > 1
            print(io, "[")
            for i in 1:(length(keyset) - 1)
                k = keyset[i]
                print(io, "$(a[k]), ")
            end
            print(io, "$(a[last(keyset)])]")
        else
            print(io, "$(a[last(keyset)])")
        end
    else
        print(io, nothing)
    end
end

function show(io::IO, ::MIME"text/plain", a::Dict{Symbol, M}) where {M <: Modifier}
    show(io, a)
end