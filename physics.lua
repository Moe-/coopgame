require('DefaultPhysicsObject')
class "Physics" {
  pWorld = nil;
  playerTank = nil;
  pObjects = {};
}

function Physics:__init()
  self.pWorld = love.physics.newWorld(0,0,true)
  love.physics.setMeter(64)
  --self.playerTank = DefaultPhysicsObject:new(self.pWorld, 100, 100, 5, 2, "dynamic", 10)
  --self.pObjects.playerTank = self.playerTank
  --table.insert(self.pObjects, self.playerTank)
  --self:addObject(self.playerTank)
end

function Physics:update(dt)
  self.pWorld:update(dt)
  for i,v in pairs(self.pObjects) do
    v:update(dt)
  end
  --controls
  --[[if love.keyboard.isDown("w") then
  --self.playerTank.accelerate(10)
    print(#self.pObjects)
    for i,v in pairs(self.pObjects) do
	  v.body:applyForce(200,0)
	  v:update(dt)
	  print("updated")
	end
  end
  
  if love.keyboard.isDown("a") then
  
  end
  
  if love.keyboard.isDown("d") then
  
  end
  --]]
  --local _x,_y = self.pObjects[0].body:getPosition()
  --print(_x..",".._y)
end

function Physics:addObject(physObject)
  table.insert(self.pObjects, self.physObject)
  --pObjects[#pObjects+1] = physObject
end
