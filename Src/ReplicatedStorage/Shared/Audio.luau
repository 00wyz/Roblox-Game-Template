export type SoundDef = {
	id: string,
	volume: number?,
	playbackSpeed: number?,
}

local Audio = {
	SFX = {} :: { [string]: SoundDef },
	Music = {} :: { [string]: SoundDef },
}

--[[
	Usage example:
	Audio.SFX.ButtonClick = { id = "rbxassetid://12345678", volume = 0.5 }
	Audio.Music.MainTheme  = { id = "rbxassetid://87654321", volume = 0.8 }
]]

return Audio
