local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Loader = require(ReplicatedStorage.Packages:WaitForChild("Loader"))

local ServerFolder = script.Parent

local Services = ServerFolder:WaitForChild("Services")
local Components = ServerFolder:WaitForChild("Components")

Loader.SpawnAll(Loader.LoadDescendants(Services), "Init")
Loader.LoadDescendants(Components)