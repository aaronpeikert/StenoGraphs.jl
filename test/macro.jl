@testset "Declare nodes" begin
    @declare_nodes a b c
    @test StenoGraph(a → b) == [Edge(Node(:a), Node(:b))]
    @test StenoGraph(a → b, b → c)  == 
    StenoGraph(a → b → c) ==
    [Edge(Node(:a), Node(:b)), Edge(Node(:b), Node(:c))]
end

@testset "Declare nodes from" begin
    nodes = Symbol.(["x", "y", "z"])
    @declare_nodes_from(nodes)
    @test StenoGraph(x → y) == [Edge(Node(:x), Node(:y))]
    @test StenoGraph(x → y, y → z) == 
        StenoGraph(x → y → z) ==
        [Edge(Node(:x), Node(:y)), Edge(Node(:y), Node(:z))]
end
