local function tounicode(str)
 local result={}
 for i=1,utf8.len(str) do
  local char=std.utf8.sub(str,i,i)
  local code=string.format("0x%x",utf8.codepoint(char))
  table.insert(result,code)
 end
 return table.concat(result," ")
end
---@type engine
local M={}
M.filter={
 init=function(env)
  env.option_name=env.engine.schema.config:get_string(env.name_space.."/option_name")
 end,
 func=function(input)
  for cand in input:iter() do
   cand:get_genuine().preedit=tounicode(cand.preedit)
   local shadow=ShadowCandidate(
    cand,
    "",
    tounicode(cand.text),
    tounicode(cand.comment)
   )
   yield(shadow)
  end
 end,
 tags_match=function(_,env)
  return env.engine.context:get_option(env.option_name)
 end,
}
return M
