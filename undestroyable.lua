class "Undestroyable" {
  
}

function Undestroyable:__init(x, y, size, form, world, realWorld)
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
  self.fixture:setFilterData(PHYSICS_CATEGORY_UNDESTROYABLE, PHYSICS_MASK_UNDESTROYABLE, PHYSICS_GROUP_UNDESTROYABLE)
  self.fixture:setUserData({["name"] = "undestroyable", ["reference"] = self, ["world"] = realWorld})
end

function Undestroyable:update(dt)
  
end

function Undestroyable:draw()
  self.x,self.y = self.body:getPosition()
  love.graphics.setColor(128, 192, 64, 128)
  if self.form == 1 then
    love.graphics.circle("fill", self.x, self.y, self.size/2, 100)
  else
     love.graphics.rectangle("fill", self.x - self.size/2, self.y - self.size/2, self.size, self.size)
  end
  
  love.graphics.setColor(255, 255, 255, 255)
end
