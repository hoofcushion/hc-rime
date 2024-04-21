local Time_Table={}
local Reverse={}
local inputTable=require("custom_time.dict")
for index,entry in ipairs(inputTable) do
 table.insert(Time_Table,entry)
 for _,code in ipairs(entry.codes) do
  if Reverse[code]==nil then
   Reverse[code]={}
  end
  table.insert(Reverse[code],index)
 end
end
local M={}
M.translator={}
function M.translator.init(env)
end
function M.translator.func(input,seg,env)
 if Reverse[input]==nil then
  return
 end
 for _,index in ipairs(Reverse[input]) do
  local entry=Time_Table[index]
  for _,item in ipairs(entry) do
   local text   =item.text()
   local comment=item.comment or entry.comment
   local cand   =Candidate("time",seg.start,seg._end,text,comment)
   cand.quality =8102
   yield(cand)
  end
 end
end
return M
