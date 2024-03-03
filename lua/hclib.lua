---
--- Lua personal QOL module.
--- Reduce nil check
local hc={}
---@alias nonil
---| boolean
---| number
---| integer
---| thread
---| table
---| string
---| userdata
---| lightuserdata
---| function
---
---@enum (key) deepcopy_invalid_type
local deepcopy_invalid_type={
 ["userdata"]=true,
 ["thread"]=true,
}
---@generic I
---@param input I
---@return I
local function deepcopy(input)
 local t=type(input)
 if deepcopy_invalid_type[t]==true then
  error("Cannot deepcopy type "..t)
 end
 if t=="table" then
  local copy={}
  for k,v in pairs(input) do
   k=deepcopy(k)
   v=deepcopy(v)
   copy[k]=v
  end
  return copy
 end
 return input
end
hc.deepcopy=deepcopy
local function deepnext(tbl,key)
 local k,v=next(tbl,key)
 return deepcopy(k),deepcopy(v)
end
hc.deepnext=deepnext
local function deeppairs(tbl)
 return deepnext,tbl
end
hc.deeppairs=deeppairs
---@enum (key) tbl_extend_mode
local tbl_extend_mode_enum={
 ["force"]=true,
 ["keep"]=true,
 ["error"]=true,
}
---@param mode tbl_extend_mode
---@param main table
---@param ... table
---@return table
function hc.tbl_extend(main,mode,...)
 local t=type(main)
 if t~="table" then
  error("expect "..tostring(main)..", got "..t..".")
 end
 if mode==nil or tbl_extend_mode_enum[mode]==nil then
  error("bad arg #2")
 end
 local len=select("#",...)
 if len==0 then
  error("too few args, at least 3")
 end
 if mode=="force" then
  for i=1,len do
   for k,v in pairs(select(i,...)) do
    main[k]=v
   end
  end
 elseif mode=="keep" then
  for i=1,len do
   for k,v in pairs(select(i,...)) do
    if main[k]~=nil then
     main[k]=v
    end
   end
  end
 elseif mode=="error" then
  for i=1,len do
   for k,v in pairs(select(i,...)) do
    if main[k]~=nil then
     error("New index already exsists in: "..tostring(main))
    end
    main[k]=v
   end
  end
 end
 return main
end
---@param mode tbl_extend_mode
---@param main table
---@param ... table
---@return table
function hc.tbl_deep_extend(mode,main,...)
 local t=type(main)
 if t~="table" then
  error("expect "..tostring(main)..", got "..t..".")
 end
 if mode==nil or tbl_extend_mode_enum[mode]==nil then
  error("bad arg #2")
 end
 local len=select("#",...)
 if len==0 then
  error("too few args, at least 3")
 end
 main=deepcopy(main)
 if mode=="force" then
  for i=1,len do
   for k,v in deeppairs(select(i,...)) do
    main[k]=v
   end
  end
 elseif mode=="keep" then
  for i=1,len do
   for k,v in deeppairs(select(i,...)) do
    if main[k]~=nil then
     main[k]=v
    end
   end
  end
 elseif mode=="error" then
  for i=1,len do
   for k,v in deeppairs(select(i,...)) do
    if main[k]~=nil then
     error("New index already exsists in: "..tostring(main))
    end
    main[k]=v
   end
  end
 end
 return main
end
function hc.ret2(input)
 return input,input
end
local loaded=package.loaded
function hc.is_loaded(modname)
 return function()
  return loaded[modname]~=nil
 end
end
--- Shortcuts
local tbl_insert=table.insert
---@param data any
function hc.chain(data)
 ---@param fn function
 ---@param ... any
 local function cf(fn,...)
  if fn~=nil then
   data=fn(data,...)
   return cf
  end
  return data
 end
 return cf
end
---@param fn function
---@param data any
---@param ... any
---@return function
function hc.fchain(fn,data,...)
 return hc.chain(data)(fn,...)
end
function hc.set(t,k,v)
 t[k]=v
 return t
end
function hc.pset(t,k,v)
 if type(t)=="table" and k~=nil then
  t[k]=v
 end
 return t
end
function hc.get(t,k)
 return k~=nil and t[k] or nil
