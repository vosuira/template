local remo = require("@Packages/fusion")
local t = require("@Packages/t")

type Remotes = {
	TestRemote: remo.ServerAsync,
}

local remotes: Remotes = remo.createRemotes({
	TestRemote = remo.remote(),
})

return remotes
