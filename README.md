# semver-luau

<a href="https://discord.gg/ATVVsNNv3u"><img alt="Discord" src="https://img.shields.io/discord/385151591524597761?style=plastic&logo=discord&color=%235865F2" /></a>
<a href="https://pesde.daimond113.com/packages/0x5eal/semver"><img alt="Pesde" src="https://img.shields.io/badge/pesde-0x5eal/semver-F19D1E?&style=plastic&logo=data:image/svg%2bxml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMTAwIDEwMCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZmlsbC1ydWxlPSJldmVub2RkIiBjbGlwLXJ1bGU9ImV2ZW5vZGQiIGQ9Ik00OS42MDI1IDBMOTIuOTAzOCAyNVY3NUw0OS42MDI1IDEwMEw2LjMwMTI3IDc1VjI1TDQ5LjYwMjUgMFpNMTQuMzAxMyAyOS42MTg4TDQ5LjYwMjUgOS4yMzc2TDg0LjkwMzggMjkuNjE4OFY3MC4zODEyTDQ5LjYwMjUgOTAuNzYyNEwzMy42MTQ4IDgxLjUzMTlWNjcuMzg0OEMzNC41MTY3IDY4LjUwNzEgMzUuNjM4OCA2OS40MjE1IDM2Ljk4MSA3MC4xMjc5QzM4Ljk3MDEgNzEuMTQ4IDQxLjAzNTcgNzEuNjU4IDQzLjE3NzkgNzEuNjU4QzQ2LjQ0MiA3MS42NTggNDkuMTQ1MiA3MC44OTI5IDUxLjI4NzMgNjkuMzYyOUM1My40ODA1IDY3Ljc4MTggNTUuMTEyNiA2NS43NjcyIDU2LjE4MzYgNjMuMzE5QzU3LjA5MTUgNjEuMzM4MiA1Ny42MzIgNTkuMjc0IDU3LjgwNTQgNTcuMTI2M0M1OS44NzIzIDU3Ljc0NTcgNjIuMjE1NyA1OC4wNTU0IDY0LjgzNTYgNTguMDU1NEM2Ny42OTE4IDU4LjA1NTQgNzAuMzY5NSA1Ny42NDczIDcyLjg2ODYgNTYuODMxM0M3NS4zNjc4IDU1Ljk2NDIgNzcuNDA3OSA1NC44MTY3IDc4Ljk4OSA1My4zODg2TDc1Ljc3NTggNDcuODAzOEM3NC41NTE3IDQ4LjkyNTggNzIuOTk2MSA0OS44NDM5IDcxLjEwOSA1MC41NTc5QzY5LjIyMTkgNTEuMjIxIDY3LjIwNzMgNTEuNTUyNSA2NS4wNjUyIDUxLjU1MjVDNjEuMzkyOSA1MS41NTI1IDU4LjY2NDMgNTAuNjg1NCA1Ni44NzkyIDQ4Ljk1MTNDNTYuNzE5NSA0OC43OTYyIDU2LjU2NyA0OC42MzY1IDU2LjQyMTcgNDguNDcyQzU1LjYxMDIgNDcuNTUzOSA1NS4wMjExIDQ2LjQ4OTYgNTQuNjU0NiA0NS4yNzkxTDU0LjY0NDMgNDUuMjQ1Mkw1NC42NjkgNDUuMjc5MUg3OS4yMTg1VjQxLjk4OTRDNzkuMjE4NSAzOS4wMzEzIDc4LjU1NTUgMzYuMzUzNiA3Ny4yMjk0IDMzLjk1NjVDNzUuOTU0MyAzMS41NTkzIDc0LjA5MjcgMjkuNjQ2NyA3MS42NDQ1IDI4LjIxODZDNjkuMjQ3NCAyNi43Mzk1IDY2LjM2NTcgMjYgNjIuOTk5NSAyNkM1OS42ODQzIDI2IDU2LjgwMjcgMjYuNzM5NSA1NC4zNTQ1IDI4LjIxODZDNTEuOTA2NCAyOS42NDY3IDUwLjAxOTMgMzEuNTU5MyA0OC42OTMyIDMzLjk1NjVDNDcuNjc0MyAzNS43OTgzIDQ3LjA0NjkgMzcuODA1NyA0Ni44MTA4IDM5Ljk3ODhDNDUuNjg4OCAzOS43MjggNDQuNDc3OCAzOS42MDI2IDQzLjE3NzkgMzkuNjAyNkM0MS4wMzU3IDM5LjYwMjYgMzguOTcwMSA0MC4xMTI3IDM2Ljk4MSA0MS4xMzI3QzM1LjMxNjIgNDEuOTY1MSAzMy45OTAyIDQzLjE1NDkgMzMuMDAyOCA0NC43MDIzVjQwLjM2NzdIMjAuNjg1NVY0Ni4yNTg1SDI1LjgxMTNWNzcuMDI2NkwxNC4zMDEzIDcwLjM4MTJWMjkuNjE4OFpNNTUuMTk2MSAzNi4wOTg2QzU0LjY1MjggMzcuMTAxNSA1NC4zMzIxIDM4LjEyMTYgNTQuMjM0IDM5LjE1ODhINzEuNzk3NkM3MS43OTc2IDM4LjAzNjcgNzEuNDQwNSAzNi45NDAxIDcwLjcyNjUgMzUuODY5MUM3MC4wNjM0IDM0Ljc0NyA2OS4wNjg5IDMzLjgwMzUgNjcuNzQyOCAzMy4wMzg0QzY2LjQ2NzcgMzIuMjczNCA2NC44ODY3IDMxLjg5MDggNjIuOTk5NSAzMS44OTA4QzYxLjExMjQgMzEuODkwOCA1OS41MDU4IDMyLjI5ODkgNTguMTc5OCAzMy4xMTQ5QzU2LjkwNDcgMzMuODggNTUuOTEwMSAzNC44NzQ1IDU1LjE5NjEgMzYuMDk4NlpNNDkuNjQ1MSA1MS41NjkyQzQ5LjMwNzYgNTAuNjY0MSA0OC44MzgxIDQ5Ljg3MSA0OC4yMzY3IDQ5LjE4OThDNDguMDg4NSA0OS4wMjE5IDQ3LjkzMjMgNDguODYwOSA0Ny43NjgxIDQ4LjcwNjdDNDYuMDg1IDQ3LjA3NDYgNDQuMDQ0OSA0Ni4yNTg1IDQxLjY0NzggNDYuMjU4NUM0MC4xMTc3IDQ2LjI1ODUgMzguNjEzMSA0Ni41NjQ1IDM3LjEzNCA0Ny4xNzY2QzM1Ljg1OTQgNDcuNjc3MyAzNC42ODYzIDQ4LjU0MzggMzMuNjE0OCA0OS43NzU5VjYxLjQ3QzM0LjY4NjMgNjIuNjY2NCAzNS44NTk0IDYzLjUzNzggMzcuMTM0IDY0LjA4NEMzOC42MTMxIDY0LjY5NjEgNDAuMTE3NyA2NS4wMDIxIDQxLjY0NzggNjUuMDAyMUM0NC4wNDQ5IDY1LjAwMjEgNDYuMDg1IDY0LjE4NjEgNDcuNzY4MSA2Mi41NTRDNDkuNDUxMiA2MC45MjE5IDUwLjI5MjggNTguNjAxMiA1MC4yOTI4IDU1LjU5MjFDNTAuMjkyOCA1NC4wNjc5IDUwLjA3NjkgNTIuNzI3IDQ5LjY0NTEgNTEuNTY5MloiIGZpbGw9IiNGRkZGRkYiPjwvcGF0aD4KPC9zdmc+" /></a>
<a href="https://lune-org.github.io/docs"><img alt="Lune" src="https://raw.githubusercontent.com/0x5eal/semver-luau/refs/heads/main/.lune/assets/powered-by-lune.svg" /></a>


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
