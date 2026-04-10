local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Loader = require(ReplicatedStorage.Packages.Loader)

local ServerFolder = script.Parent :: Instance

local Services = ServerFolder:WaitForChild("Services") :: Folder
local Components = ServerFolder:WaitForChild("Components") :: Folder

Loader.SpawnAll(Loader.LoadDescendants(Services), "Init")
Loader.LoadDescendants(Components)