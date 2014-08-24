require('playercamera')
require('physics')
require('playerdriver')

class "World" {
	width = 10;
  height = 10;
  startPoint = {};
  targetPoint = {};
  undestroyables = {};
  destroyables = {};
  enemies = {};
  shots = {};
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
  
  self:generateObjects(1, 2)

  self.player = Vehicle:new(self.physWorld.pWorld, startPoint[1], startPoint[2], 10, 10, nil)
  
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

      table.insert(self.undestroyables, Undestroyable:new(xCoord, yCoord, size, math.random(1, 2), self.physWorld.pWorld))
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
        table.insert(self.enemies, Enemy:new(xCoord, yCoord, self.enemyImg, self.physWorld.pWorld))
      elseif toInsert < 0.4 then
        local size = math.random(5, maxSize)
        local xCoord = math.random(posx + (x - 1) * secWidth + size, posx + x * secWidth - size)
        local yCoord = math.random(posy + (y - 1) * secHeight + size, posy + y * secHeight - size)

        table.insert(self.destroyables, Destroyable:new(xCoord, yCoord, size, math.random(1, 2), self.physWorld.pWorld))
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
  end
  
--  for i,v in pairs(self.shots) do
--    v[1] = v[1] + 20 * dt * v[3]
--    v[2] = v[2] + 20 * dt * v[4]
--    if v[1] < 0 or v[1] > self.width or v[2] < 0 or v[2] > self.height then
--      self.shots[i] = nil
--    end
--  end
  
  if love.mouse.isDown("l") and self.nextMouseEvent <= 0 then
    self.nextMouseEvent = 0.02
    local mousex, mousey = love.mouse.getPosition()
    local posx, posy = self.player:getCanonPosition()
    local dx = mousex - (-self.player.x + love.window.getWidth()/2) - posx
    local dy = mousey - (-self.player.y + love.window.getHeight()/2) - posy
    local length = math.sqrt(dx*dx, dy*dy)
    --table.insert(self.shots, {posx, posy, dx/length, dy/length})
    local body = love.physics.newBody( self.physWorld.pWorld, posx, posy, 'dynamic')
    table.insert(self.shots, body)
    body:setBullet(true)
    body:setLinearDamping(0)
    body:setLinearVelocity(50 * dx/length, 50 * dy/length)
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
    love.graphics.line(x, y, x + 5 * dx, y + 5 * dy)
  end
  
  self.player:draw()

  self.camera:unsetCamera()
end
