local ServerStorage = game:GetService("ServerStorage")
local Cmdr = require(ServerStorage.ServerPackages.Cmdr) :: any

local CmdrService = {}

function CmdrService:Init()
	Cmdr:RegisterDefaultCommands()
	Cmdr:RegisterHooksIn(ServerStorage.Cmdr.Hooks)
	Cmdr:RegisterTypesIn(ServerStorage.Cmdr.Types)
	Cmdr:RegisterCommandsIn(ServerStorage.Cmdr.Commands)
end

return CmdrService
