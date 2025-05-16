---@diagnostic disable: unused-local, unused-function

local json=require("luaschema.json")
package.path=rime.fs.path_connect(rime.rime_path.user,"luaschema","?.lua")..";"..package.path
package.path=rime.fs.path_connect(rime.rime_path.user,"luaschema","?","init.lua")..";"..package.path
--- the pototype of rime schema file
local LuaSchema={}
function LuaSchema:new(info)
 local new=setmetatable({info=info},{__index=self})
 if info.schema~=nil then
  new.type="schema"
  new.name=info.schema.schema_id
 elseif info.patch~=nil then
  new.type="custom"
  new.name=info.target
 else
  new.type="dict"
  new.name=info.name
 end
 new:parse()
 return new
end
--- ---
--- New algebra formula: xform_unique/from/to/
--- ---
local function parse_algebra(algebra)
 if type(algebra)~="table" then return end
 ---@cast algebra table
 for i,formula in ipairs(algebra) do
  local parts=rime.str.split(formula,"/")
  local type,from,to=parts[1],parts[2],parts[3] or ""
  if type=="xform_unique" then
   type="xform"
   to="�"..table.concat(rime.str.tolist(to),"�").."�"
  end
  algebra[i]=("%s/%s/%s/"):format(type,from,to)
 end
 table.insert(algebra,"xform/�//")
 return algebra
end
function LuaSchema:get_namespaces(engine_type)
 local info=self.info
 local engines=rime.tbl.get(info,"engine",engine_type)
 if type(engines)~="table" then
  return {}
 end
 engines=rime.list.filter(engines,function(x)
  return x:find("@",1,true)~=nil
 end)
 engines=rime.list.map(engines,function(_,name)
  return name:match("@([^@]+)$")
 end)
 return engines
end
function LuaSchema:get_options(namespaces)
 return rime.list.map(namespaces,function(i,v)
  return rime.tbl.get(self.info,v)
 end)
end
function LuaSchema:parse()
 local info=self.info
 local schema_type=self.type
 if schema_type=="schema" then
  --- ---
  --- Parse schema nested engine options
  --- ---
  local engines=rime.tbl.get(info,"engine")
  if type(engines)=="table" then
   for _,specs in pairs(engines) do
    for _,spec in ipairs(specs) do
     if type(spec)=="table" then
      local name=spec.name
      local ns=name:match("@([^@]+)$")
      specs[_]=spec.name
      info[ns]=rime.extend(info[ns],spec.option)
     end
    end
   end
  end
  --- ---
  --- Parse custom algebra syntax
  --- ---
  parse_algebra(rime.tbl.get(info,"speller","algebra"))
  local namespaces=self:get_namespaces("translators")
  local translators=self:get_options(namespaces)
  for _,translator in ipairs(translators) do
   parse_algebra(rime.tbl.get(translator,"comment_format"))
   parse_algebra(rime.tbl.get(translator,"preedit_format"))
  end
 end
end
function LuaSchema:extend(info)
 self.info=rime.extend(self.info,info)
end
function LuaSchema:write()
 local info=self.info
 local path=rime.fs.path_connect(
  rime.rime_path.user,
  ("%s.%s.yaml"):format(self.name,self.type)
 )
 rime.io.open(path,"w")
  :write(json.encode(self.info))
  :close()
end
function LuaSchema.load(tbl)
 LuaSchema:new(tbl):write()
end
function LuaSchema.loadlist(list)
 for _,v in ipairs(list) do
  LuaSchema.load(require(v))
 end
end
return LuaSchema
