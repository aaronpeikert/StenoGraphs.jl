# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.4.4]

### Added

* Package extension `StenoGraphsDataFramesExt` for DataFrame conversion support (requires Julia 1.9+)
* `DataFrame(::Vector{<:AbstractEdge})` method to convert graphs to DataFrames with separate columns for edge, source, and destination node modifiers
* `StenoGraph(::DataFrame)` method to convert DataFrames back to graphs
* DataFrames and Tables as weak dependencies

### Changed

* Minimum Julia version requirement updated from 1.6 to 1.9 (required for package extensions)
* CI pipeline updated to test on Julia 1.9, 1.12.1, and latest stable version
* Documentation workflows updated to use Julia 1.9

### Breaking Changes

* Minimum Julia version increased from 1.6 to 1.9 due to package extension requirements

## [0.4.3]

### Fixed

* Escape first argument of broadcasting (e.g., `fun.(_(a))`) to prevent function names from being interpreted as nodes ([`#65`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/65), closes [`#63`](https://github.com/aaronpeikert/StenoGraphs.jl/issues/63))

## [0.4.2]

### Added

* `IntNode` in addition to `SimpleNode` ([`#62`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/62))

## [0.4.1]

### Fixed

* `@StenoGraph` does not require `SimpleNode` to be defined globally

## [0.4.0]

### Added

* `@StenoGraphs` macro allows graphs to be inserted via escape mechanism
* `@StenoGraphs` macro converts symbols and vectors thereof in escape mechanism
* Graphs can be "merged" with `meld`

### Fixed

* Some of the conversion/promotion of Nodes is less ambiguous

### Breaking Changes

* The changes to the escape mechanism are technically breaking

## [0.3.0]

### Added

* `@declare_nodes` and `@declare_nodes_from` are added as alternatives to autoqouting/escaping ([`#57`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/57))

### Documentation

* Added documentation about how to quickly type arrows ([`#52`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/52))
* Fixed typos in Multiple nodes section ([`#53`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/53))
* Fixed documentation typos ([`#54`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/54))

## [0.2.0]

### Added

* Meld/merge of nodes and edges ([`#34`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/34), [`#38`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/38))
* Promotion from Edge to MetaEdge with empty metadata is possible ([`#33`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/33))

### Fixed
* `@StenoGraph` can be exported without exporting `unarrow`
* Empty `ModDicts` are printed correctly
* `NodeModifiers` are always kept by arrows
* Compare undirected edges correctly ([`#35`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/35))
* Meld edges in `@stenograph` ([`#46`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/46))

### Documentation
* Arrows get a long form documentation ([`#42`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/42))
* Added documentation about meld ([`#39`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/39))
* Dependencies of the documentation build are now locked in `Manifest.toml`

### Deprecated
* The use of symbols as nodes is deprecated ([`#29`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/29))

## [0.1.1]
### Added
* One can escape symbol quoting in `@StenoGraph` with `_(...)`

## [0.1.0]
### Added
* Richer type structure with AbstractEdge/AbstractNode at the top, followed by MetaEdge/MetaNode which contain Edge/Node with concrete types DirectedEdge/UndirectedEdge/SimpleNode
* Broadcasted arrows `→` ([`#10`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/10))
* Crossproduct arrows `⇒` ([`#10`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/10))
* Chainable arrows `a ← b ⇒ [c e]` ([`#10`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/10))
* `@StenoGraph` accepts multiline ([`#11`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/11))
* Modifiers are stored as Dict ([`#12`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/12))
* Add show methods for edges ([`#13`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/13))
* ModifiedNode ([`#16`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/16))

### Fixed
* Add hash method so that `isequal(edge1, edge2)` implies `hash(edge1) == hash(edge2)` ([`#17`](https://github.com/aaronpeikert/StenoGraphs.jl/pull/17))

## [0.0.2]

Skipped in favor of [0.1.0].

## [0.0.1]

First release to [JuliaRegistries/General](https://github.com/JuliaRegistries/General/pull/53590).
