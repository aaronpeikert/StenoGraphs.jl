using Documenter
using StenoGraphs

on_ci() = get(ENV, "CI", nothing) == "true"

DocMeta.setdocmeta!(StenoGraphs, :DocTestSetup, :(using StenoGraphs); recursive=true)
makedocs(
    sitename = "StenoGraphs",
    pages = [
        "Home" => "index.md",
        "Manual" => Any[
            "man/types.md",
            "man/arrows.md",
            "man/meld.md"
        ]
    ],
    format = Documenter.HTML(
        prettyurls = on_ci()
    ),
    modules = [StenoGraphs],
    doctest = true, # replace true with :fix to fix doctest
)

deploydocs(
    repo = "github.com/aaronpeikert/StenoGraphs.jl",
    devbranch = "devel",
    push_previews = "push_previews=true" ∈ ARGS
)

!on_ci() && include("make_readme.jl")
