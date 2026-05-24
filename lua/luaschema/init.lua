---@diagnostic disable: unused-local, unused-function
std=require("std")
NS=setmetatable({},{__index=function(_,k) return k end})
NS2=setmetatable({},{__index=function(_,k) return NS end})
local utils=require("utils")
local json=require("luaschema.json")
package.path=std.fs.path_connect(rime_api:get_user_data_dir(),"luaschema","?.lua")..";"..package.path
package.path=std.fs.path_connect(rime_api:get_user_data_dir(),"luaschema","?","init.lua")..";"..package.path
--- the pototype of rime schema file
LuaSchema={}
local cache={}
function LuaSchema.new(info)
 local lua_schema=cache[info]
 if lua_schema then
  return lua_schema
 end
 cache[info]=lua_schema
 lua_schema=setmetatable({},{__index=LuaSchema})
 lua_schema.info=info
 if info.schema~=nil then
  lua_schema.type="schema"
  lua_schema.name=info.schema.schema_id
 elseif info.patch~=nil then
  lua_schema.type="custom"
  lua_schema.name=info.target
 elseif info.trime~=nil then
  lua_schema.type="trime"
  lua_schema.name=info.trime
 else
  lua_schema.type="dict"
  lua_schema.name=info.name
 end
 lua_schema:parse()
 return lua_schema
end
function LuaSchema:get_namespaces(engine_type)
 local info=self.info
 local engines=std.tbl.get(info,"engine",engine_type)
 if type(engines)~="table" then
  return {}
 end
 engines=std.list.filter(engines,function(x)
  return x:find("@",1,true)~=nil
 end)
 engines=std.list.map(engines,function(_,name)
  return name:match("@([^@]+)$")
 end)
 return engines
end
function LuaSchema:get_options(namespaces)
 return std.list.map(namespaces,function(i,v)
  return std.tbl.get(self.info,v)
 end)
end
local parse_rules={
 function(self,info)
  local engines=std.tbl.get(info,"engine")
  if type(engines)~="table" then
   return
  end
  for _,sublist in pairs(engines) do
   for index,spec in ipairs(sublist) do
    if type(spec)=="table" then
     local name=spec.name
     sublist[index]=name
     local namespace=name:match("@([^@]+)$") or ""
     if spec.option then
      info[namespace]=std.extend(info[namespace],spec.option)
     end
     local module=spec.module
     if module then
      if not spec.id then
       std.print(spec)
      end
      local id="exported_ module_"..(spec.id or ("%p"):format(module))
      _G[id]=module
      local prefix=name:match("^([^@]+)")
      local module_name=prefix.."@"..id.."@"..namespace
      sublist[index]=module_name
     end
    end
   end
  end
 end,
 function(self,info)
  ---@param algebra table|nil
  local function parse_algebra(algebra)
   if type(algebra)~="table" then return end
   for i,formula in ipairs(algebra) do
    local parts=std.str.split(formula,"/")
    local type,from,to=parts[1],parts[2],parts[3] or ""
    if type=="xform_unique" then
     type="xform"
     to="�"..table.concat(std.str.tolist(to),"�").."�"
    end
    algebra[i]=("%s/%s/%s/"):format(type,from,to)
   end
   table.insert(algebra,"xform/�//")
   return algebra
  end
  parse_algebra(std.tbl.get(info,"speller","algebra"))
  local namespaces=self:get_namespaces("translators")
  local translators=self:get_options(namespaces)
  for _,translator in ipairs(translators) do
   parse_algebra(std.tbl.get(translator,"comment_format"))
   parse_algebra(std.tbl.get(translator,"preedit_format"))
  end
 end,
}
function LuaSchema:parse()
 local info=self.info
 local schema_type=self.type
 if schema_type=="schema" then
  for _,rule in pairs(parse_rules) do
   rule(self,info)
  end
 end
end
function LuaSchema:write()
 local info=self.info
 local path=std.fs.path_connect(
  rime_api:get_user_data_dir(),
  ("%s.%s.yaml"):format(self.name,self.type)
 )
 local ok,content=pcall(function()
  return json.encode(self.info)
 end)
 if ok then
  std.io.open(path,"w")
   :write(content)
   :close()
 end
end
function LuaSchema.load(tbl)
 LuaSchema.new(tbl):write()
end
return LuaSchema
