import Base.*

function *(lhs::Modifier, rhs::Edge)
    ModifiedEdge(rhs, lhs)
end

function *(lhs::Edge, rhs::Modifier)
    ModifiedEdge(lhs, rhs)
end

function *(lhs::Node, rhs::Modifier)
    ModifyingNode(lhs, rhs)
end

function *(lhs::Modifier, rhs::Node)
    ModifyingNode(rhs, lhs)
end

function *(lhs::Modifier, rhs::Modifier)
    vec([lhs rhs])
end

function *(lhs::VecOrMat{M} where {M <: Modifier}, rhs::VecOrMat{M} where {M <: Modifier})
    vec([vec(lhs)... vec(rhs)...])
end

function *(lhs::VecOrMat{M} where {M <: Modifier}, rhs::Node)
    ModifyingNode(rhs, lhs)
end

function *(lhs::Node, rhs::VecOrMat{M} where {M <: Modifier})
    ModifyingNode(lhs, rhs)
end
