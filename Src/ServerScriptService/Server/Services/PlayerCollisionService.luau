local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Maid = require(ReplicatedStorage.Packages.Maid)

local PlayerCollisionService = {
	_maid = Maid.new()
}

function PlayerCollisionService:SetCharacterCollisionGroup(character: Model)
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CollisionGroup = "Players"
		end
	end
end

function PlayerCollisionService:OnPlayerAdded(player: Player)
	self._maid:GiveTask(player.CharacterAdded:Connect(function(character)
		self:SetCharacterCollisionGroup(character)
	end))
end

function PlayerCollisionService:Init()
	self._maid:DoCleaning()
	self._maid:GiveTask(Players.PlayerAdded:Connect(function(player)
		self:OnPlayerAdded(player)
	end))
end

return PlayerCollisionService
