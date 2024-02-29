local Translator
local M <const> = {}
function M.init(env)
 Translator=Component.Translator(env.engine,"","script_translator@"..env.name_space)
end
function M.func(input,seg)
 local query <const> = Translator:query(input,seg)
 if not query then
  return
 end
 for cand in query:iter() do
  if cand.type=="sentence" then
   return
  end
  cand.comment="『混输』"
  yield(cand)
 end
end
return M