end
function hc.pget(t,k)
 return type(t)=="table" and k~=nil and t[k] or nil
end
---@generic T:nonil
---@param arr T[]
---@return table<T,true>
function hc.mkmap(arr)
 local map={}
 for _,v in ipairs(arr) do
  map[v]=true
 end
 return map
end
---@generic R
---@param expr R|fun(...:any):R
---@param ... any
---@return R
function hc.eval(expr,...)
 if type(expr)=="function" then
  return expr(...)
 end
 return expr
end
---
--- Function that does nothing.
function hc.empty_f() end
---
--- Table that always empty.
hc.empty_t=setmetatable({},{
 __index=hc.empty_f,
 __newindex=hc.empty_f,
})
---
--- Metatable for freeze.
local freeze_mt={
 __newindex=hc.empty_f,
}
---
--- Freeze a table, reject new index.
---@generic T:table
---@param tab T
---@return T
function hc.freeze(tab)
 local mt=getmetatable(tab)
 if mt~=nil then
  mt.__newindex=hc.empty_f
  return tab
 end
 return setmetatable(tab,freeze_mt)
end
---@param any any
---@return boolean
function hc.tobool(any)
 return any~=nil and any~=false
end
---@generic T
---@param any T
---@return T[]
function hc.totable(any)
 if type(any)~="table" then
  return {any}
 end
 return any
end
local invalid={["userdata"]=true,["thread"]=true}
---@generic I
---@param input I
---@return I
local function deepcopy(input)
 local t=type(input)
 if invalid[t]==true then
  error("Cannot deepcopy object of type "..t)
 end
 if t=="table" then
  local copy={}
  for k,v in pairs(input) do
   k=deepcopy(k)
   v=deepcopy(v)
   copy[k]=v
  end
  return copy
 end
 return input
end
hc.deepcopy=deepcopy
---@param fns table<function,any>
function hc.tbl_callkeys(fns) for fn in pairs(fns) do fn() end end
---@param fns table<any,function>
function hc.tbl_calldict(fns) for _,fn in pairs(fns) do fn() end end
---@param fns function[]
function hc.tbl_calllist(fns) for _,fn in ipairs(fns) do fn() end end
---@generic T,Y
---@param main T[]
---@param sub Y[]
---@return (T|Y)[]
function hc.tbl_listconnect(main,sub)
 for _,v in ipairs(sub) do
  table.insert(main,v)
 end
 return main
end
---@generic T,Y
---@param main T[]
---@param sub Y|Y[]
---@return (T|Y)[]
function hc.tbl_deepconnect(main,sub)
 if type(sub)~="table" then
  table.insert(main,sub)
 else
  for _,v in ipairs(sub) do
   hc.tbl_deepconnect(main,v)
  end
 end
 return main
end
function hc.tbl_list_expand(input)
 return hc.tbl_deepconnect({},input)
end
function hc.tbl_check(t,k)
 local ret=t[k]
 if ret==nil then
  ret={}
  t[k]=ret
 end
 return ret
end
local function str_reach(t,str)
 if type(t)~="table" then
  return t
 end
 for k in string.gmatch(str,"([^.]+)%.") do
  t=hc.tbl_check(t,k)
  if type(t)~="table" then return t end
 end
 return t
end
---@param t table
---@param str string
function hc.strget(t,str)
 return str_reach(t,str)[string.match(str,"[^.]+$")]
end
---@param t table
---@param str string
---@param v any
function hc.strset(t,str,v)
 str_reach(t,str)[string.match(str,"[^.]+$")]=v
 return t
end
local function tbl_reach(t,keys,l)
 if type(t)~="table" then return t end
 local i=1
 local key
 while i<l and type(t)=="table" do
  key=keys[i]
  t=hc.tbl_check(t,key)
  if type(t)~="table" then return t end
  i=i+1
 end
 return t
end
---@param t table
---@param keys nonil[]
---@param v any
function hc.tblset(t,keys,v)
 local e=#keys
 tbl_reach(t,keys,e)[keys[e]]=v
 return t
end
---@param t table
---@param keys nonil[]
function hc.tblget(t,keys)
 local e=#keys
 return tbl_reach(t,keys,e)[keys[e]]
