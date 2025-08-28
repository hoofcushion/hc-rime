local M={}
M.translator={}
function M.translator.init(env)
 local ns=env.name_space
 env.translator=Component.Translator(env.engine,"","script_translator@"..ns)
end
function M.translator.func(input,seg,env)
 local query=env.translator:query(input,seg)
 if query==nil then
  return
 end
 for cand in query:iter() do
  yield(cand)
 end
end
return M
