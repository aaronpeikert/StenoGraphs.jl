struct Start <: Modifier
    s
end

@testset "Unmeta Node" begin
    @test unmeta(Node(:a)) == Node(:a)
    @test unmeta(Node(:a) * Start(4)) == Node(:a)
end

@testset "Unmeta Edge" begin
    @test unmeta(Edge(Node(:a), Node(:b))) == Edge(Node(:a), Node(:b))
    @test unmeta(Edge(Node(:a), Node(:b)) * Start(4)) == Edge(Node(:a), Node(:b))
end

