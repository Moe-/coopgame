require('utils')
require('world')
require('vehicle')
require('enemy')
require('destroyable')
require('undestroyable')

gWorld = nil

function createWorld()
  gWorld = World:new(2048, 2048)
end

function love.load()
    createWorld()
end

function love.update(dt)
  gWorld:update(dt)
end

function love.draw()
  gWorld:draw()
end

function love.keypressed(key, unicode)
  if key == "escape" then
    love.event.quit()
  end
end