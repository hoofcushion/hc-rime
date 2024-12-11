--- ---
--- The function is sorted by the complexity
--- ---
local __testsets <close> = setmetatable({},{
 __close=function(t)
  for _,v in ipairs(t) do
   v()
  end
 end,
})
local function test(testfn)
 table.insert(__testsets,testfn)
end
local unpack=unpack or table.unpack
local function toset(list)
 local set={}
 for _,v in ipairs(list) do
  set[v]=true
 end
 return set
end
local function is_list(tbl)
 local c=0
 for _ in pairs(tbl) do
  c=c+1
 end
 return c==#tbl
end
local function tobool(x)
 return not not x
end
local function totable(x)
 if type(x)=="table" then
  return x
 end
 return {x}
end
local function por(a,b)
 if a==nil then
  return b
 end
 return a
end
--- ---
--- Deepcopy
--- ---
local cant_copy={["userdata"]=true,["thread"]=true}
local function deepcopy(obj)
 local t=type(obj)
 if t~="table" then
  if cant_copy[t]==true then
   error("Cannot copy type: "..t)
  end
  return obj
 end
 local ret={}
 for k,v in pairs(obj) do
  k=deepcopy(k)
  v=deepcopy(v)
  ret[k]=v
 end
 local mt=getmetatable(obj)
 if mt~=nil then
  setmetatable(ret,deepcopy(mt))
 end
 return ret
end
local function deepequal(a,b)
 if a==b then
  return true
 end
 if type(a)~=type(b) then
  return false
 end
 if cant_copy[type(a)] or cant_copy[type(b)] then
  return false
 end
 local equals={}
 if type(a)=="table" then
  for k,v in pairs(a) do
   local is_equal=deepequal(v,b[k])
   if not is_equal then
    return false
   end
   equals[k]=true
  end
  for k,v in pairs(b) do
   if  equals[k]==nil
   and deepequal(v,a[k])==false
   then
    return false
   end
  end
 end
 return true
end
--- ---
--- ---
--- Serialize
--- ---
local varname_start=toset({
 "a","b","c","d","e","f","g",
 "h","i","j","k","l","m","n",
 "o","p","q","r","s","t",
 "u","v","w","x","y","z",
 "A","B","C","D","E","F","G",
 "H","I","J","K","L","M","N",
 "O","P","Q","R","S","T",
 "U","V","W","X","Y","Z",
 "_",
})
local varname_rest=toset({
 "a","b","c","d","e","f","g",
 "h","i","j","k","l","m","n",
 "o","p","q","r","s","t",
 "u","v","w","x","y","z",
 "A","B","C","D","E","F","G",
 "H","I","J","K","L","M","N",
 "O","P","Q","R","S","T",
 "U","V","W","X","Y","Z",
 "0","1","2","3","4","5","6","7","8","9",
 "_",
})
local is_keyword=toset({
 "and","break","do","else","elseif","end","false",
 "for","function","if","in","local","nil","not","or",
 "repeat","return","then","true","until","while",
})
---@param s string
local function is_varname(s)
 if is_keyword[s]==true then
  return false
 end
 if varname_start[s:sub(1,1)]==nil then
  return false
 end
 for i=2,#s do
  local char=s:sub(i,i)
  if varname_rest[char]==nil then
   return false
  end
 end
 return true
end
local as_qouted=toset({"function","string","thread","userdata"})
---@param obj any
---@return string
local function serialize(obj)
 local t=type(obj)
 if as_qouted[t]==true then
  return string.format("%q",tostring(obj))
 end
 if t~="table" then
  return tostring(obj)
 end
 local mt=getmetatable(obj)
 if mt~=nil and mt.__tostring~=nil then
  return tostring(obj)
 end
 local ret={}
 if is_list(obj) then
  for _,v in ipairs(obj) do
   v=serialize(v)
   table.insert(ret,v)
  end
 else
  for k,v in pairs(obj) do
   if (type(k)=="string" and is_varname(k))==false then
    k="["..serialize(k).."]"
   end
   v=serialize(v)
   table.insert(ret,k.."="..v)
  end
  table.sort(ret)
 end
 return "{"..table.concat(ret,",").."}"
