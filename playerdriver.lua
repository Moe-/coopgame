class "PlayerDriver" {
	vehicle = nil;

	timetonextshot = 0;
}

function PlayerDriver:__init(vehicle)
	self.vehicle = vehicle
end

function PlayerDriver:update(dt)
	if love.keyboard.isDown("w") then
		self.vehicle:accelerate()
	end
	if love.keyboard.isDown("s") then
		self.vehicle:brake()
	end
	
	if love.keyboard.isDown("a") then
		self.vehicle:turnLeft()
	end
	if love.keyboard.isDown("d") then
		self.vehicle:turnRight()
	end

	-- TOOD: the camera position is hard coded here so the function
	-- would stop working when the camera position of the player isn't the
	-- exact center of the screen
	local x, y = love.mouse.getPosition()
	local r = math.atan2(x - love.window.getWidth()/2, love.window.getHeight()/2 - y)
	
	self.vehicle:setTowerRot(r)

	if love.mouse.isDown("l") and self.timetonextshot <= 0 then
		self.timetonextshot = 0.5
    
		self.vehicle:shoot()
	end
	
	self.timetonextshot = self.timetonextshot - dt
end
