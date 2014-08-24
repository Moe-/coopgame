-- preferred data types: .ogg for music, .wav for sound effects
class "Soundlist" {}

function Soundlist:__init()
  self.music = {
    ----example:
    -- music1 = love.audio.newSource("music.ogg")
    --music_main = { src = love.audio.newSource("audio/music_main.ogg"), vol = 1 }
    --, -- next file here

	music_main_theme = { src = love.audio.newSource("audio/music_main_theme.ogg"), vol = 0 },
	music_menu_theme = { src = love.audio.newSource("audio/music_menu_theme.ogg"), vol = 0 },
  }

  self.soundEffects = {
    -- add official test sound before enabling the line below again
    -- testsound = love.audio.newSource("testsound.wav","static")
    ----example:
    -- sound = { src = love.audio.newSource("sound.wav","static"), vol = 1 }
    --, -- next file here

	menu_mouseover_01  = { src = love.audio.newSource("audio/menu_mouseover_01.wav", "static"), vol = 1 },
	menu_mouseover_02  = { src = love.audio.newSource("audio/menu_mouseover_02.wav", "static"), vol = 1 },

	menu_startgame     = { src = love.audio.newSource("audio/menu_startgame.wav", "static"), vol = 0 },

	vehicle_drive      = { src = love.audio.newSource("audio/vehicle_drive.wav", "static"), vol = 1 },

	vehicle_shoot_01    = { src = love.audio.newSource("audio/vehicle_shoot_01.wav", "static"), vol = 1 },
	vehicle_shoot_02    = { src = love.audio.newSource("audio/vehicle_shoot_02.wav", "static"), vol = 1 },
	vehicle_shoot_03    = { src = love.audio.newSource("audio/vehicle_shoot_03.wav", "static"), vol = 1 },

	vehicle_explode_01 = { src = love.audio.newSource("audio/vehicle_explode_01.wav", "static"), vol = 1 },
	vehicle_explode_02 = { src = love.audio.newSource("audio/vehicle_explode_02.wav", "static"), vol = 1 },
	vehicle_explode_03 = { src = love.audio.newSource("audio/vehicle_explode_03.wav", "static"), vol = 1 },

	enemy_shoot_01     = { src = love.audio.newSource("audio/enemy_shoot_01.wav", "static"), vol = 1 },
	enemy_shoot_02     = { src = love.audio.newSource("audio/enemy_shoot_02.wav", "static"), vol = 1 },
	enemy_shoot_03     = { src = love.audio.newSource("audio/enemy_shoot_03.wav", "static"), vol = 1 },

	enemy_death        = { src = love.audio.newSource("audio/enemy_death.wav", "static"), vol = 1 },
  }
end

function Soundlist:getMusic(name)
	return self.music[name].src, self.music[name].vol
end

function Soundlist:getSound(name)
	return self.soundEffects[name].src, self.soundEffects[name].vol
end
