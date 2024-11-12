local frktest = require("@pkg/frktest")
local test = frktest.test
local check = frktest.assert.check

local Option = require("../luau_packages/option")
type Option<T> = Option.Option<T>

local Semver = require("../lib")

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
                                version.prerelease,
                                Option.Some({
                                        type = "beta",
                                        ordinal = Option.Some(1),
                                })
                        )
                end)

                test.case("Semver handles build metadata", function()
                        local res = Semver.parse("1.2.3+build.123")
                        check.is_true(res:isOk())

                        local version = res:unwrap()

                        check.equal(version.major, 1)
                        check.equal(version.minor, 2)
                        check.equal(version.patch, 3)
                        check.table.equal(version.buildMetadata, Option.Some("build.123"))
                end)

                test.case("Semver handles prerelease versions with build metadata", function()
                        local res = Semver.parse("1.2.3-beta.1+build.123")
                        check.is_true(res:isOk())

                        local version = res:unwrap()
                        check.equal(version.major, 1)
                        check.equal(version.minor, 2)
                        check.equal(version.patch, 3)

                        check.table.equal(
                                version.prerelease,
                                Option.Some({
                                        type = "beta",
                                        ordinal = Option.Some(1),
                                })
                        )

                        check.table.equal(version.buildMetadata, Option.Some("build.123"))
                end)
        end)
end
