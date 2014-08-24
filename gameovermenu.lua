require('mainmenu')

class "GameoverMenu" {
	world = nil;
	t = 0;
	won = false;
}

function GameoverMenu:__init(world, won)
	self.world = world
	self.won = won

	self.t = 3

	self.restartbutton = MMButton:new("Neustarten", gFont, 0, 0)
	function self.restartbutton:onClick()
		gScreen = createWorld()
	end

	self.mainmenubutton = MMButton:new("Hauptmenu", gFont, 0, 0)
	function self.mainmenubutton:onClick()
		self.world = nil
		createMainMenu()
	end

end

function GameoverMenu:update(dt)
	local speed = 1
	if self.t <= 1 then
		self.restartbutton:update(dt)
		self.mainmenubutton:update(dt)
	end

	if self.t > 0 then
		self.t = self.t - (dt * speed)
	end

	if self.t < 0 then self.t = 0 end
end

function GameoverMenu:draw()
	if self.t > 1 then return end
	
	local alpha = 255 * lerp(1, 0, self.t)

	local text = ""

	if self.won == true then
		love.graphics.setColor(20, 255, 20, alpha)
		
		text = "Gewonnen!"
	else
		love.graphics.setColor(255, 20, 20, alpha)
		
		text = "Verloren!"
	end
	
	local textwidth = gFont:getWidth(text)
	local textheight = gFont:getHeight(text)
	
	love.graphics.print(text, love.window.getWidth()/2, love.window.getHeight()/2 - 250, 0, 2, 2, textwidth/2, textheight/2)

	love.graphics.setColor(255, 255, 255, alpha)
	
	local halfheight = love.window.getHeight()/2
	local halfwidth = love.window.getWidth()/2

	local padding = 10
	local fontheight = gFont:getHeight()

	self.restartbutton.x = halfwidth
	self.restartbutton.y = halfheight

	self.mainmenubutton.x = halfwidth
	self.mainmenubutton.y = halfheight + fontheight + padding

	self.restartbutton:draw()
	self.mainmenubutton:draw()

	love.graphics.setColor(255, 255, 255, 255)
end