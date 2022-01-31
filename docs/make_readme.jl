using Documenter
using DocumenterMarkdown
dir = mktempdir()
cp("Project.toml", joinpath(dir, "Project.toml"))
mkdir(joinpath(dir, "src/"))
cp("src/README.md", joinpath(dir, "src/README.md"))
makedocs(format = Markdown(), source = joinpath(dir, "src/"), build = joinpath(dir, "build/"))
s = read(joinpath(dir, "build/README.md"), String)
warn = "\n<!-- README.md is generated from docs/src/README.md. Please edit that file and rebuild with `cd docs/ && julia make_readme.jl`-->\n"
write("../README.md", warn*s)
