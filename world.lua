require('playercamera')
require('physics')
require('playerdriver')
require('fraction')
require('sound')

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
  gameWon = false;
  shaderTime = 0;
  shaderDir = 1;

  gSound = Sound:new()
}

function World:__init(width, height)
	self.width = width
  self.height = height
  
  self.bulletSpeed = 400
  self.backgroundImg = love.graphics.newImage('gfx/background.png')
  self.backgroundImg:setWrap('repeat', 'repeat')
  self.backgroundQuad = love.graphics.newQuad(0, 0, width, height, self.backgroundImg:getWidth(), self.backgroundImg:getHeight())
  
  self.enemyImg = love.graphics.newImage('gfx/enemy.png')

  self.bulletImg = love.graphics.newImage("gfx/bullet.png")
  
  self.physWorld = Physics:new()
  
-- TODO: Fix level boundaries
  self.body = love.physics.newBody(self.physWorld.pWorld, 0, 0, 'static')
  local shape = love.physics.newEdgeShape( 0, 0, width, 0)
  local fixture = love.physics.newFixture(self.body, shape, 15)
  fixture:setUserData({["name"] = "boundary", ["reference"] = self, ["world"] = self})
  fixture:setFilterData(PHYSICS_CATEGORY_BONDARY, PHYSICS_MASK_BONDARY, PHYSICS_GROUP_BONDARY)
  
  shape = love.physics.newEdgeShape(width, 0, width, height)
  fixture = love.physics.newFixture(self.body, shape, 15)
  fixture:setUserData({["name"] = "boundary", ["reference"] = self, ["world"] = self})
  fixture:setFilterData(PHYSICS_CATEGORY_BONDARY, PHYSICS_MASK_BONDARY, PHYSICS_GROUP_BONDARY)

  shape = love.physics.newEdgeShape( 0, 0, 0, height)
  fixture = love.physics.newFixture(self.body, shape, 15)
  fixture:setUserData({["name"] = "boundary", ["reference"] = self, ["world"] = self})
  fixture:setFilterData(PHYSICS_CATEGORY_BONDARY, PHYSICS_MASK_BONDARY, PHYSICS_GROUP_BONDARY)
  
  shape = love.physics.newEdgeShape( 0, height, width, height)
  fixture = love.physics.newFixture(self.body, shape, 15)
  fixture:setUserData({["name"] = "boundary", ["reference"] = self, ["world"] = self})
  fixture:setFilterData(PHYSICS_CATEGORY_BONDARY, PHYSICS_MASK_BONDARY, PHYSICS_GROUP_BONDARY)
  
  self:generateObjects(3, 2)

  self.fractions["green"] = Fraction:new(love.graphics.newImage("gfx/green_fraction.png"))
  self.fractions["red"] = Fraction:new(love.graphics.newImage("gfx/red_fraction.png"))

  print(self.fractions["red"]:getFlag())

  self.player = Vehicle:new(self.physWorld.pWorld, self.startPoint[1], self.startPoint[2], 10, 10, nil, nil, self, self.fractions["green"])
  
  self.physWorld:addObject(self.player)

  self.camera = PlayerCamera:new(self.player)

  self.playerdriver = PlayerDriver:new(self.player)
  
  self:createShaders()
end

function World:generateObjects(countX, countY)
  self.startPoint = {50 + 0.05 * math.random() * self.width, 50 + 0.9 * math.random() * self.height}
  self.targetPoint = {(1.0 - 0.05 * math.random()) * self.width, math.random() * self.height}
  
  local minSize = 5
  local secWidth = self.width/countX
  local secHeight = self.height/countY
  local maxSize = math.min(secWidth, secHeight)
  for y = 1, countY do
    for x = 1, countX do
      local size = math.random(15, maxSize)
      local xCoord = math.random((x - 1) * secWidth + size, x * secWidth - size)
      local yCoord = math.random((y - 1) * secHeight + size, y * secHeight - size)

      if getDistance(xCoord, yCoord, self.targetPoint[1], self.targetPoint[2]) > 2 * size then
        table.insert(self.undestroyables, Undestroyable:new(xCoord, yCoord, size, math.random(1, 2), self.physWorld.pWorld, self))
      end
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
  local maxSize = math.max(15, math.min(secWidth, secHeight) / 2)
  for x = 1, xSecs do
    for y = 1, ySecs do
      local toInsert = math.random()
      if toInsert < 0.15 then
        local xCoord = math.random(posx + (x - 1) * secWidth, posx + x * secWidth)
        local yCoord = math.random(posy + (y - 1) * secHeight, posy + y * secHeight)
        table.insert(self.enemies, Enemy:new(xCoord, yCoord, self.enemyImg, self.physWorld.pWorld, self))
      elseif toInsert < 0.4 then
        local size = math.random(15, maxSize)
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
  
  local pposx, pposy = self.player:getPosition()
  if not self.player:isDead() and getDistance(pposx, pposy, self.targetPoint[1], self.targetPoint[2]) < 20 then
    self.gameWon = true
  end
  
  self.shaderTime = self.shaderTime + 0.0005 * self.shaderDir * dt
  if self.shaderTime < 0 then
    self.shaderTime = 0
    self.shaderDir = 1
  elseif self.shaderTime > 1 then
    self.shaderTime = 1
    self.shaderDir = -1
  end
