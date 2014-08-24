local id_counter = 1

local function getIdAndIncrement()
	local id = id_counter
	id_counter = id_counter +1
	return id
end

class "Fraction" {
	flag = nil;
	id = 0;
}

function Fraction:__init(flag)
	self.flag = flag
	self.id = getIdAndIncrement()
end

function Fraction:getFlag()
	return self.flag
end

function Fraction:getId()
	return self.id
end

function Fraction:isEnemy(fraction)
	return (fraction:getId() ~= self.id)
end