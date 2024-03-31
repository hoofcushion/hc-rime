---@param path string
---@param mode openmode
---@return file*
local function popen(path,mode)
 local file=io.open(path,mode)
 if file==nil then
  error("file: "..path.." not found")
 end
 return file
end
local function is_line_exist(dir,str)
 local file=popen(dir,"r")
 for line in file:lines() do
  if line==str then
   file:close()
   return true
  end
 end
 file:close()
 return false
end
local function escape(str)
 return string.gsub(str,"([%^%%%%[%]%-$().*+?])","%%%1")
end
local function save_dict(dir,unconfirm)
 local existed=is_line_exist(dir,unconfirm)
 if existed then
  local file=popen(dir,"r")
  local content=file:read("a")
  file:close()
  content=string.gsub(content,"\n"..escape(unconfirm),"")
  popen(dir,"w"):write(content):close()
  return "deleted"
 end
 popen(dir,"a"):write(unconfirm):write("\n"):close()
 return "saved"
end
local M={}
M.translator={}
function M.translator.init(env)
 local Utils=require"utils"
 local config=env.engine.schema.config
 local ns=env.name_space
 env.suffix=config:get_string(ns.."/suffix") or "-="
 env.delimiter=config:get_string(ns.."/delimiter") or "|"
 env.pattern=escape(env.suffix).."$"
 env.quality=config:get_double(ns.."/initial_quality") or 0
 env.user_dict=Utils.rime_file_exist((config:get_string(ns.."/user_dict") or "custom_word")..".txt")
 function env.yield(text,comment,seg)
  local cand=Candidate("custom_word",seg.start,seg._end,text,comment)
  cand.quality=env.quality
  yield(cand)
 end
end
function M.translator.func(input,seg,env)
 if input:find(env.pattern)~=nil then
  local inp=input
   :gsub(env.pattern," ")
   :gsub(env.delimiter," ")
  local code=string.gsub(inp,"[^%a]+",""):lower()
  local unconfirm=inp.."\t"..code.."\t"..env.quality
  local comment=save_dict(env.user_dict,unconfirm)
  env.yield(inp,"",seg)
  env.yield("^",comment,seg)
  env.yield("v",unconfirm,seg)
 end
end
return M
