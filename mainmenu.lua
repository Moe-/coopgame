require('sound')

class "MMButton" {
	text = "";

	x = 0;
	y = 0;

	t = 0;

	wasmousedown = false;

	font = nil;
}

function MMButton:__init(text, font, x, y)
	self.text = text

	self.x = x
	self.y = y
	
	self.font = font
end

function MMButton:draw()
	local recheight = self.font:getHeight()
	local recwidth = recheight/4

	local shift = lerp(0, 100, self.t)

	love.graphics.rectangle("fill", self.x - recwidth - 20 - shift, self.y, recwidth, recheight)

	love.graphics.setFont(self.font)
	love.graphics.print(self.text, self.x, self.y)
end

function MMButton:update(dt)
	local speed = 10.0

	local mousey = love.mouse.getY()
	if mousey >= self.y and
		mousey <= self.y+self.font:getHeight() then
		if self.t < 1 then
			self.t = self.t + speed*dt
		end

		if love.mouse.isDown("l") and
			self.wasmousedown == false then
			self:onClick()
		end
	else
		if self.t > 0 then
			self.t = self.t - speed*dt
		end
	end

	if love.mouse.isDown("l") == true then
		self.wasmousedown = true
	else
		self.wasmousedown = false
	end
	
	if self.t > 1 then self.t = 1 end
	if self.t < 0 then self.t = 0 end
end

function MMButton:onClick()
end

class "MainMenu" {
	font = nil
}

function MainMenu:__init()

	gSound = Sound:new()
	gSound:playMusic("music_menu_theme", nil)

	self.logoimg = love.graphics.newImage("gfx/logo.png")

	self.playbutton = MMButton:new("Spielen", gFont, 0, 0)

	function self.playbutton:onClick()

		gSound:playSound("menu_startgame", nil, 0, 0, 0, true)
		gSound:stopMusic("music_menu_theme")
		gSound:playMusic("music_main_theme", nil)

		gScreen = createWorld()
	end

	self.quitbutton = MMButton:new("Beenden", gFont, 0, 0)
	function self.quitbutton:onClick()
		love.event.quit()
	end
end

function MainMenu:update(dt)
	self.playbutton:update(dt)
	self.quitbutton:update(dt)
end

function MainMenu:draw()
	-- check if screen size has changed
	if self.screenwidth ~= love.window.getWidth() or
		self.screenheight ~= love.window.getHeight() then
		self.screenwidth = love.window.getWidth()
		self.screenheight = love.window.getHeight()

		self:regenerate(self.screenwidth, self.screenheight)
	end

	love.graphics.draw(self.logoimg, self.screenwidth/2 - self.logoimg:getWidth()/2,
									self.screenheight/3 - self.logoimg:getHeight())
	
	self.playbutton:draw()
	self.quitbutton:draw()
end

function MainMenu:regenerate(width, height)
	local halfheight = height/2
	local halfwidth = width/2

	local padding = 10
	local fontheight = gFont:getHeight()

	self.playbutton.x = halfwidth
	self.playbutton.y = halfheight

	self.quitbutton.x = halfwidth
	self.quitbutton.y = halfheight + fontheight + padding
end
