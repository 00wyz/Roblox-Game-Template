local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local Maid = require(ReplicatedStorage.Packages.Maid)
local Audio = require(ReplicatedStorage.Shared.Audio)

type SoundDef = Audio.SoundDef

local SFX_GROUP = "SFX"
local MUSIC_GROUP = "Music"

local SoundController = {
	currentMusic = nil :: Sound?,
	_musicMaid = Maid.new(),
}

local function getGroup(name: string): SoundGroup
	local group = SoundService:FindFirstChild(name)
	if not group then
		group = Instance.new("SoundGroup")
		group.Name = name
		group.Parent = SoundService
	end
	return group :: SoundGroup
end

local function makeSound(def: SoundDef): Sound
	local sound = Instance.new("Sound")
	sound.SoundId = def.id
	sound.Volume = def.volume or 1
	sound.PlaybackSpeed = def.playbackSpeed or 1
	return sound
end

function SoundController:Init()
	getGroup(SFX_GROUP)
	getGroup(MUSIC_GROUP)
end

function SoundController:PlaySFX(name: string, volume: number?)
	local def = Audio.SFX[name]
	if not def then
		warn(string.format("[SoundController] SFX '%s' not found in Audio.SFX", name))
		return
	end

	local sound = makeSound(def)
	if volume then sound.Volume = volume end
	sound.Parent = getGroup(SFX_GROUP)
	sound:Play()

	sound.Ended:Once(function()
		sound:Destroy()
	end)
end

function SoundController:PlayMusic(name: string, fadeTime: number?)
	self:StopMusic(fadeTime)

	local def = Audio.Music[name]
	if not def then
		warn(string.format("[SoundController] Music '%s' not found in Audio.Music", name))
		return
	end

	local sound = makeSound(def)
	sound.Looped = true
	sound.Parent = getGroup(MUSIC_GROUP)

	if fadeTime then
		local target = sound.Volume
		sound.Volume = 0
		sound:Play()
		TweenService:Create(sound, TweenInfo.new(fadeTime), { Volume = target }):Play()
	else
		sound:Play()
	end

	self.currentMusic = sound
end

function SoundController:StopMusic(fadeTime: number?)
	local sound = self.currentMusic :: Sound
	if not sound then return end

	self.currentMusic = nil
	self._musicMaid:DoCleaning()

	if fadeTime then
		local tween = TweenService:Create(sound, TweenInfo.new(fadeTime), { Volume = 0 })
		tween:Play()
		self._musicMaid:GiveTask(tween.Completed:Once(function()
			sound:Destroy()
		end))
	else
		sound:Destroy()
	end
end

return SoundController
