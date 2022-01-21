import Base.*

function *(lhs::Modifier, rhs::Edge)
    ModifiedEdge(rhs, lhs)
end

function *(lhs::Edge, rhs::Modifier)
    ModifiedEdge(lhs, rhs)
end

function *(lhs::Node, rhs::Modifier)
    ModifiedNode(lhs, rhs)
end

function *(lhs::Modifier, rhs::Node)
    ModifiedNode(lhs, rhs)
end

function *(lhs::Symbol, rhs::Modifier)
    ModifiedNode(lhs, rhs)
end

function *(lhs::Modifier, rhs::Node)
    ModifiedNode(lhs, rhs)
end