end
---
--- Like table.insert, but with a index parameter.
--- And won't index nil.
---@param tbl table
---@param index nonil
---@param value any
function hc.pinject(tbl,index,value)
 local tb=tbl[index]
 if tb==nil then
  tbl[index]={value}
  return
 end
 tb[#tb+1]=value
end
---@param tbl table
---@param ... nonil
function hc.pnewindex(tbl,...)
 local e=select("#",...)
 if e<=2 then return end
 local road=tbl
 for i=1,e-2 do
  local v=select(i,...)
  if v==nil then
   return
  end
  road=hc.tbl_check(road,v)
 end
 road[select(e-1,...)]=select(e,...)
 return tbl
end
---
--- Concat string but won't concat nil.
--- Always return string value.
---@nodiscard
---@param s1 string|nil
---@param s2 string|nil
---@return string
function hc.pconcat(s1,s2)
 if s1~=nil then
  if s2~=nil then
   return s1..s2
  end
  return s1
 end
 if s2~=nil then
  return s2
 end
 return ""
end
---
--- Returns rhs if lhs is nil, otherwise returns lhs.
---@generic L,R,F:nonil
---@param lhs L
---@param rhs R
---@param fallback nonil
---@return L|R|F
function hc.por(lhs,rhs,fallback)
 if lhs==nil then
  if rhs==nil then
   return fallback
  end
  return rhs
 end
 return lhs
end
---@param fn function
---@return function:boolean,...
function hc.pwrap(fn)
 return function(...)
  return pcall(fn,...)
 end
end
---@generic L,R
---@param lhs L
---@param t type
---@param rhs R
---@return L|R
function hc.tor(lhs,t,rhs)
 if type(lhs)~=t then
  return rhs
 end
 return lhs
end
---@generic L,R
---@param lhs L
---@param t type
---@param rhs R
---@return L|R
function hc.tand(lhs,t,rhs)
 if type(lhs)==t then
  return rhs
 end
 return lhs
end
---
--- Return a table contains all value in `tbl` that type filtered by `union`
---@param union table<type,true|nil>
---@param tbl any
---@return any[]
function hc.tfilter(union,tbl)
 local e=#tbl
 if e==0 then return tbl end
 local ret={}
 local i=1
 local v
 ::start::
 v=tbl[i]
 if union[type(v)]~=nil then
  ret[#ret+1]=v
 end
 i=i+1
 if v~=nil then goto start end
 return ret
end
---
--- Return a table contains all value in `...` that type filtered by `union`
---@param union table<type,true|nil>
---@param ... any
---@return any[]
function hc.filter(union,...)
 local e=select("#",...)
 if e==0 then return {} end
 local ret={}
 local i=1
 local v
 ::start::
 v=select(i,...)
 if union[type(v)]~=nil then
  ret[#ret+1]=v
 end
 i=i+1
 if v~=nil then goto start end
 return ret
end
---
--- Extend table, won't index nil.
--- Always return table value.
---@nodiscard
---@generic T1:table,T2:table
---@param t1 T1|nil
---@param t2 T2|nil
---@return T1|T2
function hc.pcombine(t1,t2)
 if t1==nil then
  if t2==nil then
   return {}
  end
  return t2
 end
 if t2==nil then
  return t1
 end
 for k,v in pairs(t2) do
  t1[k]=v
 end
 return t1
end
function hc.pcombine_deep(t1,t2)
 if t1==nil then
  if t2==nil then
   return {}
  end
  return t2
 end
 if t2==nil then
  return t1
 end
 return hc.tbl_deep_extend("force",t1,t2)
end
---@param ... any
---@return table|nil
function hc.punique_list(...)
 local len=select("#",...)
 local main,exists={},{}
 for i=1,len do
  for _,v in hc.pipairs(select(i,...)) do
   if exists[v]==nil then
    exists[v]=true
    table.insert(main,v)
   end
  end
 end
 if next(main)~=nil then
  return main
 end
end
--- ---
--- Iterators.
--- ---
--- Iterate the value itself, and stop.
local function self_iter(any,done)
 if done~=true then
  return true,any
 end
end
---
--- Like `pairs`, but won't iterate nil,
--- return nil as key and the input itself as value if it's not a table.
---@generic T: any, K, V
---@param any T
---@return fun(table: table<K, V>, index?: K):K, V
---@return T?
function hc.ppairs(any)
 if any==nil then
  return hc.empty_f
 end
 if type(any)=="table" then
  return pairs(any)
 end
 return self_iter,any
end
local function iter2_2(state,index)
 local v1=state[1][index]
 local v2=state[2][index]
 if v1 or v2 then
  return index+1,v1,v2
 end
end
local function iter2_1(state,index)
 local v1=state[1][index]
 local v2=state[2]
 if v1 or v2 then
  return index+1,v1,v2
 end
end
local function iter2_1r(state,index)
 local v1=state[1][index]
 local v2=state[2]
 if v1 or v2 then
  return index+1,v2,v1
 end
end
local function iter2_0(state,done)
 if done==nil then
  return 1,state[1],state[2]
 end
end
---@param tbl any|any[]
---@param sub any|any[]
function hc.pmipairs(tbl,sub)
 if type(tbl)=="table" then
  if type(sub)=="table" then
   return iter2_2,{tbl,sub},1
  end
  if sub~=nil then
   return iter2_1,{tbl,sub},1
  else
   return ipairs(tbl)
  end
 end
 if type(sub)=="table" then
  if tbl~=nil then
   return iter2_1r,{tbl,sub},1
  end
 end
 if tbl~=nil or sub~=nil then
  return iter2_0,{tbl,sub}
 end
 return hc.empty_f
end
---
--- Like `ipairs`, but won't iterate nil,
--- return nil as key and the input itself as value if it's not a table.
---@generic T: any, V
---@param any T
---@return fun(any:V[],i?:integer):integer,V
---@return T?
---@return integer?
function hc.pipairs(any)
 if any==nil then
  return hc.empty_f
 end
 if type(any)=="table" then
  return ipairs(any)
 end
 return self_iter,any
end
---@generic K,V
---@param state {[1]:table<K,V>,[2]:K[],[3]:integer}
---@return integer?,K?,V?
local function range_iter(state,index)
 local k=state[2][index]
 if k~=nil then
  local v=state[1][k]
  return index+1,k,v
 end
end
---
--- Iterate the key and value of `tbl` in the key list of `range`.
---@generic K, V
---@param tbl table<K,V>
---@param range K[]
---@return fun(t:{[1]:table<K,V>,[2]:any[],[3]:integer}):K, V
---@return {[1]:table<K,V>,[2]:any[]}
---@return 1
function hc.rpairs(tbl,range)
 return range_iter,{tbl,range},1
end
---@generic K,V
---@param state {[1]:table<K,V>,[2]:K[]}
---@return integer?,K?,V?
local function prange_iter(state,index)
 local k=state[2][index]
 if k~=nil then
  local v=state[1][k]
  if v~=nil then
   return index+1,k,v
  end
  return prange_iter(state,index+1)
 end
end
function hc.tinsert(t,v,time)
 for _=1,time do
  tbl_insert(t,v)
 end
end
---
--- Like rpairs but the value won't be nil,
--- Skip if key has nil value.
---@generic K, V
---@param tbl table<K,V>
---@param range K[]
---@return fun(t:{[1]:table<K,V>,[2]:any[],[3]:integer}):K, V
---@return {[1]:table<K,V>,[2]:any[]}
---@return 1
function hc.prpairs(tbl,range)
 return prange_iter,{tbl,range},1
end
---@generic T
---@param ... T
---@return fun():(integer?,T?)
function hc.vararg_iter(...)
 local args={...}
 local i,e=0,#args
 return function()
  if i<e then
   i=i+1
   return i,args[i]
  end
 end
end
---@generic K,V
---@param ... table<K,V>
---@return fun():(integer?,table?,K?,V?)
function hc.vartbl_iter(...)
 local tbls={...}
 local len=#tbls
 local i,t=1,tbls[1]
 local k,v
 return function()
  ::start::
  k,v=next(t,k)
  if k==nil then
   if i==len then
    return nil
   end
   i=i+1
   t=tbls[i]
   goto start
  end
  return i,t,k,v
 end
end
setmetatable(hc,{
 __newindex=hc.empty_f,
})
return hc
