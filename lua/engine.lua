local function method_warp(obj,func)
 return function(...)
  func(obj,...)
 end
end
local method_enum={init=true,func=true,fini=true,tags_match=true}
local engine_enum={processor=true,segmentor=true,translator=true,filter=true}
local M={}
function M.new_engine(engine)
 local new={}
 for k,v in pairs(engine) do
  if method_enum[k] and type(v)=="function" then
   v=method_warp(new,v)
  end
  new[k]=v
 end
 return new
end
function M.new_engines(obj)
 local new={}
 for k,v in pairs(obj) do
  if engine_enum[k] then
   new[k]=M.new_engine(v)
  end
 end
 return new
end
return M
