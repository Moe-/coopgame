local mt_class = {}

function mt_class:extends(parent)
   self.super = parent
   setmetatable(mt_class, {__index = parent})
   parent.__members__ = parent.__members__ or {}
   return self
end

local function define(class, members)
   class.__members__ = class.__members__ or {}
   for k, v in pairs(members) do
      class.__members__[k] = v
   end
   function class:new(...)
      local newvalue = {}
      for k, v in pairs(class.__members__) do
         newvalue[k] = v
      end
      setmetatable(newvalue, {__index = class})
      if newvalue.__init then
         newvalue:__init(...)
      end
      return newvalue
   end
end

function class(name)
    local newclass = {}
   _G[name] = newclass
   return setmetatable(newclass, {__index = mt_class, __call = define})
end

function lerp(v0, v1, t)
	return v0 + t*(v1-v0)
end

function getDistance(x1, y1, x2, y2)
  local dx = x1 - x2
  local dy = y1 - y2
  return math.sqrt(dx * dx + dy * dy)
end

-- Normalize two numbers
function normalize(x,y)
  local l=(x*x+y*y)^.5
  if l==0 then
    return 0,0,0
  else
    return x/l,y/l,l
  end
end
