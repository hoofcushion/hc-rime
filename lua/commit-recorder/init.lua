local Utils=require("utils")
local coderange=require("commit-recorder.coderange_list")
local function is_all_han(str)
 for i=1,utf8.len(str) do
  local char=std.utf8.sub(str,i,i)
  local code=utf8.codepoint(char)
  if coderange.is_chinese(code)==false then
   return false
  end
 end
 return true
end
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
local function escape(str)
 return string.gsub(str,"([%^%%%[%]%-$().*+?])","%%%1")
end
local function save(str,path)
 local lines={[1]=str.."\t1"}
 local file=popen(path,"r")
 local pattern="^"..escape(str).."\t(%d+)$"
 for line in file:lines() do
  local v=string.match(line,pattern)
  if v~=nil then
   lines[1]=str.."\t"..tostring(1+tonumber(v))
  else
   table.insert(lines,line)
  end
 end
 file:close()
 file=popen(path,"w")
 for i=1,#lines do
  file:write(lines[i].."\n")
 end
 file:close()
end
local PATHS={
 char=Utils.check_file("recorder/char.txt"),
 word=Utils.check_file("recorder/word.txt"),
 other=Utils.check_file("recorder/other.txt"),
}
local function callback(ctx)
 local commit_text=ctx:get_commit_text()
 local path
 if is_all_han(commit_text) then
  if utf8.len(commit_text)==1 then
   path=PATHS.char
  else
   path=PATHS.word
  end
 else
  path=PATHS.other
 end
 save(commit_text,path)
end
local M={}
local H={}
M.processor={}
function M.processor.init(env)
 H.commit_notifier=env.engine.context.commit_notifier:connect(callback)
end
function M.processor.func()
 return 2
end
function M.processor.fini()
 H.commit_notifier:disconnect()
end
return M
