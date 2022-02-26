→(lhs, rhs) = Arrow(DirectedEdge(lhs, rhs), lhs, rhs)
←(lhs, rhs) = Arrow(DirectedEdge(rhs, lhs), lhs, rhs)
↔(lhs, rhs) = Arrow(UndirectedEdge(lhs, rhs), lhs, rhs)
