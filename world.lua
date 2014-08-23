require('physics')
class "World" {
	width = 10;
  height = 10;
  startPoint = {};
  targetPoint = {};
  undestroyables = {};
  destroyables = {};
  enemies = {};
  physWorld = nil;
}

function World:__init(width, height)
	self.width = width
  self.height = height
  
  self.backgroundImg = love.graphics.newImage('gfx/background.png')
  self.backgroundImg:setWrap('repeat', 'repeat')
  self.backgroundQuad = love.graphics.newQuad(0, 0, width, height, self.backgroundImg:getWidth(), self.backgroundImg:getHeight())
  
  self.enemyImg = love.graphics.newImage('gfx/enemy.png')
  
  self.physWorld = Physics:new()
  
  self:generateObjects(5, 10)
  self.player = Vehicle:new(self.physWorld.pWorld, 200, 200, 10, 10, nil)
  
  self.physWorld:addObject(self.player)
end

function World:generateObjects(countX, countY)
  local minSize = 5
  local secWidth = self.width/countX
  local secHeight = self.height/countY
  local maxSize = math.min(secWidth, secHeight)
  for y = 1, countY do
    for x = 1, countX do
      local size = math.random(5, maxSize)
      local xCoord = math.random((x - 1) * secWidth + size, x * secWidth - size)
      local yCoord = math.random((y - 1) * secHeight + size, y * secHeight - size)

      table.insert(self.undestroyables, Undestroyable:new(xCoord, yCoord, size, math.random(1, 2)))
      self:generateDestroyableObjects((x - 1) * secWidth, (y - 1) * secHeight, secWidth, (secHeight - size) / 2)
      self:generateDestroyableObjects((x - 1) * secWidth, y * secHeight - (secHeight - size) / 2, secWidth, (secHeight - size) / 2)
      
      self:generateDestroyableObjects((x - 1) * secWidth, y * secHeight - (secHeight - size) / 2, (secWidth - size) / 2, (secHeight - size) / 2)
      self:generateDestroyableObjects((x - 1) * secWidth, (y - 1) * secHeight + (secHeight - size) / 2, (secWidth - size) / 2, (secHeight - size) / 2)
    end
  end
end

function World:generateDestroyableObjects(posx, posy, width, height)
  local xSecs = math.random(1, 3)
  local ySecs = math.random(1, 3)
  local secWidth = width/xSecs
  local secHeight = height/ySecs
  local maxSize = math.min(secWidth, secHeight)
  for x = 1, xSecs do
    for y = 1, ySecs do
      local toInsert = math.random()
      if toInsert < 0.15 then
        local xCoord = math.random(posx + (x - 1) * secWidth, posx + x * secWidth)
        local yCoord = math.random(posy + (y - 1) * secHeight, posy + y * secHeight)
        table.insert(self.enemies, Enemy:new(xCoord, yCoord, self.enemyImg))
      elseif toInsert < 0.4 then
        local size = math.random(5, maxSize)
        local xCoord = math.random(posx + (x - 1) * secWidth + size, posx + x * secWidth - size)
        local yCoord = math.random(posy + (y - 1) * secHeight + size, posy + y * secHeight - size)

        table.insert(self.destroyables, Destroyable:new(xCoord, yCoord, size, math.random(1, 2)))
      end
    end
  end   
end

function World:update(dt)
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
end

function World:draw()
  love.graphics.draw(self.backgroundImg, self.backgroundQuad, 0, 0)
  
  for i, v in pairs(self.undestroyables) do
    v:draw()
  end
  
  for i, v in pairs(self.destroyables) do
    v:draw()
  end
  
  for i, v in pairs(self.enemies) do
    v:draw()
  end
  
  self.player:draw()
end