end

function World:draw()
  self.camera:setCamera()

  love.graphics.draw(self.backgroundImg, self.backgroundQuad, 0, 0)
  love.graphics.rectangle("fill", self.targetPoint[1] - 10, self.targetPoint[2] - 50, 20, 100)
  
  love.graphics.setShader(self.shaderUndestroyable)
  for i, v in pairs(self.undestroyables) do
    v:draw()
  end
  
  love.graphics.setShader(self.shaderDestroyable)
  self.shaderDestroyable:send("time", self.shaderTime)
  for i, v in pairs(self.destroyables) do
    v:draw()
  end
  love.graphics.setShader()
  
  for i, v in pairs(self.enemies) do
    v:draw()
  end
  
  for i,v in pairs(self.shots) do
    local x, y = v:getPosition()
    local dx, dy = v:getLinearVelocity()
	local r = math.atan2(dx, -dy)
	
	love.graphics.draw(self.bulletImg, x, y, r - math.pi/2, 1, 1, self.bulletImg:getWidth(), self.bulletImg:getHeight()/2)
  end
  
  self.player:draw()

  self.camera:unsetCamera()
  
  if self.gameWon then
    love.graphics.print("Amazing, a winner!", 10, 250, 0, 2, 2)
  elseif self.player:isDead() then
    love.graphics.print("Ah, what a looser...", 10, 250, 0, 2, 2)
  end
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

function World:hitEnemy(enemy, damage)
  local dead = enemy:hit(damage)
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

function World:addEnemyShot(x, y, rot)
  local body = self:createShotBody(x, y, rot)
  
  local shape = love.physics.newCircleShape(2)
  local fixture = love.physics.newFixture(body, shape, 50)
  fixture:setFilterData(PHYSICS_CATEGORY_SHOT_ENEMY, PHYSICS_MASK_SHOT_ENEMY, PHYSICS_GROUP_SHOT_ENEMY)
  fixture:setUserData({["name"] = "shot", ["damage"] = 50, ["reference"] = body, ["world"] = self, ["cat"] = "enemy"})
end

function World:addVehicleShot(x, y, rot)
  local body = self:createShotBody(x, y, rot)
  
  local shape = love.physics.newCircleShape(2)
  local fixture = love.physics.newFixture(body, shape, 50)
  fixture:setFilterData(PHYSICS_CATEGORY_SHOT, PHYSICS_MASK_SHOT, PHYSICS_GROUP_SHOT)
  fixture:setUserData({["name"] = "shot", ["damage"] = 50, ["reference"] = body, ["world"] = self, ["cat"] = "vehicle"})
end

function World:createShotBody(x, y, rot)
	local body = love.physics.newBody(self.physWorld.pWorld, x, y, 'dynamic')
	table.insert(self.shots, body)
	body:setBullet(true)
	body:setLinearDamping(0)

	local dx1 = math.cos(rot) * self.bulletSpeed
	local dy1 = math.sin(rot) * self.bulletSpeed
	body:setLinearVelocity(dx1, dy1)
  
	return body
end

function World:hitVehicle(vehicle)
  vehicle:hit()
end

function World:collideWallVehicle(wall, vehicle, coll)
  vehicle:applyLinearImpulse(coll:getNormal())
end

function World:createShaders()
  local pixelcodeDestroyable = [[
    varying vec4 colour;
    extern number time;
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
    {
      vec4 texcolor = vec4(0.5 + 0.5 * cos(1.0 - time * (sqrt(colour.yxy * colour.yxy))), 1.0);
      return vec4((texcolor.grba * color).rgb, 1.0);
    }
  ]]

  local vertexcodeDestroyable = [[
    varying vec4 colour;
    vec4 position(mat4 transform_projection, vec4 vertex_position)
    {
      vec4 res = transform_projection * vertex_position;
      colour = vertex_position;
      return res;
    }
  ]]

  self.shaderDestroyable = love.graphics.newShader(pixelcodeDestroyable, vertexcodeDestroyable)
  
  local pixelcodeUndestroyable = [[
    varying vec4 colour;
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
    {
      vec4 texcolor = vec4(0.5 + 0.5 * sin(1.0 - (sqrt(colour.xyx * colour.xyx))), 1.0);
      return vec4((texcolor * color).rgb, 1.0);
    }
  ]]

  local vertexcodeUndestroyable = [[
    varying vec4 colour;
    vec4 position(mat4 transform_projection, vec4 vertex_position)
    {
      vec4 res = transform_projection * vertex_position;
      colour = res;
      return res;
    }
  ]]

  self.shaderUndestroyable = love.graphics.newShader(pixelcodeUndestroyable, vertexcodeUndestroyable)
end
