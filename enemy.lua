class "Enemy" {
  
}

function Enemy:__init(x, y, gfx, world)
  self.x = x
  self.y = y
  self.gfx = gfx
  self.size = 32
  
  self.body = love.physics.newBody(world, x, y, 'dynamic')
  self.shape = love.physics.newRectangleShape(self.size, self.size)
  --self.shape = love.physics.newCircleShape(self.size)
  self.fixture = love.physics.newFixture(self.body, self.shape, 15)
end

function Enemy:update(dt)
  self.x,self.y = self.body:getPosition()
end

function Enemy:draw()
  self.x,self.y = self.body:getPosition()
  self.width, self.height = self.gfx:getDimensions()
  love.graphics.draw(self.gfx, self.x - self.width/2, self.y - self.height/2)
  
  love.graphics.setColor(255, 255, 255, 255)
end
