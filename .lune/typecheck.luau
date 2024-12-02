--> Run luau-lsp analysis to check for type errors

local process = require("@lune/process")

local CommandBuilder = require("./exec")

process.exit(
	CommandBuilder.new("luau-lsp")
		:withArg("analyze")
		:withArgs({ "--settings", ".vscode/settings.json" })
		:withArgs({ "--ignore", "'**/.pesde/**'" })
		:withArg(".")
		:withStdioStrategy("forward")
		:exec().code
)
