class "Destroyable" {
  
}

function Destroyable:__init(x, y, size, form, world, realWorld)
  self.x = x
  self.y = y
  self.size = size
  self.form = form
  self.body = love.physics.newBody(world, x + size/2, y + size/2, 'static')
  if form == 1 then
    self.shape = love.physics.newCircleShape(size/2)
  else
    self.shape = love.physics.newRectangleShape(size, size)
  end
  self.fixture = love.physics.newFixture(self.body, self.shape, 100)
  self.fixture:setFilterData(3, 3, 3)
  self.fixture:setUserData({["name"] = "destroyable", ["reference"] = self, ["world"] = realWorld})
end

function Destroyable:update(dt)
  
end

function Destroyable:draw()
  self.x,self.y = self.body:getPosition()
  
  love.graphics.setColor(255, 192, 255, 128)
  if self.form == 1 then
    love.graphics.circle("fill", self.x, self.y, self.size/2, 100)
  else
     love.graphics.rectangle("fill", self.x - self.size/2, self.y - self.size/2, self.size, self.size)
  end

  love.graphics.setColor(255, 255, 255, 255)
end