end
local function equality_assert(a,b)
 if not deepequal(a,b) then
  error(string.format("not equal: %s ~= %s",serialize(a),serialize(b)),2)
 end
end
--- ---
--- Validate filter
--- ---
---@enum (key) nonil
local nonil={
 number=true,
 string=true,
 boolean=true,
 table=true,
 ["function"]=true,
 thread=true,
 userdata=true,
}
local any=deepcopy(nonil)
any["nil"]=true
---@alias _type "nonil"|"any"|type
---@param spec any
---@return table<_type,boolean>|nil
local function parse_validate_spec(spec)
 if spec=="any" then return any end
 if spec=="nonil" then return nonil end
 return toset(totable(spec))
end
---@param types (_type|_type[]|nil)[]
---@return (table<_type,boolean>|nil)[]
local function parse_validate_table(types)
 for i,spec in ipairs(types) do
  types[i]=parse_validate_spec(spec)
 end
 return types
end
local function type_error(index,expected,got)
 return ("invalid argument #%d, expect %s, got %s."):format(
  index,
  serialize(expected),
  serialize(got)
 )
end
--- ---
--- Fully optimized parameter check function
--- Add a filter to check the type of parameters of a function
---
--- E.g:
--- ```lua
--- local function foo(a,b,c)
---  return a+b+c
--- end
--- foo=std.purify(foo,{"number","number","number"})
--- foo(1,2,3) -- pass
--- foo(1,2,"3") -- error
--- ```
--- ---
---@generic F
---@param fn F
---@param types (_type|_type[]|nil)[]
---@param var boolean?
---@return F
local function purify(fn,types,var)
 local type_set=parse_validate_table(types)
 local fixed_len=#type_set
 if var==nil then
  return function(...)
   for i=1,fixed_len do
    local spec=type_set[i]
    if spec~=nil then
     local v=select(i,...)
     if spec[type(v)]==nil then
      error(type_error(i,spec,type(v)),2)
     end
    end
   end
   return fn(...)
  end
 end
 local var_type=type_set[fixed_len]
 fixed_len=fixed_len-1
 return function(...)
  local e=select("#",...)
  for i=1,math.min(fixed_len,e) do
   local spec=type_set[i]
   if spec~=nil then
    local v=select(i,...)
    if spec[type(v)]==nil then
     error(type_error(i,spec,v),2)
    end
   end
  end
  if var_type~=nil then
   for i=fixed_len+1,e do
    local v=select(i,...)
    if var_type[type(v)]==nil then
     error(type_error(i,var_type,v),2)
    end
   end
  end
  return fn(...)
 end
end
--- ---
--- get the original function that pasted into the purify
--- ---
---@param fn function
local function depurify(fn)
 return select(2,debug.getupvalue(fn,debug.getinfo(fn).nups))
end
local function serialize_print(...)
 local args={...}
 for i,arg in ipairs(args) do
  args[i]=serialize(arg)
 end
 print(unpack(args))
end
local std={}
std.por=por
std.print=serialize_print
std.deepcopy=deepcopy
std.serialize=serialize
std.is_varname=is_varname
std.tobool=tobool
std.totable=totable
std.purify=purify(purify,{
 "function",
 "table",
 {"boolean","nil"},
})
std.depurify=purify(depurify,{"function"})
---@generic base
---@generic new
---@param base base?
---@param new new?
---@return base|new
function std.class(base,new)
 if base==nil then return {} end
 if new==nil then new={} end
 setmetatable(new,{__index=base})
 return new
end
std.class=purify(std.class,{
 {"table","nil"},
 {"table","nil"},
})
std.mt=setmetatable({},{
 __index=function(t,k)
  local ret=rawget(t,k)
  if ret==nil then
   local mt_key="__"..k
   ret=function(v)
    return setmetatable({},{
     [mt_key]=v,
    })
   end
   rawset(t,k,ret)
  end
  return ret
 end,
})
std.io={}
function std.io.open(filename,mode)
 local file,err=io.open(filename,mode)
 if file==nil then
  error(err)
 end
 return file
