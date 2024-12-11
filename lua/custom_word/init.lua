local function is_line_exist(dir,str)
 local file=std.io.open(dir,"r")
 local defer <close> = std.mt.close(function()
  file:close()
 end)
 for line in file:lines() do
  if line==str then
   return true
  end
 end
 return false
end
local function save_dict(dir,unconfirm)
 local existed=is_line_exist(dir,unconfirm)
 if not existed then
  std.io.open(dir,"a"):write(unconfirm):write("\n"):close()
  return "saved"
 end
 local file=std.io.open(dir,"r")
 local lines={}
 for line in file:lines() do
  if line~=unconfirm then
   table.insert(lines,line)
  end
 end
 local content=table.concat(lines,"\n")
 file:close()
 std.io.open(dir,"w"):write(content):close()
 return "deleted"
end
local M={}
local H={}
M.translator={}
function M.translator.init(env)
 local Utils=require("utils")
 local config=env.engine.schema.config
 local ns=env.name_space
 H={}
 H.suffix=config:get_string(ns.."/suffix") or "-="
 H.delimiter=config:get_string(ns.."/delimiter") or "|"
 H.quality=config:get_double(ns.."/initial_quality") or 0
 H.user_dict=Utils.rime_file_exist((config:get_string(ns.."/user_dict") or "custom_word")..".txt")
 function H.yield(text,comment,seg)
  local cand=Candidate("custom_word",seg.start,seg._end,text,comment)
  cand.quality=H.quality
  yield(cand)
 end
end
function M.translator.func(input,seg)
 if std.str.endswith(input,H.suffix) then
  local inp=input
   :sub(1,- #H.suffix)
   :gsub(H.delimiter," ")
  local code=string.gsub(inp,"[^%a]+",""):lower()
  local unconfirm=inp.."\t"..code.."\t"..H.quality
  local comment=save_dict(H.user_dict,unconfirm)
  H.yield(inp,"",seg)
  H.yield("^",comment,seg)
  H.yield("v",unconfirm,seg)
 end
end
return M
