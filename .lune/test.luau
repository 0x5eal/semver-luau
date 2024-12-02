--> Run tests using frktest runner

local fs = require("@lune/fs")
local process = require("@lune/process")

local frktest = require("@pkg/frktest")
local reporter = require("../tests/_reporter")

-- HACK: Cast require to allow for dynamic paths in strict mode
-- A more proper solution would be to use luau.load instead, but
-- frktest requires its global state to be modified by test suites
local require = require :: (
	path: string
) -> (
	test: typeof(setmetatable(
		{} :: {
			case: (name: string, fn: () -> nil) -> (),
			suite: (name: string, fn: () -> ()) -> (),
		},
		{ __index = frktest.test }
	))
) -> ()

local allowed_tests = process.args
for _, test in fs.readDir("tests") do
	-- If we are given any arguments, we only run those tests, otherwise,
	-- we run all the tests

	-- So, to include only a certain set of test files, you can provide either
	-- the full path to the test file (with or without the extension) or the test
	-- file name
	local withoutExt = string.sub(test, 1, -6)
	local is_allowed = #process.args == 0
		or table.find(allowed_tests, `tests/{test}`)
		or table.find(allowed_tests, withoutExt)
		or table.find(allowed_tests, `tests/{withoutExt}`)

	local constructors = {
		case = frktest.test.case,
		suite = frktest.test.suite,
	}

	if not is_allowed then
		constructors.case = frktest.test.skip.case
		constructors.suite = frktest.test.skip.suite
	end

	-- Ignore files starting with underscores, eg: _reporter.luau
	if string.sub(test, 1, 1) == "_" then
		continue
	end

	require("../tests/" .. test)(setmetatable(constructors, { __index = frktest.test }))
end

reporter.init()
process.exit(tonumber(frktest.run()))