end
std.io.open=purify(std.io.open,{"string","string"})
std.fs={}
std.fs.os_sep=package.config:sub(1,1)
---@param ... string|number
function std.fs.path_connect(...)
 return table.concat({...},std.fs.os_sep)
end
std.fs.path_connect=purify(std.fs.path_connect,{{"string","number"}})
std.utf8={}
---@param str string
---@param start integer
---@param final integer|nil
---@return string
function std.utf8.sub(str,start,final)
 local len_p=#str+1
 if final==nil then
  local i1=start<0 and len_p or 1
  start=utf8.offset(str,start,i1)
  str=string.sub(str,start)
  return str
 end
 local i1=start<0 and len_p or 1
 local i2=final<0 and len_p or 1
 final=final+1
 start,final=utf8.offset(str,start,i1),utf8.offset(str,final,i2)
 final=final-1
 str=string.sub(str,start,final)
 return str
end
std.utf8.sub=purify(std.utf8.sub,{"string","number",{"number","nil"}})
test(function()
 equality_assert(std.utf8.sub("hello",1,3),"hel")
 equality_assert(std.utf8.sub("你好",1,1),"你")
 equality_assert(std.utf8.sub("好",-1),"好")
end)
---@param str string
---@return string
function std.utf8.reverse(str)
 local tbl={}
 local i=utf8.len(str) --[[@as integer]]
 for _,c in utf8.codes(str) do
  tbl[i]=utf8.char(c)
  i=i-1
 end
 return table.concat(tbl)
end
std.utf8.reverse=purify(std.utf8.reverse,{"string"})
test(function()
 equality_assert(std.utf8.reverse("hello"),"olleh")
 equality_assert(std.utf8.reverse("你好"),"好你")
end)
function std.utf8.tolist(str)
 local chars={}
 for _,c in utf8.codes(str) do
  table.insert(chars,utf8.char(c))
 end
 return chars
end
std.utf8.tolist=purify(std.utf8.tolist,{"string"})
test(function()
 equality_assert(std.utf8.tolist("hello"),{"h","e","l","l","o"})
 equality_assert(std.utf8.tolist("你好"),{"你","好"})
end)
function std.utf8.split(str,sep)
 local ret={}
 local seps=std.utf8.tolist(sep)
 local set=toset(seps)
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
std.utf8.split=purify(std.utf8.split,{"string","string"})
test(function()
 equality_assert(std.utf8.split("hello world"," "),{"hello","world"})
 equality_assert(std.utf8.split("你好，世界","，"),{"你好","世界"})
end)
std.str={}
---@param str string
---@param sep string
function std.str.split(str,sep)
 local slices={}
 local pattern="[^"..std.str.escape_in_brace(sep).."]+"
 for slice in string.gmatch(str,pattern) do
  table.insert(slices,slice)
 end
 return slices
end
std.str.split=purify(std.str.split,{"string","string"})
test(function()
 equality_assert(std.str.split("hello world"," "),{"hello","world"})
end)
---@param str string
function std.str.tolist(str)
 local chars={}
 for char in string.gmatch(str,".") do
  table.insert(chars,char)
 end
 return chars
end
std.str.tolist=purify(std.str.tolist,{"string"})
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
std.str.escape_map=escape_map
---@param str string
function std.str.escape(str)
 return str:gsub("[%^%%%[%]%-$().*+?]",escape_map)
end
std.str.escape=purify(std.str.escape,{"string"})
---@param str string
function std.str.escape_in_brace(str)
 return str:gsub("[%^%%%[%]%-]",escape_map)
end
std.str.escape_in_brace=purify(std.str.escape_in_brace,{"string"})
---@param str string
function std.str.escape_to(str)
 return str:gsub("%%",escape_map)
end
std.str.escape_to=purify(std.str.escape_to,{"string"})
---@param s       string|number
---@param pattern string|number
---@param init?   integer
---@param plain?  boolean
function std.str.rfind(s,pattern,init,plain)
 return string.reverse(s):find(pattern,init,plain)
