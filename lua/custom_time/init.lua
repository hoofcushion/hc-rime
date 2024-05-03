local reverse={}
local dict=require("custom_time.dict")
for _,entry in ipairs(dict) do
 for _,code in ipairs(entry.codes) do
  if reverse[code]==nil then
   reverse[code]={}
  end
  table.insert(reverse[code],entry)
 end
end
local M={}
M.translator={}
function M.translator.init(env)
 local config=env.engine.schema.config
 local ns=env.name_space~="" and env.name_space or "custom_time"
 env.quality=config:get_double(ns.."/initial_quality") or 0
 function env.yield(text,comment,seg)
  local cand=Candidate(ns,seg.start,seg._end,text,comment)
  cand.quality=env.quality
  yield(cand)
 end
end
function M.translator.func(input,seg,env)
 local entries=reverse[input]
 if entries==nil then
  return
 end
 for _,entry in ipairs(entries) do
  for _,item in ipairs(entry) do
   local text   =item.text()
   local comment=item.comment or entry.comment
   env.yield(text,comment,seg)
  end
 end
end
return M
