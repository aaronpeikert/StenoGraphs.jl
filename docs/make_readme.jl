using Documenter
using DocumenterMarkdown
dir = mktempdir()
cp("Project.toml", joinpath(dir, "Project.toml"))
mkdir(joinpath(dir, "src/"))
cp("src/README.md", joinpath(dir, "src/README.md"))
makedocs(format = Markdown(), source = joinpath(dir, "src/"), build = joinpath(dir, "build/"))
cp(joinpath(dir, "build/README.md"), "../README.md", force = true)
