-- preferred data types: .ogg for music, .wav for sound effects
class "Soundlist" {}

function Soundlist:__init()
  self.music = {
    ----example:
    -- music1 = love.audio.newSource("music.ogg")
    --music_main = love.audio.newSource("audio/music_main.ogg")
    --, -- next file here

	music_main_theme = love.audio.newSource("audio/music_main_theme.ogg"),
	music_menu_theme = love.audio.newSource("audio/music_menu_theme.ogg"),
  }

  self.soundEffects = {
    -- add official test sound before enabling the line below again
    -- testsound = love.audio.newSource("testsound.wav","static")
    ----example:
    -- sound = love.audio.newSource("sound.wav","static")
    --, -- next file here

	menu_mouseover_01  = love.audio.newSource("audio/menu_mouseover_01.wav", "static"),
	menu_mouseover_02  = love.audio.newSource("audio/menu_mouseover_02.wav", "static"),

	vehicle_explode_01 = love.audio.newSource("audio/vehicle_explode_01.wav", "static"),
	vehicle_explode_02 = love.audio.newSource("audio/vehicle_explode_02.wav", "static"),
	vehicle_explode_03 = love.audio.newSource("audio/vehicle_explode_03.wav", "static"),

  }
end

function Soundlist:getMusic(name)
	return self.music[name]
end

function Soundlist:getSound(name)
	return self.soundEffects[name]
end
