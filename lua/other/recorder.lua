local Utils <const> = require("utils")
local rangeMap <const> =
{
 {11904, 12031},
 {12032, 12255},
 {12272, 12287},
 {12544, 12591},
 {12704, 12735},
 {12736, 12783},
 {13312, 19903},
 {19968, 40959},
 {63744, 64223},
 {131072,173791},
 {173824,177983},
 {177984,178207},
 {178208,183983},
 {183984,191471},
 {194560,195103},
 {196608,201551},
 {201552,205743},
}
rangeMap.minimum=rangeMap[1][1]
rangeMap.maximun=rangeMap[#rangeMap][2]
local binarySearch <const> = function(rangeMap,uCode)
 local left,right=1,#rangeMap
 while left<=right do
  local mid <const> = (left+right)//2
  local range <const> = rangeMap[mid]
  local min <const> = range[1]
  local max <const> = range[2]
  if uCode>=min and uCode<=max then
   return true
  end
  if uCode<min then
   right=mid-1
  elseif uCode>max then
   left=mid+1
  end
 end
 return false
end
local isPureChinese <const> = function(str)
 for i=1,utf8.len(str) do
  local uCode=utf8.codepoint(Utils.utf8_sub(str,i,i))
  if
  uCode<=rangeMap.minimum or
  uCode>=rangeMap.maximun or
  not binarySearch(rangeMap,uCode)
  then
   return false
  end
 end
 return true
end
local saveRecord <const> = function(lct,path)
 local file=io.open(path,"r") or io.open(path,"w"):close() and io.open(path,"r")
 if not file then
  return
 end
 local lines={[0]=lct.."\t1"}
 for line in file:lines() do
  local v=string.match(line,"^"..lct.."\t(%d+)$")
  if v then
   lines[0]=lct.."\t"..tostring(1+tonumber(v))
  else
   table.insert(lines,line)
  end
 end
 file:close()
 file=io.open(path,"w")
 for i=0,#lines do
  file:write(lines[i].."\n")
 end
 file:close()
end
local filenamelist <const> = {}
do
 table.insert(filenamelist,Utils.rime_file_exist("recorder/recorder_characters.txt"))
 table.insert(filenamelist,Utils.rime_file_exist("recorder/recorder_words.txt"))
 table.insert(filenamelist,Utils.rime_file_exist("recorder/recorder_others.txt"))
end
local commit_notifier
local M <const> = {}
function M.init(env)
 commit_notifier=env.engine.context.commit_notifier:connect(function(ctx)
  local lct=ctx:get_commit_text()
  if isPureChinese(lct) then
   if utf8.len(lct)==1 then
    saveRecord(lct,filenamelist[1])
   else
    saveRecord(lct,filenamelist[2])
   end
  else
   saveRecord(lct,filenamelist[3])
  end
 end)
end
function M.func()
 return 2
end
function M.fini()
 commit_notifier:disconnect()
end
return M