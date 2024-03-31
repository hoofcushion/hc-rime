local Translator
local M={}
function M.init(env)
 Translator=Component.Translator(env.engine,"","script_translator@"..env.name_space)
end
function M.func(input,seg)
 local query=Translator:query(input,seg)
 if query==nil then
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