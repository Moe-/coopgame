class "DefaultPhysicsObject" {
  body = nil;
  shape = nil;
  fixture = nil;
  posX = 0;
  posY = 0;
}

function DefaultPhysicsObject:__init(physWorld, posX, posY, damping, weight, pType, torqueSpeed, pFixture, pShape)
  self.body = love.physics.newBody(physWorld, posX, posY, pType)
  self.posX = posX
  self.posY = posY
  self.damping = damping
  self.weight = weight
  self.torqueSpeed = torqueSpeed
  self.shape = pShape or love.physics.newRectangleShape(0,0,50,100)
  self.fixture = pFixture or love.physics.newFixture(self.body, self.shape, self.weight)
  
  self:updatePhysicsProperties()
end

function DefaultPhysicsObject:rotate(rVal)
  self.body:applyTorque(rVal)
end

function DefaultPhysicsObject:accelerate(accVal)
  --self.body:applyForce(accVal,0) --TODO: change this so the force is always applied forward
end

function DefaultPhysicsObject:updatePhysicsProperties()
  self.body:setLinearDamping(self.damping)
  self.fixture = love.physics.newFixture(self.body, self.shape, weight)
end

function DefaultPhysicsObject:getPosition()
  if false then
    return self.body:getPosition()
  end
end
