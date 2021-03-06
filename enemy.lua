class "Enemy" {
  movementForce = 2000;
  udt = 0; --update dt
  sdt = 0; --shot dt
  target = nil;
  pathfinding = 0;
  maxEnergy = 100;
  currentXdir = 0;
  currentYdir = 0;
}

function Enemy:__init(x, y, gfx, world, realWorld)
  self.x = x
  self.y = y
  self.gfx = gfx
  self.size = 32
  self.energy = self.maxEnergy
  self.realWorld = realWorld
  self.pathfinding = math.floor(math.random(0,1))
  
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
  if self.udt>0.4 then
    self:moveEnemy(self.udt-0.2)
	self.udt = self.udt - 0.2
  else
    self.udt = self.udt + dt
  end
  if self.sdt > 0.5 then
	local tX, tY = self.target.body:getPosition()
	if getDistance(self.x, self.y, tX, tY) < 550 then
	  local tSx = tX-self.x
	  local tSy = tY-self.y
	  self.realWorld:addEnemyShot(self.x, self.y, math.atan2(tSx, -tSy) - math.pi/2)
	end
	self.sdt = self.sdt - math.random(0.5,0.8)
  else
	self.sdt = self.sdt + dt
  end
end

function Enemy:moveEnemy(dt)
-- if no target exists, one should be assigned on the next update cycle
  if self.target then
    local tX, tY = self.target.body:getPosition()
	local tVx, tVy, vel = self:calcPath(self.x, self.y, tX, tY, self.shape)
	if tVx and tVy then
	  self.currentXdir, self.currentYdir = tVx, tVy
	end
	if not vel then
	  vel = 1
	end
	self.body:applyForce(self.currentXdir*self.movementForce*vel, self.currentYdir*self.movementForce*vel)
  end
end

-- this function must return a normalized vector that indicates the direction this object should move towards OR nil,nil to make the object move forward and after that the speed
function Enemy:calcPath(sX, sY, tX, tY, sh)
  if self.pathfinding == 0 then -- object will stupidly run straight towards the target and keep a distance of 200 to 450 units
    local rX = tX-sX
	local rY = tY-sY
	local dist = getDistance(sX, sY, tX, tY)
	if dist < 450 then
	  if dist < 200 then
	    local bRx, bRy = normalize(rX, rY)
	    return -bRx, -bRy, 3
	  else
	    return 0,0,0
	  end
	else
	  return normalize(rX, rY),1
	end
  elseif self.pathfinding == 1 then --same as above but with random movements every now and then
    local rX = tX-sX
	local rY = tY-sY
	local dist = getDistance(sX, sY, tX, tY)
	if dist < 400 then
	  if dist < 250 then
	    local bRx, bRy = normalize(rX, rY)
	    return -bRx, -bRy, 3
	  else
        return 0,0,0
	  end
	else
	  if math.random()< 0.85 then
	    return normalize(rX, rY),1
	  elseif math.random()<0.7 then
	    return normalize(math.random(-2,2)*rX, math.random(-2,2)*rY),4
	  else
	    return nil, nil,3
	  end
	end
  elseif self.pathfinding == 2 then
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
  gSound:playSound('enemy_death', 1, x, y, 0, true)
  self.body:destroy()
end
