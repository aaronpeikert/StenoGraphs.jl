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
    ModifiedNode(rhs, lhs)
end

function *(lhs::Symbol, rhs::Modifier)
    ModifiedNode(lhs, rhs)
end

function *(lhs::Modifier, rhs::Symbol)
    ModifiedNode(rhs, lhs)
end

function *(lhs::Modifier, rhs::Modifier)
    vec([lhs rhs])
end

function *(lhs::VecOrMat{M} where {M <: Modifier}, rhs::VecOrMat{M} where {M <: Modifier})
    vec([vec(lhs)... vec(rhs)...])
end

function *(lhs::VecOrMat{M} where {M <: Modifier}, rhs::Symbol)
    lhs*Node(rhs)
end

function *(lhs::Symbol, rhs::VecOrMat{M} where {M <: Modifier})
    rhs*Node(lhs)
end

function *(lhs::VecOrMat{M} where {M <: Modifier}, rhs::Node)
    ModifiedNode(rhs, lhs)
end

function *(lhs::Node, rhs::VecOrMat{M} where {M <: Modifier})
    ModifiedNode(lhs, rhs)
end
