local std={}
---@param a any
---@param b any
---@return any
std.por=function(a,b)
 if a==nil then return b end
 return a
end
---@param x any
---@return boolean
std.tobool=function(x)
 return not not x
end
---@param x any
---@return table
std.totable=function(x)
 if type(x)=="table" then return x end
 return {x}
end
-- Deep copy functionality
local cant_copy={["userdata"]=true,["thread"]=true}
---@param obj any
---@return any
std.deepcopy=function(obj)
 local t=type(obj)
 if t~="table" then
  if cant_copy[t] then error("Cannot copy type: "..t) end
  return obj
 end
 local ret={}
 for k,v in pairs(obj) do
  ret[std.deepcopy(k)]=std.deepcopy(v)
 end
 local mt=getmetatable(obj)
 if mt~=nil then setmetatable(ret,std.deepcopy(mt)) end
 return ret
end
-- Serialization
---@param s string
---@return boolean
local function is_varname(s)
 local keywords={
  "and","break","do","else","elseif","end","false",
  "for","function","if","in","local","nil","not","or",
  "repeat","return","then","true","until","while",
 }
 for _,kw in ipairs(keywords) do
  if s==kw then return false end
 end
 if not s:match("^[a-zA-Z_][a-zA-Z0-9_]*$") then return false end
 return true
end

---@param obj any
---@return string
std.serialize=function(obj)
 local t=type(obj)
 if t=="function" or t=="string" or t=="thread" or t=="userdata" then
  return string.format("%q",tostring(obj))
 end
 if t~="table" then return tostring(obj) end
 local mt=getmetatable(obj)
 if mt~=nil and mt.__tostring~=nil then return tostring(obj) end
 local ret={}
 if #obj==std.tbl.count(obj) then -- is list
  for _,v in ipairs(obj) do table.insert(ret,std.serialize(v)) end
 else
  for k,v in pairs(obj) do
   if type(k)~="string" or not is_varname(k) then
    k="["..std.serialize(k).."]"
   end
   table.insert(ret,k.."="..std.serialize(v))
  end
  table.sort(ret)
 end
 return "{"..table.concat(ret,",").."}"
end
---@param ... any
std.print=function(...)
 local args={...}
 for i,arg in ipairs(args) do args[i]=std.serialize(arg) end
 print(table.unpack(args))
end
---@generic T:table|function
---@param ... T
---@return T
function std.extend(...)
 local new
 for i=1,select("#",...) do
  local t=select(i,...)
  local tp=type(t)
  if tp=="function" then
   local ret=t(new)
   if ret~=nil then
    new=ret
   end
  elseif tp=="table" then
   if type(new)~="table" then
    new={}
   end
   if std.tbl.is_list(new) and std.tbl.is_list(t) then
    new=std.list.extend(new,t)
   else
    for k,v in pairs(t) do
     local nv=new[k]
     if type(nv)=="table" and type(v)=="table" and std.tbl.is_list(nv) and std.tbl.is_list(v) then
      new[k]=std.list.extend(nv,v)
     else
      new[k]=std.extend(nv,v)
     end
    end
   end
  else
   new=t
  end
 end
 return new
end
-- Table utilities
std.tbl={}
---@param list any[]
---@return table<any, boolean>
std.tbl.toset=function(list)
 local set={}
 for _,v in ipairs(list) do set[v]=true end
 return set
end
---@param tbl table
---@return integer
std.tbl.count=function(tbl)
 local count=0
 for _ in pairs(tbl) do count=count+1 end
 return count
end
---@param tbl table
---@return boolean
std.tbl.is_list=function(tbl)
 return #tbl==std.tbl.count(tbl)
end
---@param tbl table
---@param target any|fun(any):boolean
function std.tbl.find(tbl,target)
 if type(target)=="function" then
  for i,v in pairs(tbl) do
   if target(v) then return i end
  end
 end
 for i,v in pairs(tbl) do
  if v==target then return i end
 end
end
---@param tbl table
---@param value any
---@param target any|fun(any):boolean
---@param offset integer?
function std.tbl.insert_at(tbl,value,target,offset)
 table.insert(tbl,std.tbl.find(tbl,target)+(offset or 0),value)
 return tbl
end
---@param tbl table
---@param ... any
function std.tbl.get(tbl,...)
 local keys={...}
 local t=tbl
 for _,v in ipairs(keys) do
  t=t[v]
  if type(t)~="table" then
   return nil
  end
 end
 return t
end
-- List utilities
std.list={}
---@generic T
---@param tbl T[]
---@param cond fun(value: T): boolean
---@return T[]
std.list.filter=function(tbl,cond)
 local ret={}
 for _,v in ipairs(tbl) do
  if cond(v) then table.insert(ret,v) end
 end
 return ret
end
---@generic T, U
---@param list T[]
---@param func fun(index: integer, value: T): U
---@return U[]
std.list.map=function(list,func)
 local ret={}
 for i,v in ipairs(list) do table.insert(ret,func(i,v)) end
 return ret
end
---@generic T
---@param list T[]
---@param ... T[]
---@return T[]
std.list.extend=function(list,...)
 for i=1,select("#",...) do
  local l=select(i,...)
  for _,v in ipairs(l) do table.insert(list,v) end
 end
 return list
end
---@generic T
---@param ... T[]
---@return T[]
std.list.combine=function(...)
 return std.list.extend({},...)
end
---@param list any[]
---@param l any
---@param limit integer
local function flatten(list,l,limit)
 if limit<=0 or type(l)~="table" then
  table.insert(list,l)
  return list
 end
 for _,v in ipairs(l) do flatten(list,v,limit-1) end
 return list
