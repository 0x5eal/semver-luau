local frktest = require("../lune_packages/frktest").core
local test = frktest.test
local check = frktest.assert.check

local Option = require("../luau_packages/option")
type Option<T> = Option.Option<T>

local Semver = require("../lib")

-- FIXME: Any casts all over the place, because of frktest not being correctly typed
-- See https://github.com/itsfrank/frktest/issues/2

return function()
	test.suite("Basic tests", function()
		test.case("Semver creates valid version objects", function()
			local res = Semver.parse("1.2.3-beta.1")
			check.is_true(res:isOk())

			local version = res:unwrap()
			check.equal(version.major, 1)
			check.equal(version.minor, 2)
			check.equal(version.patch, 3)
		end)

		test.case("Semver handles prerelease versions", function()
			local res = Semver.parse("1.2.3-beta.1")
			check.is_true(res:isOk())

			local version = res:unwrap()
			check.equal(version.major, 1)
			check.equal(version.minor, 2)
			check.equal(version.patch, 3)

			check.table.equal(
				version.prerelease :: any,
				Option.Some({
					type = "beta",
					ordinal = Option.Some(1),
				}) :: any
			)
		end)

		test.case("Semver handles build metadata", function()
			local res = Semver.parse("1.2.3+build.123")
			check.is_true(res:isOk())

			local version = res:unwrap()

			check.equal(version.major, 1)
			check.equal(version.minor, 2)
			check.equal(version.patch, 3)
			check.table.equal(version.buildMetadata :: any, Option.Some("build.123") :: any)
		end)

		test.case("Semver handles prerelease versions with build metadata", function()
			local res = Semver.parse("1.2.3-beta.1+build.123")
			check.is_true(res:isOk())

			local version = res:unwrap()
			check.equal(version.major, 1)
			check.equal(version.minor, 2)
			check.equal(version.patch, 3)

			check.table.equal(
				version.prerelease :: any,
				Option.Some({
					type = "beta",
					ordinal = Option.Some(1),
				}) :: any
			)

			check.table.equal(version.buildMetadata :: any, Option.Some("build.123") :: any)
		end)
	end)
end
