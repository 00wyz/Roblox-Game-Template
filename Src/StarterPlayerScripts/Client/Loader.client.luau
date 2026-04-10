local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Loader = require(ReplicatedStorage.Packages.Loader)

local ClientFolder = script.Parent :: Instance

local Controllers = ClientFolder:WaitForChild("Controllers") :: Folder
local Components = ClientFolder:WaitForChild("Components") :: Folder

Loader.SpawnAll(Loader.LoadDescendants(Controllers), "Init")
Loader.LoadDescendants(Components)