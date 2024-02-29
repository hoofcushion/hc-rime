local Utils <const> = require("utils")
local M <const> = {}
local Translator
local symbol
local code_start
local comment <const> = "『符号』"
function M.init(env)
 symbol=env.engine.schema.config:get_string("recognizer/lua/"..env.name_space)
 code_start=#symbol+1
 Translator=Component.Translator(env.engine,"","table_translator@"..env.name_space)
end
function M.func(input,seg,env)
 if not seg:has_tag(env.name_space) then
  return
 end
 Utils.tipsEnv(env,"〔符号输出〕",true)
 local code <const> = input:sub(code_start)
 if code=="" then
  return
 end
 local query <const> = Translator:query(code,seg)
 if not query then
  return
 end
 for cand in query:iter() do
  cand.comment=comment
  cand._end=seg._end
  yield(cand)
 end
end
return M