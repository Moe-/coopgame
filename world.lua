class "World" {
	width = 10;
  height = 10;
}

function World:__init(width, height)
	self.width = width
  self.height = height
  self.backgroundImg = love.graphics.newImage('gfx/background.png')
  self.backgroundImg:setWrap('repeat', 'repeat')
  self.backgroundQuad = love.graphics.newQuad(0, 0, width, height, self.backgroundImg:getWidth(), self.backgroundImg:getHeight())
end

function World:update(dt)

end

function World:draw()
  love.graphics.draw(self.backgroundImg, self.backgroundQuad, 0, 0)
end
