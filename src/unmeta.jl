unmeta(x::Node) = x
unmeta(x::MetaNode) = unmeta(x.node)
unmeta(x::Edge) = x
unmeta(x::MetaEdge) = unmeta(x.edge)
