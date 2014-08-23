require('defaultPhysicsObject')
class "Physics" {
  pWorld = nil;
  playerTank = nil;
  pObjects = {};
}

function Physics:__init()
  self.pWorld = love.physics.newWorld(0,0,true)
  love.physics.setMeter(64)
end

function Physics:update(dt)
  self.pWorld:update(dt)
  for i,v in pairs(self.pObjects) do
    v:update(dt)
  end
end

function Physics:addObject(physObject)
  table.insert(self.pObjects, self.physObject)
end
