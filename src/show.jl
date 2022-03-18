import Base.show

function show(io::IO, a::SimpleNode)
    print(io, "$(a.node)")
end

function show(io::IO, a::Edge)
    print(io, "$(a.lhs) ~ $(a.rhs)")
end
