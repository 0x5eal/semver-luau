local frktest = require("@pkg/frktest")
local test = frktest.test
local check = frktest.assert.check

local Option = require("../luau_packages/option")
type Option<T> = Option.Option<T>

local Semver = require("../lib")

return function()
	test.suite("Stringification tests", function()
		test.case("A version constructed with new() when stringified should match expected string", function()
			local versionMap: { [string]: Semver.Version } = {
				["1.2.3"] = { major = 1, minor = 2, patch = 3, prerelease = Option.None, buildMetadata = Option.None },
				["1.0.0-alpha"] = {
					major = 1,
					minor = 0,
					patch = 0,
					prerelease = Option.Some({ type = "alpha" :: Semver.PreleaseType, ordinal = Option.None }),
					buildMetadata = Option.None,
				},
				["2.3.4-beta.1"] = {
					major = 2,
					minor = 3,
					patch = 4,
					prerelease = Option.Some({
						type = "beta" :: Semver.PreleaseType,
						ordinal = Option.Some(1),
					}),
					buildMetadata = Option.None,
				},
				["3.0.0-rc.1+build.123"] = {
					major = 3,
					minor = 0,
					patch = 0,
					prerelease = Option.Some({
						type = "rc" :: Semver.PreleaseType,
						ordinal = Option.Some(1),
					}),
					buildMetadata = Option.Some("build.123"),
				},
				["4.5.6+sha.xyz"] = {
					major = 4,
					minor = 5,
					patch = 6,
					prerelease = Option.None,
					buildMetadata = Option.Some("sha.xyz"),
				},
			}

			for expectedString, version in versionMap do
				local constructed = Semver.new(version :: Semver.Version)
				local stringified = tostring(constructed)

				check.equal(stringified, expectedString)
			end
		end)

		test.case("A parsed version when stringified should not change in roundtrip", function()
			local versions = {
				"1.2.3",
				"1.0.0-alpha",
				"2.3.4-beta.1",
				"3.0.0-rc.1+build.123",
				"4.5.6+sha.xyz",
				"5.0.0-alpha.1+build.999",
				"6.7.8-beta.2+exp.sha.5114f85",
				"7.0.0-alpha.1",
				"9.9.9+20230615",
			}

			for _, version in versions do
				local parsed = Semver.parse(version):unwrap()
				local stringified = tostring(parsed)

				check.equal(stringified, version)
			end
		end)
	end)
end
