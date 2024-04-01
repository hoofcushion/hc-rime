local Utils=require("utils")
local global_comment=""
local Time_Table,Reverse={},{}
do
 local inputTable=dofile(Utils.rime_file_exist("custom_time.txt"))
 for index,entry in ipairs(inputTable) do
  for _,item in ipairs(entry) do
   item.text=load("return "..item.text)
  end
  table.insert(Time_Table,entry)
  for _,code in ipairs(entry.codes) do
   if Reverse[code]==nil then
    Reverse[code]={}
   end
   table.insert(Reverse[code],index)
  end
 end
end
return function(input,seg,env)
 if Reverse[input]==nil then
  return
 end
 Utils.tipsEnv(env,"〔时间输出〕",true)
 for _,index in ipairs(Reverse[input]) do
  local entry=Time_Table[index]
  for _,item in ipairs(entry) do
   local text   =item.text()
   local comment=item.comment or entry.comment or global_comment
   local cand   =Candidate("time_cand",seg.start,seg._end,text,comment)
   cand.quality =8102
   yield(cand)
  end
 end
end
