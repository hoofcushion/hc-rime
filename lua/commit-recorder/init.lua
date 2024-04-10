local Utils=require("utils")
local coderange=require("commit-recorder.coderange_list")
local function bs_inrange(code)
 if code<=coderange.minimum
 or code>=coderange.maximum then
  return false
 end
 local left,right=1,#coderange
 while left<=right do
  local mid=(left+right)//2
  local range=coderange[mid]
  local min=range[1]
  local max=range[2]
  if code>=min and code<=max then
   return true
  end
  if code<min then
   right=mid-1
  elseif code>max then
   left=mid+1
  end
 end
 return false
end
local function is_all_han(str)
 for i=1,utf8.len(str) do
  local char=Utils.utf8_sub(str,i,i)
  local code=utf8.codepoint(char)
  if bs_inrange(code)==false then
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
 char=Utils.rime_file_exist("recorder/char.txt"),
 word=Utils.rime_file_exist("recorder/word.txt"),
 other=Utils.rime_file_exist("recorder/other.txt"),
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
M.processor={}
function M.processor.init(env)
 env.commit_notifier=env.engine.context.commit_notifier:connect(callback)
end
function M.processor.func()
 return 2
end
function M.processor.fini(env)
 env.commit_notifier:disconnect()
end
return M
