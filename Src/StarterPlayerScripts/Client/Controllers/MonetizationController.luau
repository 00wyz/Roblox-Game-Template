local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local _Monetizations = require(ReplicatedStorage.Shared.Config.Monetizations)
local SoundController = require(script.Parent.SoundController)
local Maid = require(ReplicatedStorage.Packages.Maid)

local MonetizationController = {
	_maid = Maid.new()
}

function MonetizationController:GamePass(gamePassId)
	local ownsGamePass
	local success, err = pcall(function()
		ownsGamePass = MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, gamePassId)
	end)

	if not success then
		warn("An error occurred when checking if player owns GamePass: " .. tostring(err))
		return
	end

	if ownsGamePass then
		return
	end

	local purchaseSuccess, purchaseErr = pcall(function()
		MarketplaceService:PromptGamePassPurchase(LocalPlayer, gamePassId)
	end)

	if not purchaseSuccess then
		warn("An error occurred when prompting a game pass purchase: " .. tostring(purchaseErr))
	else
		self:_initPurchaseProcess()
	end
end

function MonetizationController:DeveloperProduct(productId)
	local success, err = pcall(function()
		MarketplaceService:PromptProductPurchase(LocalPlayer, productId)
	end)

	if not success then
		warn("An error occurred when prompting a product purchase: " .. tostring(err))
	else
		self:_initPurchaseProcess()
	end
end

function MonetizationController:_initPurchaseProcess()
	local playerGui = LocalPlayer:WaitForChild("PlayerGui") :: PlayerGui
	local monetizationProcessUI = playerGui:FindFirstChild("MonetizationProcessUI")
		or playerGui:FindFirstChild("MonetizationProcessUI", true)

	if monetizationProcessUI then
		(monetizationProcessUI :: ScreenGui).Enabled = true
	end

	SoundController:PlaySFX("purchase_process")
end

function MonetizationController:_endPurchaseProcess()
	local playerGui = LocalPlayer:FindFirstChild("PlayerGui") :: PlayerGui

	local monetizationProcessUI = playerGui:FindFirstChild("MonetizationProcessUI")
		or playerGui:FindFirstChild("MonetizationProcessUI", true)

	if monetizationProcessUI then
		(monetizationProcessUI :: ScreenGui).Enabled = false
	end
end

function MonetizationController:_purchaseCompleted(_, productId, isPurchased)
	self:_endPurchaseProcess()

	if isPurchased then
		if SoundController then
			SoundController:PlaySFX("purchase_completed")
		end
	end
end

function MonetizationController:Init()
	self._maid:DoCleaning()

	self._maid:GiveTask(MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(...)
		self:_purchaseCompleted(...)
	end))

	self._maid:GiveTask(MarketplaceService.PromptProductPurchaseFinished:Connect(function(...)
		self:_purchaseCompleted(...)
	end))
end

function MonetizationController:Destroy()
	self._maid:Destroy()
end

return MonetizationController
