# julia

using StenoGraphs
@declare_nodes x1 x2 x3 ind60 dem60 dem65
import StenoGraphs.SimpleNode
SimpleNode(x::String) = SimpleNode(Symbol(x))

using StenoGraphs
graph = @StenoGraph begin
    [x1 x2 x3] ⇐ ind60 → dem60 ⇒ [dem65 y1 y2 y3 y4]
    ind60 → dem65 ⇒ [y5 y6 y7 y8]
    [y1 y2 y2 y3 y4 y6] ↔ [y5 y4 y6 y7 y8 y8]
end

@StenoGraph begin
    ind60 → x1 + x2 + x3
    dem60 → y1 + y2 + y3 + y4
    dem65 → y5 + y6 + y7 + y8
    # regressions
    dem60 ← ind60
    dem65 ← ind60 + dem60
    # residual correlations
    y1 ↔ y5
    y2 ↔ y4 + y6
    y3 ↔ y7
    y4 ↔ y8
    y6 ↔ y8
end

big5 = ["$b" for i in "OCEAN"]
facets = ["$f$b" for f in big5 for b in 1:6]
items = ["$(f)_$i" for f in facets for i in 1:4]
model = [Node(f) → Node(i) ]

big5 = ["$b" for b in "OCEAN"]
facets = [["$f$b" for b in 1:6] for f in big5] 
items = [[["$(f)_$i" for i in 1:4] for f in facet] for facet in facets]


big5 = Node.(["$b" for b in "OCEAN"])
third_level = big5 ⇔ big5
facets = [[Node("$f$b") for b in 1:6] for f in big5]
second_level = [b → f for (b, f) in zip(big5, facets)]
first_level = [[[f → Node("$(f)_$i") for i in 1:4] for f in facet] for facet in facets]
StenoGraph(Iterators.flatten((third_level, second_level, first_level))...)