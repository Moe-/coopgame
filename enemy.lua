class "Enemy" {
  movementForce = 1000;
  udt = 0;
  target = nil;
  pathfinding = 0;
  maxEnergy = 100;
}

function Enemy:__init(x, y, gfx, world, realWorld)
  self.x = x
  self.y = y
  self.gfx = gfx
  self.size = 32
  self.energy = self.maxEnergy
  self.realWorld = realWorld
  
  self.body = love.physics.newBody(world, x, y, 'dynamic')
  self.shape = love.physics.newRectangleShape(self.size, self.size)
  --self.shape = love.physics.newCircleShape(self.size)
  self.fixture = love.physics.newFixture(self.body, self.shape, 15)
  self.fixture:setUserData({["name"] = "enemy", ["reference"] = self, ["world"] = realWorld})
  self.fixture:setFilterData(PHYSICS_CATEGORY_ENEMY, PHYSICS_MASK_ENEMY, PHYSICS_GROUP_ENEMY)
  self.body:setLinearDamping(2)
  self.body:setAngularDamping(1)
end

function Enemy:update(dt)
  self.x,self.y = self.body:getPosition()
  if self.udt>0.1 then
    self:moveEnemy(self.udt-0.1)
	self.udt = self.udt - 0.1
  else
    self.udt = self.udt+dt
  end
end

function Enemy:moveEnemy(dt)
-- if no target exists, one should be assigned on the next update cycle
  if self.target then
    local tX, tY = self.target.body:getPosition()
	local tVx, tVy = self:calcPath(self.x, self.y, tX, tY, self.shape)
	self.body:applyForce(tVx*self.movementForce, tVy*self.movementForce)
	if getDistance(self.x, self.y, tX, tY) < 550 then
	  local tSx = tX-self.x
	  local tSy = tY-self.y
	  self.realWorld:addEnemyShot(self.x, self.y, math.atan2(tSx, -tSy) - math.pi/2)
	end
  end
end

-- this function must return a normalized vector that indicates the direction this object should move towards
function Enemy:calcPath(sX, sY, tX, tY, sh)
  if self.pathfinding == 0 then -- object will stupidly run straight towards the target and keep a distance of 150 to 350 units
    local rX = tX-sX
	local rY = tY-sY
	local dist = getDistance(sX,sY,tX,tY)
	if dist < 450 then
	  if dist < 200 then
	    return normalize(-rX, -rY)
	  else
	    return 0,0
	  end
	else
	  return normalize(rX, rY)
	end
  elseif self.pathfinding == 1 then
    -- TODO: implement better pathfinding algroithm(s) here
  end
end

function Enemy:hasTarget()
  return self.target
end

function Enemy:assignTarget(t)
  self.target = t
end

function Enemy:draw()
  self.x,self.y = self.body:getPosition()
  self.width, self.height = self.gfx:getDimensions()
  love.graphics.draw(self.gfx, self.x - self.width/2, self.y - self.height/2)
  
  love.graphics.setColor(255, 0, 0, 192)
  love.graphics.rectangle("fill", self.x - self.width/2 + 35, self.y - self.height/2 - 10, 50, 15)
  love.graphics.setColor(0, 255, 0, 192)
  love.graphics.rectangle("fill", self.x - self.width/2 + 35, self.y - self.height/2 - 10, 50 * math.max(0, self.energy/self.maxEnergy), 15)
  
  love.graphics.setColor(255, 255, 255, 255)
end

function Enemy:hit(damage)
  self.energy = self.energy - damage
  if self.energy <= 0 then
    return true
  end
  return false
end

function Enemy:kill()
  self.energy = 0
end

function Enemy:destroy()
  self.body:destroy()
end
