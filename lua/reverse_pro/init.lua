local function por(a,b)
 return a~=nil and a or b
end
local M={}
M.processor={}
function M.processor.init(env)
 local config=env.engine.schema.config
 local ns=env.name_space
 env.prefix=por(config:get_string(ns.."/prefix"),"`")
 env.trigger=por(config:get_string(ns.."/trigger"),"`")
 env.tag=por(config:get_string(ns.."/tag"),ns)
end
function M.processor.func(key,env)
 local ctx=env.engine.context
 if ctx:has_menu()==false then
  return 2
 end
 if key:repr()~=env.trigger then
  return 2
 end
 local seg=ctx.composition:back()
 if seg:has_tag(env.tag)==false then
  return 2
 end
 local cand=ctx:get_selected_candidate()
 if cand.type~="fancha" then
  return 2
 end
 local input=ctx.input
 local result=cand.text:gsub("[^%a]",""):lower()
 local pos
 if cand._start>1 then
  result=string.sub(input,1,cand._start-1)..result
  pos=#result
 end
 if cand._end<#input then
  result=result..string.sub(input,cand._end)
 end
 ctx.input=result
 if pos~=nil then
  ctx.caret_pos=pos
 end
 return 1
end
return M
