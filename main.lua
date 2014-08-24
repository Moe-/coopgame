require('utils')
require('constants')
require('world')
require('vehicle')
require('mainmenu')
require('enemy')
require('destroyable')
require('undestroyable')

gScreen = nil

function createMainMenu()
	gScreen = MainMenu:new()
end

function love.load()
    createMainMenu()
	math.randomseed( os.time() )
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
