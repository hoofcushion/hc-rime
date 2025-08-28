local function por(a,b)
 return a~=nil and a or b
end
local H={}
local M={}
M.processor={}
function M.processor.init(env)
 local config=env.engine.schema.config
 local ns=env.name_space
 H.prefix=por(config:get_string(ns.."/prefix"),"`")
 H.trigger=por(config:get_string(ns.."/trigger"),"`")
 H.tag=por(config:get_string(ns.."/tag"),ns)
 H.alphabet=config:get_string("speller/alphabet")
 H.pattern="[^"..std.str.escape_in_brace(H.alphabet).."]"
end
function M.processor.func(key,env)
 local ctx=env.engine.context
 if ctx:has_menu()==false then
  return 2
 end
 if key:repr()~=H.trigger then
  return 2
 end
 local seg=ctx.composition:back()
 if seg:has_tag(H.tag)==false then
  return 2
 end
 local cand=ctx:get_selected_candidate()
 if cand.type~="fancha" then
  return 2
 end
 local input=ctx.input
 local result=cand.text:gsub(H.pattern,""):lower()
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
