local stdio = require("@lune/stdio")

local frktest = require("@pkg/frktest")
local Reporter = frktest._reporters.lune_console_reporter

local STYLE = table.freeze({
	suite = function(name: string)
		return `{stdio.style("bold")}{stdio.color("purple")}SUITE{stdio.style("reset")} {name}`
	end,

	report = function(name: string, state: "run" | "success" | "error" | "skip")
		local state_color: stdio.Color = if state == "run"
			then "white"
			elseif state == "success" then "green"
			elseif state == "error" then "red"
			elseif state == "skip" then "yellow"
			else error("Invalid test state")
		return `    {stdio.style("bold")}{stdio.color(state_color)}{if state == "skip" then "SKIP" else "TEST"}{stdio.style(
			"reset"
		)} {name}`
	end,
})

--- Clears a the previous line, and moves to its beginning
local function clear_last_line(): ()
	return stdio.write("\x1b[A\x1b[K\x1b[0G\x1b[?25h")
end

local ReporterExt = {}
function ReporterExt.init()
	frktest.test.on_suite_enter(function(suite)
		print(STYLE.suite(suite.name))
	end)

	frktest.test.on_suite_leave(function()
		stdio.write("\n")
	end)

	frktest.test.on_test_enter(function(test)
		print(STYLE.report(test.name, "run"))
	end)

	frktest.test.on_test_leave(function(test)
		clear_last_line()
		print(STYLE.report(test.name, if test.failed then "error" else "success"))
	end)

	frktest.test.on_test_skipped(function(test)
		print(STYLE.report(test.name, "skip"))
	end)

	Reporter.init()
end

return setmetatable(ReporterExt, { __index = Reporter })
