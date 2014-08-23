require('utils')
require('world')
require('vehicle')
require('mainmenu')

gScreen = nil

function createMainMenu()
	gScreen = MainMenu:new()
end

function love.load()
    createMainMenu()
end

function love.update(dt)
  gScreen:update(dt)
end

function love.draw()
  gScreen:draw()
end

function love.keypressed(key, unicode)
  if key == "escape" then
    love.event.quit()
  end
end
