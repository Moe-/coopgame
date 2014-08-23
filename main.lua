require('utils')

function love.load()

end

function love.update(dt)

end

function love.draw()
  love.graphics.print('Hello World!', 400, 300)
end

function love.keypressed(key, unicode)
  if key == "escape" then
    love.event.quit()
  end
end