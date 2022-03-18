using Documenter
using DocumenterMarkdown
dir = mktempdir()
cp("Project.toml", joinpath(dir, "Project.toml"))
mkdir(joinpath(dir, "src/"))
cp("src/index.md", joinpath(dir, "src/README.md"))
makedocs(format = Markdown(), source = joinpath(dir, "src/"), build = joinpath(dir, "build/"), doctest=false)

s = read(joinpath(dir, "build/README.md"), String)
warn = "\n<!-- README.md is generated from docs/src/index.md. Please edit that file and rebuild with `cd docs/ && julia make_readme.jl`-->\n"
write("../README.md", warn*s)
