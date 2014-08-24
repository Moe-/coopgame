class "Countdown" {
	world = nil;

	currentnumber = 0;
	t = 0;
}

function Countdown:__init(world, startnumber)
	self.world = world

	self.currentnumber = startnumber
	self.t = 1
end

function Countdown:update(dt)
	local speed = 1

	if self.t > -0.2 then
		self.t = self.t - (dt*speed)
	else
		self.currentnumber = self.currentnumber - 1
		self.t = 1
		
		if self.currentnumber < 0 then
			self.world.gamerunning = true
			self.world.overlay = nil
			
			return
		end
	end
end

function Countdown:draw()
	local str = tostring(self.currentnumber)

	local width = gFont:getWidth(str)
	local height = gFont:getHeight(str)

	local newt = self.t
	if newt < 0 then
		newt = 0
	end

	local scale = lerp(2, 6, newt)
	local alpha = 255 * lerp(1, 0, newt)
	
	love.graphics.setColor(0, 0, 0, alpha)
	love.graphics.print(str, love.window.getWidth()/2 + 10, love.window.getHeight()/2 + 10, 0, scale*1.1, scale*1.1, width/2, height/2)

	love.graphics.setColor(255, 255, 255, alpha)
	love.graphics.print(str, love.window.getWidth()/2, love.window.getHeight()/2, 0, scale, scale, width/2, height/2)

	love.graphics.setColor(255, 255, 255, 255)
end