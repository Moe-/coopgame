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
  towerRot = 0;
  udt = 0;
  vel = 12500;
  maxEnergy = 200;

  world = nil;

  isAccelerating = false;
  isBraking = false;
  isTurningLeft = false;
  isTurningRight = false;

  fraction = nil;
}

function Vehicle:__init(physWorld, x, y, damping, weight, pType, rotSpeed, realWorld, fraction)
  self.x = x
  self.y = y
  self.energy = self.maxEnergy
  -- physics:
  self.body = love.physics.newBody(physWorld, x, y, pType or "dynamic")
  self.body:setAngle(3*math.pi/2)
  self.damping = damping or 1.5
  self.weight = weight or 100
  self.rotSpeed = rotSpeed or 1.5
  self.shape = pShape or love.physics.newRectangleShape(0,0,50,100)
  self.fixture = pFixture or love.physics.newFixture(self.body, self.shape, self.weight)
  self.fixture:setUserData({["name"] = "vehicle", ["reference"] = self, ["world"] = realWorld})
  self.fixture:setFilterData(PHYSICS_CATEGORY_VEHICLE, PHYSICS_MASK_VEHICLE, PHYSICS_GROUP_VEHICLE)

  self.world = realWorld
  
  self:updatePhysicsProperties()
  -- !physics
  
  self.vehicle = love.graphics.newImage('gfx/player.png')
  self.tower = love.graphics.newImage('gfx/tower.png')
  -- NOTE: This is length of the tower from the rotation center
  -- when the tower image is changed, this value has to be adjusted
  self.towerLength = 128 - (64/2)

  self.fraction = fraction
end

function Vehicle:update(dt)
  self.udt = self.udt + dt
  if self.udt>0.01 then
    self.udt = 0
	  if self.isAccelerating then
      self.body:applyForce(-math.sin(self.rot)*self.vel,math.cos(self.rot)*self.vel)
      self.isAccelerating = false
	  end
	  if self.isBraking then
      self.body:applyForce(math.sin(self.rot)*self.vel,-math.cos(self.rot)*self.vel)
      self.isBraking = false
	  end
	  if self.isTurningLeft then
      self.body:applyForce(
      -3*self.rotSpeed*math.cos(self.rot),
      -3*self.rotSpeed*math.sin(self.rot),
      self.x-math.cos(self.rot)*10,
      self.y-math.sin(self.rot)*10)
      --print(self.rot)

      self.isTurningLeft = false
	  end
	  if self.isTurningRight then
      self.body:applyForce(
      3*self.rotSpeed*math.cos(self.rot),
      3*self.rotSpeed*math.sin(self.rot),
      self.x-2*math.cos(self.rot)*10,
      self.y-2*math.sin(self.rot)*10)
      --print(self.rot)

      self.isTurningRight = false
	  end
	  self.rot = self.body:getAngle()
	  self.x,self.y = self.body:getPosition()
	end
end

-- all the functions below are per-frame (have to be called every frame)
function Vehicle:accelerate()
	self.isAccelerating = true
end

function Vehicle:brake()
	self.isBraking = true
end

function Vehicle:turnLeft()
	self.isTurningLeft = true
end

function Vehicle:turnRight()
	self.isTurningRight = true
end


function Vehicle:setTowerRot(rot)
	self.towerRot = rot
end

function Vehicle:shoot()
	local cx, cy = self:getCannonPosition()
	self.world:addVehicleShot(cx, cy, self.towerRot - math.pi/2)
end

function Vehicle:updatePhysicsProperties()
  self.body:setLinearDamping(self.damping)
  self.body:setAngularDamping(2)
  self.fixture = love.physics.newFixture(self.body, self.shape, weight)
  self.body:setInertia(3)
end

function Vehicle:draw()
	love.graphics.push()
	love.graphics.translate(self.x, self.y)
  
  love.graphics.setColor(255, 0, 0, 192)
  love.graphics.rectangle("fill", -self.vehicle:getWidth()/2 + 25, -self.vehicle:getHeight()/2 - 50, 100, 30 )
  love.graphics.setColor(0, 255, 0, 192)
  love.graphics.rectangle("fill", -self.vehicle:getWidth()/2 + 25, -self.vehicle:getHeight()/2 - 50, 100 * math.max(0, self.energy/self.maxEnergy), 30 )

  love.graphics.setColor(255, 255, 255, 255)
  
	love.graphics.rotate(self.rot)
	love.graphics.translate(-self.vehicle:getWidth()/2, -self.vehicle:getHeight()/2)

	love.graphics.draw(self.vehicle, 0, 0)

	local flag = self.fraction:getFlag()
	love.graphics.draw(flag, self.vehicle:getWidth()/2 - flag:getWidth()/2, self.vehicle:getHeight()/2 - 75)

	love.graphics.draw(self.tower, self.vehicle:getWidth()/2, self.vehicle:getHeight()/2, self.towerRot -self.rot, 1, 1, self.tower:getWidth()/2, self.towerLength)
	
	love.graphics.pop()
end

function Vehicle:getCannonPosition()
  return self.towerLength * math.cos(self.towerRot - math.pi/2) + self.x, 
			self.towerLength * math.sin(self.towerRot - math.pi/2) + self.y
end

function Vehicle:getPosition()
  return self.body:getPosition()
end

function Vehicle:hit(damage)
  self.energy = self.energy - damage
end

function Vehicle:isDead()
  if self.energy <= 0 then
    return true
  end
  return false
end

function Vehicle:applyLinearImpulse(fx, fy)
  self.body:applyLinearImpulse(10000 * fx, 10000 * fy)
end
