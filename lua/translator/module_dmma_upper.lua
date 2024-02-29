local Translator
local M <const> = {}
function M.init(env)
 Translator=Component.Translator(env.engine,"","script_translator@"..env.name_space)
end
function M.func(input,seg)
 if not input:find("[A-Z]") then
  return
 end
 local query <const> = Translator:query(input:lower(),seg)
 if not query then
  return
 end
 for cand in query:iter() do
  cand.comment="「"..cand.comment:sub(-3,-2):upper().."」"
  yield(cand)
 end
end
return M