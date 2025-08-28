local M={}
local function file_exists(filename)
 local file=io.open(filename,"r")
 if file then
  file:close()
  return true
 end
 return false
end

local function find_file_in_paths(filename,paths)
 for _,path in ipairs(paths) do
  local full_path=std.fs.path_connect(path,filename)
  if file_exists(full_path) then
   return full_path
  end
 end
 return nil
end

local rime_paths={
 rime_api:get_user_data_dir(),
 rime_api:get_shared_data_dir(),
}
---@return string
function M.check_file(filename)
 local path=find_file_in_paths(filename,rime_paths)
 if not path then
  error("Could not find file: "..filename)
 end
 return path
end
---@param str string
---@param replace boolean?
function M.prompt(env,str,replace)
 local comp=env.engine.context.composition
 if comp:empty() then
  return
 end
 local seg=comp:back()
 seg.prompt=replace and str or (seg.prompt..str)
end
return M
