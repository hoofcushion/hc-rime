local M={
 init=function(env)
  env.translator=Component.Translator(env.engine,"","script_translator@"..env.name_space)
 end,
 func=function(input,seg,env)
  local query=env.translator:query(input,seg)
  if query==nil then
   return
  end
  for cand in query:iter() --[[@as fun():Candidate]] do
   local text=cand.comment
   if cand.type=="sentence" then
    cand.comment=""
   else
    cand.comment=cand.text:sub(1,-2)
   end
   yield(ShadowCandidate(cand,"fancha",text))
  end
 end,
}
return M
