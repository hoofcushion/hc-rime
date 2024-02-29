local Utils <const> = require("utils")
local strUincode <const> = function(str)
 local result={}
 for i=1,utf8.len(str) do
  table.insert(result,string.format("0x%x",utf8.codepoint(Utils.utf8_sub(str,i,i))))
 end
 return table.concat(result," ")
end
local option_name
local filter <const> =
{
 init=function(env)
  local name <const> = env.name_space:match("^%*?(.*)$")
  option_name=env.engine.schema.config:get_string(name.."/option_name") or name
 end,
 tags_match=function(seg,env)
  return env.engine.context:get_option(option_name)
 end,
 func=function(input)
  for cand in input:iter() do
   cand:get_genuine().preedit=strUincode(cand.preedit)
   yield(ShadowCandidate(cand,cand.type,strUincode(cand.text),strUincode(cand.comment)))
  end
 end,
}
return filter