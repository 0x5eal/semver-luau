# semver-luau

<a href="https://discord.gg/ATVVsNNv3u"><img alt="Discord" src="https://img.shields.io/discord/385151591524597761?style=plastic&logo=discord&color=%235865F2" /></a>
<a href="https://lune-org.github.io/docs"><img alt="Lune" src="https://github.com/0x5eal/semver-luau/blob/main/.lune/assets/powered-by-lune.svg" /></a>

A Luau library to parse and compare [Semantic Versioning] compatible version numbers. 

Semantic Versioning (Semver) is a versioning scheme for software that uses a three-part version number format, `MAJOR.MINOR.PATCH`.
Additionally, Semver defines rules on when to increment each of these parts: 

- `MAJOR` version increments indicate incompatible API changes.
- `MINOR` version increments indicate the addition of functionality in a backward-compatible manner.
- `PATCH` version increments indicate backward-compatible bug fixes.

Semver also allows for optional pre-release and build metadata tags.

For a detailed set of guidelines that Semver version numbers follow, visit the previously linked website containing the full 
Semver specification.

## Usage

To improve error / nil handling ergnomics, this library makes use of [util.luau]'s [`Option`] and [`Result`] implementations. 
Any fallible methods return a [`Result`] and potentially null values are represented as [`Option`]s.

Invalid versions should return a [`Result`] with the respective error. If not, this is considered a bug, and please consider
filing an issue [here](https://github.com/0x5eal/semver-luau/issues).

```luau
local semver = require("semver")

-- Parse version strings
local v1 = semver.parse("1.2.3"):unwrap() --[[
  major = 1,
  minor = 2,
  patch = 3,
  buildMetadata = Option::None,
  prerelease = Option::None
]]
local v2 = semver.parse("5.12.0+build.1731248766"):unwrap() --[[
  major = 5,
  minor = 12,
  patch = 0,
  buildMetadata = Option::Some("build.1731248766"),
  prerelease = Option::None
]]

-- Compare versions
print(v1 < v2)  -- true
print(v1 > v2)  -- false
print(v1 == v2) -- false
```

## MSLV (Minimum Supported Luau Version)

This library requires at least requires at least Luau [0.629](https://github.com/luau-lang/luau/releases/tag/0.629), 
which corresponds to Lune [0.8.7](https://github.com/lune-org/lune/releases/tag/v0.8.7) (for leading `|` support).

## License

This project is licensed under the [MIT] license.

[Semantic Versioning]: https://semver.org
[util.luau]: https://github.com/lukadev-0/util.luau
[`Result`]: https://lukadev-0.github.io/util.luau/docs/error-handling
[`Option`]: https://lukadev-0.github.io/util.luau/docs/optional-values
[MIT]: https://compeydev.mit-license.org
