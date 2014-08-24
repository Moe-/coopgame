require('playercamera')
require('physics')
require('playerdriver')
require('fraction')

class "World" {
  width = 10;
  height = 10;

  startPoint = {};
  targetPoint = {};

  undestroyables = {};
  destroyables = {};
  enemies = {};

  shots = {};

  fractions = {};

  physWorld = nil;

  nextMouseEvent = 0;
}

function World:__init(width, height)
	self.width = width
  self.height = height
  
  self.backgroundImg = love.graphics.newImage('gfx/background.png')
  self.backgroundImg:setWrap('repeat', 'repeat')
  self.backgroundQuad = love.graphics.newQuad(0, 0, width, height, self.backgroundImg:getWidth(), self.backgroundImg:getHeight())
  
  self.enemyImg = love.graphics.newImage('gfx/enemy.png')
  
  self.physWorld = Physics:new()
  
-- TODO: Fix level boundaries
--  self.body = love.physics.newBody(self.physWorld.pWorld, 0, 0, 'static')
--  local shape = love.physics.newEdgeShape( 0, 0, width, 0)
--  local fixture = love.physics.newFixture(self.body, shape, 15)
--  fixture:setUserData({["name"] = "boundary", ["reference"] = self, ["world"] = self})
--  
--  shape = love.physics.newEdgeShape(width, 0, width, height)
--  fixture = love.physics.newFixture(self.body, shape, 15)
--  fixture:setUserData({["name"] = "boundary", ["reference"] = self, ["world"] = self})

--  shape = love.physics.newEdgeShape( 0, 0, 0, height)
--  fixture = love.physics.newFixture(self.body, shape, 15)
--  fixture:setUserData({["name"] = "boundary", ["reference"] = self, ["world"] = self})
--  
--  shape = love.physics.newEdgeShape( 0, height, width, height)
--  fixture = love.physics.newFixture(self.body, shape, 15)
--  fixture:setUserData({["name"] = "boundary", ["reference"] = self, ["world"] = self})
  
  self:generateObjects(5, 5)

  self.fractions["green"] = Fraction:new(love.graphics.newImage("gfx/green_fraction.png"))
  self.fractions["red"] = Fraction:new(love.graphics.newImage("gfx/red_fraction.png"))

  print(self.fractions["red"]:getFlag())

  self.player = Vehicle:new(self.physWorld.pWorld, startPoint[1], startPoint[2], 10, 10, nil, nil, self, self.fractions["green"])
  
  self.physWorld:addObject(self.player)

  self.camera = PlayerCamera:new(self.player)

  self.playerdriver = PlayerDriver:new(self.player)
end

function World:generateObjects(countX, countY)
  startPoint = {0.05 * math.random() * self.width, math.random() * self.height}
  targetPoint = {(1.0 - 0.05 * math.random()) * self.width, math.random() * self.height}
  
  local minSize = 5
  local secWidth = self.width/countX
  local secHeight = self.height/countY
  local maxSize = math.min(secWidth, secHeight)
  for y = 1, countY do
    for x = 1, countX do
      local size = math.random(5, maxSize)
      local xCoord = math.random((x - 1) * secWidth + size, x * secWidth - size)
      local yCoord = math.random((y - 1) * secHeight + size, y * secHeight - size)

      table.insert(self.undestroyables, Undestroyable:new(xCoord, yCoord, size, math.random(1, 2), self.physWorld.pWorld, self))
      self:generateDestroyableObjects((x - 1) * secWidth, (y - 1) * secHeight, secWidth, (secHeight - size) / 2)
      self:generateDestroyableObjects((x - 1) * secWidth, y * secHeight - (secHeight - size) / 2, secWidth, (secHeight - size) / 2)
      
      self:generateDestroyableObjects((x - 1) * secWidth, (y - 1) * secHeight + (secHeight - size) / 2, (secWidth - size) / 2, size)
      self:generateDestroyableObjects(x * secWidth - (secWidth - size) / 2, (y - 1) * secHeight + (secHeight - size) / 2, (secWidth - size) / 2, size)
    end
  end
end

function World:generateDestroyableObjects(posx, posy, width, height)
  local xSecs = math.random(1, 3)
  local ySecs = math.random(1, 3)
  local secWidth = width/xSecs
  local secHeight = height/ySecs
  local maxSize = math.min(secWidth, secHeight) / 2
  for x = 1, xSecs do
    for y = 1, ySecs do
      local toInsert = math.random()
      if toInsert < 0.15 then
        local xCoord = math.random(posx + (x - 1) * secWidth, posx + x * secWidth)
        local yCoord = math.random(posy + (y - 1) * secHeight, posy + y * secHeight)
        table.insert(self.enemies, Enemy:new(xCoord, yCoord, self.enemyImg, self.physWorld.pWorld, self))
      elseif toInsert < 0.4 then
        local size = math.random(5, maxSize)
        local xCoord = math.random(posx + (x - 1) * secWidth + size, posx + x * secWidth - size)
        local yCoord = math.random(posy + (y - 1) * secHeight + size, posy + y * secHeight - size)

        table.insert(self.destroyables, Destroyable:new(xCoord, yCoord, size, math.random(1, 2), self.physWorld.pWorld, self))
      end
    end
  end   