end

---@param list any[]
---@param limit? integer
---@return any[]
std.list.flatten=function(list,limit)
 if limit==nil then limit=math.huge end
 return flatten({},list,limit)
end
---@generic T
---@param s integer
---@param e integer
---@param g integer
---@param func? fun(index: integer): T
---@return T[]
std.list.range=function(s,e,g,func)
 local list={}
 if func==nil then
  for i=s,e,g do table.insert(list,i) end
 else
  for i=s,e,g do table.insert(list,func(i)) end
 end
 return list
end
---@generic T
---@param list T[]
---@param s integer
---@param e integer
---@return T[]
std.list.slice=function(list,s,e)
 return table.move(list,s,e or #list,1,{})
end
local escape_map={
 ["^"]="%^",
 ["$"]="%$",
 ["("]="%(",
 [")"]="%)",
 ["["]="%[",
 ["]"]="%]",
 ["."]="%.",
 ["*"]="%*",
 ["+"]="%+",
 ["-"]="%-",
 ["?"]="%?",
 ["%"]="%%",
}
-- String utilities
std.str={}
---@param str string
---@param sep string
---@return string[]
std.str.split=function(str,sep)
 local slices={}
 local pattern="[^"..sep:gsub("[%^%%%[%]%-]",escape_map).."]+"
 for slice in str:gmatch(pattern) do table.insert(slices,slice) end
 return slices
end
---@param str string
---@return string[]
std.str.tolist=function(str)
 local chars={}
 for char in str:gmatch(".") do table.insert(chars,char) end
 return chars
end
---@param str string
---@return string
std.str.escape=function(str)
 return (str:gsub("[%^%%%[%]%-$().*+?]",escape_map))
end
---@param str string
---@return string
std.str.escape_in_brace=function(str)
 return (str:gsub("[%^%%%[%]%-]",escape_map))
end
---@param s string|number
---@param pattern string|number
---@param init? integer
---@param plain? boolean
---@return integer?, integer?
std.str.rfind=function(s,pattern,init,plain)
 return string.reverse(s):find(pattern,init,plain)
end
---@param str string
---@param from string
---@param to string
---@return string
std.str.replace=function(str,from,to)
 from=std.str.escape(from)
 to=std.str.escape(to)
 return (str:gsub(from,to))
end
---@param str string
---@param suf string
---@return boolean
std.str.endswith=function(str,suf)
 return str:sub(- #suf)==suf
end
---@param str string
---@param pre string
---@return boolean
std.str.startswith=function(str,pre)
 return str:sub(1,#pre)==pre
end
---@param str string
---@param chars? string
---@return string
std.str.strip=function(str,chars)
 if chars==nil then return (str:gsub("^%s*(.-)%s*$","%1")) end
 local pattern=std.str.escape_in_brace(chars)
 return (str:gsub("^["..pattern.."]*(.-)["..pattern.."]*$","%1"))
end
---@param str string
---@return string[]
std.str.splitlines=function(str)
 local ret={}
 for s in str:gmatch("(.-)\r?\n") do table.insert(ret,s) end
 return ret
end
-- UTF-8 utilities
std.utf8={}
---@param str string
---@param start integer
---@param final? integer
---@return string
std.utf8.sub=function(str,start,final)
 local len_p=#str+1
 if final==nil then
  local i1=start<0 and len_p or 1
  start=utf8.offset(str,start,i1)
  return str:sub(start)
 end
 local i1=start<0 and len_p or 1
 local i2=final<0 and len_p or 1
 final=final+1
 start,final=utf8.offset(str,start,i1),utf8.offset(str,final,i2)
 return str:sub(start,final-1)
end
---@param str string
---@return string
std.utf8.reverse=function(str)
 local tbl={}
 local i=utf8.len(str) or 0
 for _,c in utf8.codes(str) do
  tbl[i]=utf8.char(c)
  i=i-1
 end
 return table.concat(tbl)
end
---@param str string
---@return string[]
std.utf8.tolist=function(str)
 local chars={}
 for _,c in utf8.codes(str) do table.insert(chars,utf8.char(c)) end
 return chars
end
---@param str string
---@param sep string
---@return string[]
std.utf8.split=function(str,sep)
 local ret={}
 local seps=std.utf8.tolist(sep)
 local set=std.tbl.toset(seps)
 local word=""
 for _,c in utf8.codes(str) do
  local char=utf8.char(c)
  if set[char] then
   table.insert(ret,word)
   word=""
  else
   word=word..char
  end
 end
 table.insert(ret,word)
 return ret
end
-- Class system
---@generic Base, New
---@param base? Base
---@param new? New
---@return Base|New
std.class=function(base,new)
 if base==nil then return {} end
 if new==nil then new={} end
 setmetatable(new,{__index=base})
 return new
end
-- Metatable utilities
std.mt=setmetatable({},{
 __index=function(t,k)
  local ret=rawget(t,k)
  if ret==nil then
   local mt_key="__"..k
   ret=function(v)
    return setmetatable({},{[mt_key]=v})
   end
   rawset(t,k,ret)
  end
  return ret
 end,
})
-- IO utilities
std.io={}
---@param filename string
---@param mode string
---@return file*
std.io.open=function(filename,mode)
 local file,err=io.open(filename,mode)
 if file==nil then error(err) end
 return file
end
-- Filesystem utilities
std.fs={}
std.fs.os_sep=package.config:sub(1,1)
---@param ... string|number
---@return string
std.fs.path_connect=function(...)
 return table.concat({...},std.fs.os_sep)
end
return std
