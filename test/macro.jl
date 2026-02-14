@testset "Declare nodes" begin
    @declare_nodes a b c
    @test StenoGraph(a → b) == [Edge(Node(:a), Node(:b))]
    @test StenoGraph(a → b, b → c)  == 
    StenoGraph(a → b → c) ==
    [Edge(Node(:a), Node(:b)), Edge(Node(:b), Node(:c))]
end

@testset "Declare nodes from" begin
    # Symbols (original behavior)
    nodes = Symbol.(["x", "y", "z"])
    @declare_nodes_from(nodes)
    @test StenoGraph(x → y) == [Edge(Node(:x), Node(:y))]
    @test StenoGraph(x → y, y → z) ==
        StenoGraph(x → y → z) ==
        [Edge(Node(:x), Node(:y)), Edge(Node(:y), Node(:z))]

    # AbstractNodes
    node_vec = [Node(:p), Node(:q)]
    @declare_nodes_from(node_vec)
    @test p == Node(:p)
    @test StenoGraph(p → q) == [Edge(Node(:p), Node(:q))]

    # Preserves ModifiedNode
    struct _TestDNFMod <: NodeModifier; v::String; end
    mod_vec = [Node(:m)^_TestDNFMod("M"), Node(:n)]
    @declare_nodes_from(mod_vec)
    @test m isa ModifiedNode
    @test id(m) == :m
    # Note: Julia's array promotion wraps Node(:n) in ModifiedNode when
    # the vector also contains a ModifiedNode, so n becomes a ModifiedNode too.
    @test id(n) == :n

    # Mixed Symbols and Nodes
    mixed = Any[:s, Node(:t)]
    @declare_nodes_from(mixed)
    @test s == Node(:s)
    @test t == Node(:t)
end