end

function World:update(dt)
  self.playerdriver:update(dt)

  self.player:update(dt)
  self.physWorld:update(dt)
  for i, v in pairs(self.undestroyables) do
    v:update(dt)
  end
  
  for i, v in pairs(self.destroyables) do
    v:update(dt)
  end
  
  for i, v in pairs(self.enemies) do
    v:update(dt)
	if not v:hasTarget() then
	  v:assignTarget(self.player)
	  print("assigning target")
	end
  end
  
  self:updateShots()
  
  if love.mouse.isDown("l") and self.nextMouseEvent <= 0 then
    self.nextMouseEvent = 0.02
    local mousex, mousey = love.mouse.getPosition()
    local posx, posy = self.player:getCannonPosition()
    local dx = mousex - (-self.player.x + love.window.getWidth()/2) - posx
    local dy = mousey - (-self.player.y + love.window.getHeight()/2) - posy
    --local length = math.sqrt(dx*dx, dy*dy)
    --table.insert(self.shots, {posx, posy, dx/length, dy/length})
    local body = love.physics.newBody( self.physWorld.pWorld, posx, posy, 'dynamic')
    table.insert(self.shots, body)
    body:setBullet(true)
    body:setLinearDamping(0)
	  local dx1, dy1 = normalize(dx,dy)
    body:setLinearVelocity(70 * dx1, 70 * dy1)
    
    local shape = love.physics.newCircleShape(2)
    local fixture = love.physics.newFixture(body, shape, 50)
    fixture:setFilterData(PHYSICS_CATEGORY_SHOT, PHYSICS_MASK_SHOT, PHYSICS_GROUP_SHOT)
    fixture:setUserData({["name"] = "shot", ["reference"] = body, ["world"] = self})
  end

  self.nextMouseEvent = self.nextMouseEvent - dt
end

function World:draw()
  self.camera:setCamera()

  love.graphics.draw(self.backgroundImg, self.backgroundQuad, 0, 0)
  love.graphics.rectangle("fill", targetPoint[1] - 10, targetPoint[2] - 50, 20, 100)
  
  for i, v in pairs(self.undestroyables) do
    v:draw()
  end
  
  for i, v in pairs(self.destroyables) do
    v:draw()
  end
  
  for i, v in pairs(self.enemies) do
    v:draw()
  end
  
  for i,v in pairs(self.shots) do
    local x, y = v:getPosition()
    local dx, dy = v:getLinearVelocity()
    love.graphics.line(x, y, x + 0.25 * dx, y + 0.25 * dy)
  end
  
  self.player:draw()

  self.camera:unsetCamera()
end

function World:removeShot(shot)
  removeFromList(self.shots, shot)
  --for i, v in pairs(self.shots) do
--    if v == shot then
--      self.shots[i] = nil
--      break
--    end
--  end
  shot:destroy()
end

function World:updateShots()
  for i, v in pairs(self.shots) do
    local x, y = v:getPosition()
    if x < 0 or x > self.width or y < 0 or y > self.height then
      self.shots[i] = nil
      v:destroy()
    end
  end
end

function World:destroyDestroyable(destroyable)
  destroyable:destroy()
  removeFromList(self.destroyables, destroyable)
end

function World:hitEnemy(enemy)
  local dead = enemy:hit()
  if dead then
    enemy:destroy()
    removeFromList(self.enemies, enemy)
  end
end

function World:runOver(vehicle, enemy)
  enemy:kill()
  enemy:destroy()
  removeFromList(self.enemies, enemy)
end

function World:addEnemyShot(enemy, tx, ty)
  local body = love.physics.newBody( self.physWorld.pWorld, enemy.x, enemy.y, 'dynamic')
  table.insert(self.shots, body)
  body:setBullet(true)
  body:setLinearDamping(0)
  local dx1, dy1 = normalize(tx,ty)
  body:setLinearVelocity(70 * dx1, 70 * dy1)
  
  local shape = love.physics.newCircleShape(2)
  local fixture = love.physics.newFixture(body, shape, 50)
  fixture:setFilterData(PHYSICS_CATEGORY_SHOT_ENEMY, PHYSICS_MASK_SHOT_ENEMY, PHYSICS_GROUP_SHOT_ENEMY)
  fixture:setUserData({["name"] = "shot", ["reference"] = body, ["world"] = self})
end
