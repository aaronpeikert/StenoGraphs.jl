using Documenter
using StenoGraphs

on_ci() = get(ENV, "CI", nothing) == "true"

makedocs(
    sitename = "StenoGraphs",
    format = Documenter.HTML(
        prettyurls = on_ci()
    ),
    modules = [StenoGraphs]
)

deploydocs(
    repo = "github.com/aaronpeikert/StenoGraphs.jl",
    devbranch = "devel"
)

!on_ci() && include("make_readme.jl")
