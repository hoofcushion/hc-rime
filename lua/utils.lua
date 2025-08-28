local M={}
---@generic T:table|function
---@param ... T
---@return T
function M.extend(...)
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
      new[k]=M.extend(nv,v)
     end
    end
   end
  else
   new=t
  end
 end
 return new
end
M.rime_path={
 user=rime_api:get_user_data_dir(),
 data=rime_api:get_shared_data_dir(),
}
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
  std.fs.path_connect(M.rime_path.user,filename),
  std.fs.path_connect(M.rime_path.data,filename)
 )
 if ret==nil then
  error("could not find "..filename)
 end
 return ret
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
return M
