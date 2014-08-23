class "PlayerCamera" {
	playervehicle = nil;
}

function PlayerCamera:__init(vehicle)
	self.playervehicle = vehicle
end

function PlayerCamera:setCamera()
	love.graphics.push()
	love.graphics.translate(self.playervehicle.x - self.playervehicle.vehicle:getWidth()/2 + love.window.getWidth()/2,
							self.playervehicle.y - self.playervehicle.vehicle:getHeight()/2 + love.window.getHeight()/2)
end

function PlayerCamera:unsetCamera()
	love.graphics.pop()
end