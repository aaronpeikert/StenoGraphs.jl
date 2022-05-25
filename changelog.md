# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0]

### Added

* meld/merge of nodes and edges
* promotion from Edge to MetaEdge with emtpy metadata is possible

### Fixed

* `@StenoGraph` can be exported without exporting `unarrow`
* empty `ModDicts` are printed correctly

### Documentation

* Arrows get a long form documentation
* Dependencies of the documentation build are now locked in `Manifest.toml`

### Deprecated

* The use of symbols as nodes is deprecated

## [0.1.1]

### Added

* One can escape symbol quoting in `@StenoGraph` with `_(...)`

## [0.1.0]

### Added

* Richer type structure with AbstractEdge/AbstractNode at the top, followed by MetaEdge/MetaNode which contain Edge/Node with concrete types DirectedEdge/UndirectedEdge/SimpleNode
* Broadcasted arrows `→` ([`#10`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/10))
* Crossproduct arrows `⇒` ([`#10`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/10))
* Chainable arrows `a ← b ⇒ [c e]` ([`#10`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/10))
* @StenoGraph accepts multiline ([`#11`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/11))
* Modifiers are stored as Dict ([`#12`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/12))
* add show methods for edges ([`#13`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/13))
* ModifiedNode ([`#16`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/16))

### Fixed
* add hash method so that `isequal(edge1, edge2)` implies `hash(edge1) == hash(edge2)` ([`#17`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/17))

## [0.0.2]

Skipped in favor of [0.1.0].

## [0.0.1]

First release to [JuliaRegistries/General](https://github.com/JuliaRegistries/General/pull/53590).
