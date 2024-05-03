---@diagnostic disable: unused-local, unused-function
local utils=require("utils")
local json=require("luaschema.json")
package.path=utils.path_connect(utils.rime_path.user,"luaschema","?.lua")..";"..package.path
package.path=utils.path_connect(utils.rime_path.user,"luaschema","?","init.lua")..";"..package.path
--- the pototype of rime schema file
local LuaSchema={}
function LuaSchema:new(info)
 local new=setmetatable({info=info},{__index=self})
 if info.schema~=nil then
  new.type="schema"
 else
  new.type="dict"
 end
 return new
end
function LuaSchema:write()
 local info=self.info
 local path=utils.path_connect(
  utils.rime_path.user,
  info.schema.schema_id.."."..self.type..".yaml"
 )
 utils.popen(path,"w")
  :write(json.encode(self.info))
  :close()
end
function LuaSchema.load(tbl)
 utils.typecheck(tbl,"table")
 LuaSchema:new(tbl):write()
end
function LuaSchema.loadlist(list)
 utils.typecheck(list,"table")
 for _,v in ipairs(list) do
  utils.typecheck(v,"string")
  LuaSchema.load(require(v))
 end
end
return LuaSchema
