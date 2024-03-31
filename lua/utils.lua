local M={}
Sep=string.sub(package.config,1,1)
local user=rime_api:get_user_data_dir()
local data=rime_api:get_shared_data_dir()
local function popen(filename,mode)
 local file=io.open(filename,mode)
 if file==nil then error("No file: "..filename) end
 return file
end
local function check_file(filename)
 local file=io.open(filename,"r")
 if file==nil then return false end
 file:close()
 return filename
end
local userS=user..Sep
local dataS=data..Sep
---@return string
function M.rime_file_exist(filename)
 return check_file(userS..filename) or check_file(dataS..filename) or error("could not find "..filename)
end
---@param filename string
---@return file*
function M.rime_file_open(filename,mode)
 ---@type file*
 return popen(M.rime_file_exist(filename),mode)
end
function M.tipsEnv(env,str,add)
 M.tipsCtx(env.engine.context,str,add)
end
function M.tipsCtx(ctx,str,add)
 local comp=ctx.composition
 if comp:empty() then
  return
 end
 local seg=comp:back()
 if add then
  seg.prompt=seg.prompt..str
 else
  seg.prompt=str
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
M.deepcopy=deepcopy
local function deepnext(tbl,key)
 local k,v=next(tbl,key)
 return deepcopy(k),deepcopy(v)
end
M.deepnext=deepnext
local function deeppairs(tbl)
 return deepnext,tbl
end
M.deeppairs=deeppairs
---@enum (key) tbl_extend_mode
local tbl_extend_mode_enum={
 ["force"]=true,
 ["keep"]=true,
 ["error"]=true,
}
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
---@generic Main
---@param mode tbl_extend_mode
---@param ... Main
---@return Main
function M.tbl_extend(mode,...)
 if M.type_all("table",...) then
  error("expect all table for vararg")
 end
 if mode==nil or tbl_extend_mode_enum[mode]==nil then
  error("bad arg #2")
 end
 local len=select("#",...)
 if len==1 then
  error("too few vararg input, at least 2")
 end
 local main={}
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
---@generic Main
---@param mode tbl_extend_mode
---@param ... Main
---@return Main
function M.tbl_deep_extend(mode,...)
 if M.type_all("table",...) then
  error("expect all table for vararg")
 end
 if mode==nil or tbl_extend_mode_enum[mode]==nil then
  error("bad arg #2")
 end
 local len=select("#",...)
 if len==1 then
  error("too few vararg input, at least 2")
 end
 local main={}
 if mode=="force" then
  for i=1,len do
   for k,v in deeppairs(select(i,...)) do
    if M.type_all("table",main[k],v) then
     main[k]=M.tbl_deep_extend(mode,main[k],v)
    else
     main[k]=v
    end
   end
  end
 elseif mode=="keep" then
  for i=1,len do
   for k,v in deeppairs(select(i,...)) do
    if M.type_all("table",main[k],v) then
     main[k]=M.tbl_deep_extend(mode,main[k],v)
    elseif main[k]~=nil then
     main[k]=v
    end
   end
  end
 elseif mode=="error" then
  for i=1,len do
   for k,v in deeppairs(select(i,...)) do
    if M.type_all("table",main[k],v) then
     main[k]=M.tbl_deep_extend(mode,main[k],v)
    elseif main[k]~=nil then
     error("New index already exsists in: "..tostring(main))
    else
     main[k]=v
    end
   end
  end
 end
 return main
end
return M
