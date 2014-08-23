class "Vehicle" {
  x = 0;
  y = 0;
  rotation = 0;
  body = nil;
  shape = nil;
  fixture = nil;
  damping = 1;
  weight = 1;
  rotSpeed = 1;
  rot = 0;
  udt = 0;
}

function Vehicle:__init(physWorld, x, y, damping, weight, pType, rotSpeed)
	self.x = x
  self.y = y
  -- physics:
  self.body = love.physics.newBody(physWorld, x, y, pType or "dynamic")
  self.damping = damping or 1
  self.weight = weight or 10
  self.rotSpeed = rotSpeed or 1
  self.shape = pShape or love.physics.newRectangleShape(0,0,50,100)
  self.fixture = pFixture or love.physics.newFixture(self.body, self.shape, self.weight)
  
  self:updatePhysicsProperties()
  -- !physics
  
  self.vehicle = love.graphics.newImage('gfx/player.png')
  self.tower = love.graphics.newImage('gfx/tower.png')
  
  self.offsetGunX = (self.vehicle:getWidth() - self.tower:getWidth()) / 2
  self.offsetGunY = (self.vehicle:getHeight() - self.tower:getHeight()) / 2
end

function Vehicle:update(dt)
  self.udt = self.udt + dt
  if self.udt>0.1 then
    self.udt = 0
	  if love.keyboard.isDown("w") then
		local vel = 10000
		self.body:applyForce(math.sin(self.rot)*vel,math.cos(self.rot)*vel)
	  end
	  if love.keyboard.isDown("a") then
		self.body:applyLinearImpulse(self.rotSpeed*1, 0, 10, 0)
		--self.body:applyTorque(self.rotSpeed*0.01)
		self.rot = self.body:getAngle()
		print(self.rot)
	  end
	  if love.keyboard.isDown("d") then
		self.body:applyLinearImpulse(-1*self.rotSpeed*1, 0, 10, 0)
		--self.body:applyTorque(-1*self.rotSpeed*0.01)
		self.rot = self.body:getAngle()
		print(self.rot)
	  end
	  
	  self.x,self.y = self.body:getPosition()
	  --print(self.x..","..self.y)
	end
end

function Vehicle:updatePhysicsProperties()
  if self.body then
    self.body:setLinearDamping(self.damping)
    self.fixture = love.physics.newFixture(self.body, self.shape, weight)
	self.body:setInertia(0.001)
  end
end

function Vehicle:draw()
  love.graphics.draw(self.vehicle, self.x, self.y, self.rot, 1, 1, self.vehicle:getWidth()/2, self.vehicle:getHeight()/2)
  
  local x, y = love.mouse.getPosition()
  local r = math.atan2(x -self.x, self.y - y)
  love.graphics.draw(self.tower, self.x - self.vehicle:getWidth()/2 + self.offsetGunX, self.y - self.vehicle:getHeight()/2 + self.offsetGunY, r, 1, 1, self.tower:getWidth() / 2, self.tower:getHeight() / 2)
end