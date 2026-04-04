local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ProfileService = require(ServerStorage.ServerPackages.ProfileService)
local ProfileTemplate = require(ReplicatedStorage.Shared.Data.ProfileTemplate)
local Maid = require(ReplicatedStorage.Packages.Maid)

local PROFILE_STORE_KEY = "PlayerData-v1"

local PlayerDataService = {
	_playerProfiles = {} :: { [Player]: any },
	_maid = Maid.new(),
}

local ProfileStore = (ProfileService :: any).GetProfileStore({ Name = PROFILE_STORE_KEY }, ProfileTemplate)

function PlayerDataService:GetData(player: Player): any?
	local profile = self._playerProfiles[player]
	return profile and profile.Data or nil
end

function PlayerDataService:UpdateData(player: Player, key: string, value: any): boolean
	local profile = self._playerProfiles[player]
	if not profile then
		warn(string.format("[PlayerDataService] UpdateData failed: No profile for %s", player.Name))
		return false
	end
	profile.Data[key] = value
	return true
end

function PlayerDataService:SaveData(player: Player): boolean
	local profile = self._playerProfiles[player]
	if not profile then return false end

	local success, err = pcall(function()
		profile:Save()
	end)

	if not success then
		warn(string.format("[PlayerDataService] Failed to save data for %s: %s", player.Name, tostring(err)))
	end

	return success
end

function PlayerDataService:OnPlayerAdded(player: Player)
	local profile = (ProfileStore :: any):LoadProfileAsync("Player_" .. player.UserId, "ForceLoad")

	if not profile then
		player:Kick("Failed to load data.")
		return
	end

	profile:Reconcile()
	profile:ListenToRelease(function()
		self._playerProfiles[player] = nil
		if player.Parent then
			player:Kick("Data released.")
		end
	end)

	if not player:IsDescendantOf(Players) then
		profile:Release()
		return
	end

	self._playerProfiles[player] = profile
	player:SetAttribute("StoreName", profile.Data.StoreName)
	player:SetAttribute("DataLoaded", true)
end

function PlayerDataService:OnPlayerRemoving(player: Player)
	local profile = self._playerProfiles[player]
	if profile then
		profile:Release()
		self._playerProfiles[player] = nil
	end
end

function PlayerDataService:Init()
	self._maid:GiveTask(Players.PlayerAdded:Connect(function(player)
		self:OnPlayerAdded(player)
	end))

	self._maid:GiveTask(Players.PlayerRemoving:Connect(function(player)
		self:OnPlayerRemoving(player)
	end))

	for _, player in ipairs(Players:GetPlayers()) do
		task.spawn(function()
			self:OnPlayerAdded(player)
		end)
	end
end

return PlayerDataService