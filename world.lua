class "World" {
	width = 10;
  height = 10;
}

function World:__init(width, height)
	self.width = width
  self.height = height
  
  self:generateUndestroyableObjects(10)
  self:generateDestroyableObjects(10)
  self:generateEnemies(20)
  
  self.player = Vehicle:new(20, 20)
  
  self.backgroundImg = love.graphics.newImage('gfx/background.png')
  self.backgroundImg:setWrap('repeat', 'repeat')
  self.backgroundQuad = love.graphics.newQuad(0, 0, width, height, self.backgroundImg:getWidth(), self.backgroundImg:getHeight())
end

function World:generateUndestroyableObjects(count)

end

function World:generateDestroyableObjects()
  
end

function World:generateEnemies()
  
end

function World:update(dt)
  self.player:update(dt)
end

function World:draw()
  love.graphics.draw(self.backgroundImg, self.backgroundQuad, 0, 0)
  
  self.player:draw()
end
