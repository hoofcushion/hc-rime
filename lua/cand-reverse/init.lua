--- 文字反转滤镜
local function utf8_reverse(str)
 local result={}
 local i=utf8.len(str) --[[@as integer]]
 for _,code in utf8.codes(str) do
  result[i]=utf8.char(code)
  i=i-1
 end
 return table.concat(result,"")
end
---@type engine
local M={}
M.filter={
 init=function(env)
  local config=env.engine.schema.config
  local ns=env.name_space
  env.option_name=config:get_string(ns.."/option_name")
 end,
 func=function(input)
  for cand in input:iter() do
   cand:get_genuine().preedit=utf8_reverse(cand.preedit)
   local shadow=ShadowCandidate(
    cand,
    "",
    utf8_reverse(cand.text),
    utf8_reverse(cand.comment)
   )
   yield(shadow)
  end
 end,
 tags_match=function(_,env)
  return env.engine.context:get_option(env.option_name)
 end,
}
return M
