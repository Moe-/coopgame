-- preferred data types: .ogg for music, .wav for sound effects
class "Soundlist" {}

function Soundlist:__init()
  self.music = {
    ----example:
    -- music1 = love.audio.newSource("music.ogg")
    --music_main = love.audio.newSource("audio/music_main.ogg")
    --, -- next file here
  }

  self.soundEffects = {
    -- add official test sound before enabling the line below again
    -- testsound = love.audio.newSource("testsound.wav","static")
    ----example:
    -- sound = love.audio.newSource("sound.wav","static")
    --, -- next file here
  }
end

function Soundlist:getMusic(name)
	return self.music[name]
end

function Soundlist:getSound(name)
	return self.soundEffects[name]
end
