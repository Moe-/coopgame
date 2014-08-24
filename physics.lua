require('defaultPhysicsObject')
class "Physics" {
  pWorld = nil;
  playerTank = nil;
  pObjects = {};
}

function Physics:__init()
  self.pWorld = love.physics.newWorld(0,0,true)
  love.physics.setMeter(64)
  
  self.pWorld:setCallbacks(beginContact, endContact, preSolve, postSolve)
end

function Physics:update(dt)
  self.pWorld:update(dt)
  --for i,v in pairs(self.pObjects) do
  --  v:update(dt)
  --end
end

function Physics:addObject(physObject)
  table.insert(self.pObjects, self.physObject)
end

function beginContact(a, b, coll)
  if a ~= nil and b ~= nil then
    local objA = a:getUserData()
    local objB = b:getUserData()
  
    if objA ~= nil and objB ~= nil and not (objA.name == "shot" and objB.name == "shot") then
      if objA.name == "shot" or objB.name == "shot" then
        local shot = nil
        local obj = nil
        if objA.name == "shot" then
          shot = objA
          obj = objB
        else
          shot = objB
          obj = objA
        end
        
        shot.world:removeShot(shot.reference)

        if shot.cat == "vehicle" then
          if obj.name == "destroyable" then
            obj.world:destroyDestroyable(obj.reference)
          elseif obj.name == "enemy" then
            obj.world:hitEnemy(obj.reference, shot.damage)
          end
        elseif shot.cat == "enemy" then
          if obj.name == "vehicle" then
            obj.world:hitVehicle(obj.reference, shot.damage)
          end
        end
      elseif (objA.name == "vehicle" and objB.name == "enemy") then
        objB.world:runOver(objA.reference, objB.reference)
      elseif (objB.name == "vehicle" and objA.name == "enemy") then
        objB.world:runOver(objB.reference, objA.reference)
      end
      
      if objA.name == "boundary" and objB.name == "vehicle" and coll:isTouching() then
        objB.world:collideWallVehicle(objA.reference, objB.reference, coll)
      elseif objB.name == "boundary" and objA.name == "vehicle" and coll:isTouching() then
        objB.world:collideWallVehicle(objB.reference, objA.reference, coll)
      end
    end
  end
end

function Physics:endContact(a, b, coll)
  --do nothing for now
end

function Physics:preSolve(a, b, coll)
  --do nothing for now
end

function Physics:postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
  --do nothing for now
end
