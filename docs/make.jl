using Documenter
using StenoGraphs

makedocs(
    sitename = "StenoGraphs",
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true"
    ),
    modules = [StenoGraphs]
)
