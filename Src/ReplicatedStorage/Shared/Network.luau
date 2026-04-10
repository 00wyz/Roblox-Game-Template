local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ByteNetMax = require(ReplicatedStorage.Packages["Bytenet-Max"])

return ByteNetMax.defineNamespace("Network", function()
	return {
		packets = {},
		queries = {},
		structs = {},
	}
end)
