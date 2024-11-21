local frktest = require("@pkg/frktest")
local test = frktest.test
local check = frktest.assert.check

local Semver = require("../lib")

return function()
	test.suite("Invalid semver parsing tests", function()
		test.case("Rejects missing components", function()
			local res = Semver.parse("1.2")
			check.is_true(res:isErr())
			check.table.contains(res:unwrapErr(), {
				kind = {
					id = "MandatoryComponentMissing",
					components = { "1", "2" },
				},
			})
		end)

		test.case("Rejects invalid component types", function()
			-- Test invalid major
			local res = Semver.parse("a.2.3")
			check.is_true(res:isErr())
			check.table.contains(res:unwrapErr(), {
				kind = {
					id = "InvalidComponentType",
					component = "major",
					got = "char",
				},
			})

			-- Test invalid minor with symbols
			res = Semver.parse("1.$.3")
			check.is_true(res:isErr())
			check.table.contains(res:unwrapErr(), {
				kind = {
					id = "InvalidComponentType",
					component = "minor",
					got = "symbol",
				},
			})

			-- Test invalid patch
			res = Semver.parse("1.2.x")
			check.is_true(res:isErr())
			check.table.contains(res:unwrapErr(), {
				kind = {
					id = "InvalidComponentType",
					component = "patch",
					got = "char",
				},
			})
		end)

		test.case("Rejects leading zeros", function()
			-- Test leading zeros in major
			local res = Semver.parse("01.2.3")
			check.is_true(res:isErr())
			check.table.contains(res:unwrapErr(), {
				kind = {
					id = "LeadingZerosPresent",
					component = "major",
				},
			})

			-- Test leading zeros in minor
			res = Semver.parse("1.02.3")
			check.is_true(res:isErr())
			check.table.contains(res:unwrapErr(), {
				kind = {
					id = "LeadingZerosPresent",
					component = "minor",
				},
			})

			-- Test leading zeros in patch
			res = Semver.parse("1.2.03")
			check.is_true(res:isErr())
			check.table.contains(res:unwrapErr(), {
				kind = {
					id = "LeadingZerosPresent",
					component = "patch",
				},
			})
		end)

		test.case("Rejects invalid prerelease types", function()
			local res = Semver.parse("1.2.3-gamma.1")
			check.is_true(res:isErr())
			check.table.contains(res:unwrapErr(), {
				kind = {
					id = "InvalidPrereleaseType",
					type = "gamma",
				},
			})
		end)

		test.case("Rejects invalid prerelease ordinals", function()
			-- Test with character ordinal
			local res = Semver.parse("1.2.3-beta.a")
			check.is_true(res:isErr())
			check.table.contains(res:unwrapErr(), {
				kind = {
					id = "InvalidPrereleaseOrdinalType",
					expected = "number",
					got = "char",
				},
			})

			-- Test with symbol ordinal
			res = Semver.parse("1.2.3-beta.$")
			check.is_true(res:isErr())
			check.table.contains(res:unwrapErr(), {
				kind = {
					id = "InvalidPrereleaseOrdinalType",
					expected = "number",
					got = "symbol",
				},
			})

			-- Test with extra symbols in ordinal
			res = Semver.parse("1.2.3-beta.3.4.5")
			check.is_true(res:isErr())
			check.table.contains(res:unwrapErr(), {
				kind = {
					id = "InvalidPrereleaseOrdinalType",
					expected = "number",
					got = "symbol",
				},
			})

			-- Test with extra symbols in ordinal and build metadata
			res = Semver.parse("1.2.3-beta.3.4.5+build.1732213169")
			check.is_true(res:isErr())
			check.table.contains(res:unwrapErr(), {
				kind = {
					id = "InvalidPrereleaseOrdinalType",
					expected = "number",
					got = "symbol",
				},
			})
		end)
	end)
end
