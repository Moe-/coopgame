require('utils')
require('constants')
require('world')
require('vehicle')
require('mainmenu')
require('enemy')
require('destroyable')
require('undestroyable')
require('particle')

gScreen = nil
gFont = love.graphics.newFont("gfx/DejaVuSans.ttf", 65)

function createMainMenu()
	gScreen = MainMenu:new()
end

function createWorld()
	return World:new(2048, 2048)
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
