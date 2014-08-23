class "Enemy" {
  
}

function Enemy:__init(x, y, gfx)
  self.x = x
  self.y = y
  self.gfx = gfx
end

function Enemy:update(dt)
  
end

function Enemy:draw()
  love.graphics.draw(self.gfx, self.x, self.y)
end