end
std.str.rfind=purify(std.str.rfind,{{"string","number"},"any","any","any"})
---@param str string
---@param from string
---@param to string
function std.str.replace(str,from,to)
 from=std.str.escape(from)
 to=std.str.escape(to)
 return str:gsub(from,to)
end
std.str.replace=purify(std.str.replace,{"string","string","string"})
function std.str.endswith(str,suf)
 return string.sub(str,- #suf)==suf
end
std.str.endswith=purify(std.str.endswith,{"string","string"})
function std.str.startswith(str,pre)
 return string.sub(str,1,#pre)==pre
end
std.str.startswith=purify(std.str.startswith,{"string","string"})
function std.str.strip(str,chars)
 if chars==nil then
  return string.gsub(str,"^%s*(.-)%s*$","%1")
 end
 local pattern=std.str.escape_in_brace(chars)
 return string.gsub(str,"^["..pattern.."]*(.-)["..pattern.."]*$","%1")
end
std.str.strip=purify(std.str.strip,{"string",{"string","nil"}})
test(function()
 equality_assert(std.str.strip("  hello  "),"hello")
end)
function std.str.splitlines(str)
 local ret={}
 for s in string.gmatch(str,"(.-)\r?\n") do
  table.insert(ret,s)
 end
 return ret
end
std.str.splitlines=purify(std.str.splitlines,{"string"})
std.tbl={}
---@param tbl table
---@param num integer
function std.tbl.ltake(tbl,num)
 if num==0 then return {} end
 local ret={}
 for i=1,num,1 do
  table.insert(ret,tbl[i])
 end
 return ret
end
std.tbl.ltake=purify(std.tbl.ltake,{"table","number"})
---@param tbl table
---@param num integer?
function std.tbl.rtake(tbl,num)
 if num==0 then return {} end
 local ret={}
 for _=1,num or #tbl do
  table.insert(ret,table.remove(tbl))
 end
 return ret
end
std.tbl.rtake=purify(std.tbl.rtake,{"table","number"})
---@param tbl table
function std.tbl.reverse(tbl)
 local ret={}
 for _=1,#tbl do
  table.insert(ret,table.remove(tbl))
 end
 return ret
end
std.tbl.reverse=purify(std.tbl.reverse,{"table"})
---@param tbl table
function std.tbl.map(tbl,func)
 local ret={}
 for k,v in pairs(tbl) do
  ret[k]=func(k,v)
 end
 return ret
end
std.tbl.map=purify(std.tbl.map,{"table","function"})
---@param tbl table
function std.tbl.each(tbl,func)
 for k,v in pairs(tbl) do
  func(k,v)
 end
 return tbl
end
std.tbl.each=purify(std.tbl.each,{"table","function"})
---@param tbl table
---@param value any
---@param target any|fun(any):boolean
---@param offset integer?
function std.tbl.insert_at(tbl,value,target,offset)
 table.insert(tbl,std.tbl.find(tbl,target)+(offset or 0),value)
 return tbl
end
std.tbl.insert_at=purify(std.tbl.insert_at,{"table","any","any",{"number","nil"}})
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
std.tbl.find=purify(std.tbl.find,{{"table"}})
std.tbl.toset=toset
std.tbl.toset=purify(std.tbl.toset,{"table"})
---@param tbl table
function std.tbl.count(tbl)
 local count=0
 for _ in pairs(tbl) do
  count=count+1
 end
 return count
end
std.tbl.count=purify(std.tbl.count,{"table"})
---@param tbl table
---@param field any
function std.tbl.check(tbl,field)
 if tbl[field]==nil then
  tbl[field]={}
 end
end
std.tbl.check=purify(std.tbl.check,{"table","string"})
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
std.tbl.get=purify(std.tbl.get,{{"table","string"},"nonil"})
---@param tbl table
---@param value any
---@param ... any
function std.tbl.set(tbl,value,...)
 local ret=tbl
 local e=select("#",...)
 for i=1,e-1 do
  local key=select(i,...)
  if ret[key]==nil then
   ret[key]={}
  end
  ret=ret[key]
 end
 ret[select(e,...)]=value
end
std.tbl.set=purify(std.tbl.set,{"table","any","nonil"},true)
---@param tbl table
function std.tbl.is_list(tbl)
 return #tbl==std.tbl.count(tbl)
end
std.tbl.is_list=purify(std.tbl.is_list,{"table"})
---@param tbl table
function std.tbl.is_empty(tbl)
 return next(tbl)==nil
end
std.tbl.is_empty=purify(std.tbl.is_empty,{"table"})
---@param tbl table
function std.tbl.keys(tbl)
 local ret={}
 for k in pairs(tbl) do
  table.insert(ret,k)
 end
 return ret
end
std.tbl.keys=purify(std.tbl.keys,{"table"})
---@param tbl table
function std.tbl.values(tbl)
 local ret={}
 for _,v in pairs(tbl) do
  table.insert(ret,v)
 end
 return ret
end
std.tbl.values=purify(std.tbl.values,{"table"})
---@param tbl table
---@param cond fun(...):boolean
function std.tbl.all(tbl,cond)
 for key,value in pairs(tbl) do
  if cond(key,value)==false then
   return false
  end
 end
 return true
end
std.tbl.all=purify(std.tbl.all,{"table","function"})
---@param tbl table
---@param cond fun(...):boolean
function std.tbl.any(tbl,cond)
 for k,v in pairs(tbl) do
  if cond(k,v)==true then
   return true
  end
 end
 return false
end
std.tbl.any=purify(std.tbl.any,{"table","function"})
std.list={}
---@param tbl table
---@param cond fun(...):boolean
function std.list.filter(tbl,cond)
 local ret={}
 for _,v in ipairs(tbl) do
  if cond(v) then
   table.insert(ret,v)
  end
 end
 return ret
end
std.list.filter=purify(std.list.filter,{"table","function"})
---@param list any[]
---@param func fun(...):any
function std.list.map(list,func)
 local ret={}
 for i,v in ipairs(list) do
  table.insert(ret,func(i,v))
 end
 return ret
end
std.list.map=purify(std.list.map,{"table","function"})
local function extend_list(list,l)
 local len=#list
 if len>8 then
  table.move(l,1,len,#list+1,list)
  return list
 end
 for _,v in ipairs(l) do
  table.insert(list,v)
 end
 return list
end
---@generic T
---@param list T[]
---@param ... T[]
---@return T[]
function std.list.extend(list,...)
 for i=1,select("#",...) do
  extend_list(list,select(i,...))
 end
 return list
end
std.list.extend=purify(std.list.extend,{"table","nonil"},true)
---@generic T
---@param ... T[]
---@return T[]
function std.list.combine(...)
 return std.list.extend({},...)
end
local function flatten(list,l,limit)
 if limit<=0 or type(l)~="table" then
  table.insert(list,l)
  return
 end
 for _,v in ipairs(l) do
  flatten(list,v,limit-1)
 end
 return list
end
---@param list any[]
---@param limit number
---@return any[]
function std.list.flatten(list,limit)
 if limit==nil then limit=math.huge end
 ---@diagnostic disable-next-line: return-type-mismatch
 return flatten({},list,limit)
end
std.list.flatten=purify(std.list.flatten,{"table","number"})
---@param s number
---@param e number
---@param g number
---@param func (fun(index:number):any)?
---@return any[]
function std.list.range(s,e,g,func)
 local list={}
 if func==nil then
  for i=s,e,g do
   table.insert(list,i)
  end
 else
  for i=s,e,g do
   table.insert(list,func(i))
  end
 end
 return list
end
std.list.range=purify(std.list.range,{"number","number","number",{"function","nil"}})
---@param list any[]
---@param s integer
---@param e integer
function std.list.slice(list,s,e)
 return table.move(list,s,e or #list,1,{})
end
std.list.slice=purify(std.list.slice,{"table","number","number"})
return std
