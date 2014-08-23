class "Enemy" {
  
}

function Enemy:__init(x, y, gfx, world)
  self.x = x
  self.y = y
  self.gfx = gfx
  
  self.body = love.physics.newBody(world, x, y, 'dynamic')
  self.shape = love.physics.newRectangleShape(x, y, 32, 32)
  self.fixture = love.physics.newFixture(self.body, self.shape, 15)
end

function Enemy:update(dt)
  self.x,self.y = self.body:getPosition()
end

function Enemy:draw()
  love.graphics.draw(self.gfx, self.x, self.y)
end
