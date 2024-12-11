local H={}
local M={
 init=function(env)
  H.translator=Component.Translator(env.engine,"","script_translator@"..env.name_space)
 end,
 func=function(input,seg)
  local query=H.translator:query(input,seg)
  if query==nil then
   return
  end
  for cand in query:iter() --[[@as fun():Candidate]] do
   local text=cand.comment
   if cand.type=="sentence" then
    cand.comment=""
   else
    cand.comment=("[%s]"):format(cand.text:sub(1,-2))
   end
   yield(ShadowCandidate(cand,"fancha",text))
  end
 end,
}
return M
