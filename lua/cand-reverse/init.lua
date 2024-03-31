local Utils=require("utils")
local function utf8_reverse(str)
 local result={}
 for i=utf8.len(str),1,-1 do
  local char <const> = Utils.utf8_sub(str,i,i)
  table.insert(result,char)
 end
 return table.concat(result,"")
end
---@type engine
local M={}
M.filter={
 init=function(env)
  env.option_name=env.engine.schema.config:get_string(env.name_space.."/option_name")
 end,
 func=function(input)
  for cand in input:iter() do
   cand:get_genuine().preedit=utf8_reverse(cand.preedit)
   yield(ShadowCandidate(cand,cand.type,utf8_reverse(cand.text),utf8_reverse(cand.comment)))
  end
 end,
 tags_match=function(_,env)
  return env.engine.context:get_option(env.option_name)
 end,
}
return M
