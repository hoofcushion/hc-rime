local function method_warp(obj,func)
 return function(...)
  func(obj,...)
 end
end
local is_method={init=true,func=true,fini=true,tags_match=true}
local is_engine={processor=true,segmentor=true,translator=true,filter=true}
local M={}
---@param engine lua_engine
function M.new_engine(engine)
 if type(engine)=="table" then
  local new={}
  for k,v in pairs(engine) do
   if is_method[k]==true and type(v)=="function" then
    v=method_warp(new,v)
   end
   new[k]=v
  end
  return new
 else
  return method_warp({},engine)
 end
end
function M.new_engines(obj)
 local new={}
 for k,v in pairs(obj) do
  if is_engine[k]==true then
   new[k]=M.new_engine(v)
  end
 end
 return new
end
return M
