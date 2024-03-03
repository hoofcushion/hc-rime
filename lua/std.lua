local M={}
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
---@param main table
---@param mode tbl_extend_mode
---@param ... table
---@return table
function M.tbl_extend(main,mode,...)
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
---@param main table
---@param mode tbl_extend_mode
---@param ... table
---@return table
function M.tbl_deep_extend(main,mode,...)
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
M.os_sep=string.sub(package.config,1,1)
---@param tbl string|table
---@param ... string?
---@return string
function M.path_concat(tbl,...)
 if ...~=nil then
  tbl={tbl,...}
 end
 ---@cast tbl -string
 return table.concat(tbl,M.os_sep)
end
local user <const> = rime_api:get_user_data_dir()
local data <const> = rime_api:get_shared_data_dir()
function M.file_exist(filename)
 local file=io.open(filename,"r")
 if file then
  file:close()
  return filename
 end
end
M.user=user
M.data=data
---@param filename string
---@return string
function M.rime_file_exist(filename)
 return M.file_exist(M.path_concat(user,filename))
  or M.file_exist(M.path_concat(data,filename))
  or error("could not find "..filename)
end
---@param filename string
---@param mode openmode
---@return file*
function M.rime_file_open(filename,mode)
 return io.open(M.rime_file_exist(filename),mode)
end
return M
