--> Run tests using frktest runner

local fs = require("@lune/fs")
local process = require("@lune/process")

local frktest = require("@pkg/frktest")

-- HACK: Cast require to allow for dynamic paths in strict mode
-- A more proper solution would be to use luau.load instead, but
-- frktest requires its global state to be modified by test suites
local require = require :: (path: string) -> () -> ()

if process.args[1] ~= nil then
        require("../tests/" .. process.args[1])()
else
        for _, test in fs.readDir("tests") do
                require("../tests/" .. test)()
        end
end

frktest._reporters.lune_console_reporter.init()
if not frktest.run() then
        process.exit(1)
end
