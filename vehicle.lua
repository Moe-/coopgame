class "Vehicle" {
	x = 0;
  y = 0;
}

function Vehicle:__init(x, y)
	self.x = x
  self.y = y
  
  self.vehicle = love.graphics.newImage('gfx/player.png')
  self.tower = love.graphics.newImage('gfx/tower.png')
  
  self.offsetGunX = (self.vehicle:getWidth() - self.tower:getWidth()) / 2
  self.offsetGunY = (self.vehicle:getHeight() - self.tower:getHeight()) / 2
end

function Vehicle:update(dt)

end

function Vehicle:draw()
  love.graphics.draw(self.vehicle, self.x, self.y)
  
  local x, y = love.mouse.getPosition()
  local r = math.atan2(x -self.x, self.y - y)
  love.graphics.draw(self.tower, self.x + self.offsetGunX, self.y + self.offsetGunY, r, 1, 1, self.tower:getWidth() / 2, self.tower:getHeight() / 2)
end