---@class Class
local Class={}
---create a class with inherit.
---use `base` as its base class.
---@generic base:table
---@generic new:table
---@param base base|nil
---@param new new|nil
---@return base|new
function Class.New(base,new)
 if base==nil then
  return {}
 end
 if new==nil then
  new={}
 end
 setmetatable(new,{__index=base})
 return new
end
return Class
