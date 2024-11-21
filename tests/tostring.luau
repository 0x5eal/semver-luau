local frktest = require("@pkg/frktest")
local test = frktest.test
local check = frktest.assert.check

local Option = require("../luau_packages/option")
type Option<T> = Option.Option<T>

local Semver = require("../lib")

return function()
	test.suite("Stringification tests", function()
		test.case("A parsed version when stringified should not change", function()
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
