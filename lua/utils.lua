local M={}
local function err(msg,level)
 msg=msg.."\nTraceback: "..debug.traceback()
 error(msg,level)
end
---@param val any
---@param expect type|type[]|fun(val:any):boolean,string
function M.typecheck(val,expect)
 local t=type(expect)
 local ok,got
 if t=="function" then
  ok,got=expect(val)
 else
  got=type(val)
  if t=="table" then
   ok=M.tbl_find(expect,got)~=nil
  else
   ok=got==expect
  end
 end
 if ok==false then
  err("Expect "..M.serialize(expect)..", got "..got..": "..M.serialize(val))
 end
 return got
end
function M.tbl_find(tbl,val)
 for k,v in pairs(tbl) do
  if v==val then
   return k
  end
 end
end
---@generic T:any
---@param obj T
---@return T
function M.deepcopy(obj)
 local t=type(obj)
 if t~="table" then
  return obj
 end
 local ret={}
 for k,v in pairs(obj) do
  ret[M.deepcopy(k)]=M.deepcopy(v)
 end
 local mt=getmetatable(obj)
 if mt~=nil then
  setmetatable(ret,M.deepcopy(mt))
 end
 return ret
end
---@generic T:table|function
---@param ... T
---@return T
function M.tbl_extend(...)
 local new={}
 for i=1,select("#",...) do
  local t=select(i,...)
  local tp=M.typecheck(t,{"table","function"})
  if tp=="function" then
   t(new)
  else
   for k,v in pairs(t) do
    local ex=new[k]
    if type(ex)=="table" and type(v)=="table" then
     if M.is_list(ex) and M.is_list(v) then
      new[k]=M.list_extend(new[k],v)
     else
      new[k]=M.tbl_extend(new[k],v)
     end
    else
     new[M.deepcopy(k)]=M.deepcopy(v)
    end
   end
  end
 end
 return new
end
---@param ... any[]
function M.list_extend(...)
 local new={}
 for i=1,select("#",...) do
  local l=select(i,...)
  M.typecheck(l,"table")
  for _,v in ipairs(l) do
   table.insert(new,v)
  end
 end
 return new
end
M.os_sep=package.config:sub(1,1)
---@param ... string
function M.path_connect(...)
 return table.concat({...},M.os_sep)
end
M.rime_path={
 user=rime_api:get_user_data_dir(),
 data=rime_api:get_shared_data_dir(),
}
function M.protect(fn,errfn)
 return function(...)
  local ret=errfn(fn(...))
  return ret
 end
end
---@overload fun(filename:string,mode:openmode):file*
M.popen=
 M.protect(io.open,function(file,errmsg)
  if file==nil then error(errmsg) end
  return file
 end)
local function check_file(filename)
 local file=io.open(filename,"r")
 if file~=nil then
  file:close()
  return filename
 end
end
local function check_files(...)
 for i=1,select("#",...) do
  local filename=select(i,...)
  local ok=check_file(filename)
  if ok~=nil then
   return filename
  end
 end
end
---@return string
function M.rime_file_exist(filename)
 local ret=check_files(
  M.path_connect(M.rime_path.user,filename),
  M.path_connect(M.rime_path.data,filename)
 )
 if ret==nil then
  error("could not find "..filename)
 end
 return ret
end
---@param filename string
---@return file*
function M.rime_file_open(filename,mode)
 ---@type file*
 return M.popen(M.rime_file_exist(filename),mode)
end
---@param str string
---@param replace boolean?
function M.prompt(env,str,replace)
 local comp=env.engine.context.composition
 if comp:empty() then
  return
 end
 local seg=comp:back()
 if replace then
  seg.prompt=str
 else
  seg.prompt=seg.prompt..str
 end
end
---@param str string
---@param start integer
---@param final integer|nil
---@return string
function M.utf8_sub(str,start,final)
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
function M.toSimpleCand(cand)
 local ncand=Candidate(cand.type,cand.start,cand._end,cand.text,cand.comment)
 ncand.quality=cand.quality
 ncand.preedit=cand.preedit
 return ncand
end
---@enum (key) deepcopy_invalid_type
local deepcopy_invalid_type={
 ["userdata"]=true,
 ["thread"]=true,
}
---@generic I
---@param obj I
---@return I
local function deepcopy(obj)
 local t=type(obj)
 if deepcopy_invalid_type[t]==true then
  error("Cannot deepcopy type "..t)
 end
 if t~="table" then
  return obj
 end
 local copy={}
 for k,v in pairs(obj) do
  k=deepcopy(k)
  v=deepcopy(v)
  copy[k]=v
 end
 local mt=getmetatable(obj)
 if mt~=nil then
  setmetatable(copy,M.deepcopy(mt))
 end
 return copy
end
M.deepcopy=deepcopy
function M.type_eq(value,target)
 return type(value)==target
end
function M.type_all(target,...)
 for i=1,select("#",...) do
  if type(select(i,...))~=target then
   return false
  end
 end
 return true
end
function M.tbl_count(tbl)
 local count=0
 for _ in pairs(tbl) do
  count=count+1
 end
 return count
end
function M.is_list(tbl)
 return #tbl==M.tbl_count(tbl)
end
local is_address={
 ["function"]=true,
 ["userdata"]=true,
 ["thread"]=true,
}
---@param obj any
---@return string
function M.serialize(obj)
 local t=type(obj)
 if t~="table" then
  if t=="string" then
   return '"'..obj:gsub('(["\\])',"\\%1")..'"'
  end
  if is_address[t]==true then
   return '"'..tostring(obj)..'"'
  end
  return tostring(obj)
 end
 local ret=setmetatable({},{__index=table})
 if M.is_list(obj) then
  for _,v in ipairs(obj) do
   v=M.serialize(v)
   ret:insert(v)
  end
 else
  for k,v in pairs(obj) do
   if not (type(k)=="string" and k:find("^[%a_]+[%a%d_]*$")) then
    k=M.serialize(k)
    k="["..k.."]"
   end
   v=M.serialize(v)
   ret:insert(k.."="..v)
  end
  ret:sort()
 end
 return "{"..ret:concat(",").."}"
end
function M.por(a,b)
 return a~=nil and a or b
end
return M
