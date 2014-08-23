class "Undestroyable" {
  
}

function Undestroyable:__init(x, y, size, form)
  self.x = x
  self.y = y
  self.size = size
  self.form = form
end

function Undestroyable:update(dt)
  
end

function Undestroyable:draw()
  love.graphics.setColor(128, 192, 64, 128)
  if self.form == 1 then
    love.graphics.circle("fill", self.x + self.size/2, self.y + self.size/2, self.size/2, 100)
  else
     love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
  end
  love.graphics.setColor(255, 255, 255, 255)
end
