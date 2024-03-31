local function prompt_connect(env,str)
 local comp=env.engine.context.composition
 if comp:empty() then
  return
 end
 local seg=comp:back()
 seg.prompt=seg.prompt..str
end
local function por(a,b)
 return a~=nil and a or b
end
local M={}
M.translator={}
function M.translator.init(env)
 local config=env.engine.schema.config
 local ns=env.name_space~="" and env.name_space or "custom_symbol"
 env.prefix=por(config:get_string(ns.."/prefix"),"\\")
 env.tag=por(config:get_string(ns.."/tag"),ns)
 env.tips=por(config:get_string(ns.."/tips")," [Symbol]")
 env.comment=por(config:get_string(ns.."/comment"),"[Symbol]")
 env.translator=Component.Translator(env.engine,"","table_translator@"..ns)
 env.code_start=#env.prefix+1
 function env.yield(cand,seg)
  cand.type=ns
  cand.comment=env.comment
  cand.start=seg.start
  cand._end=cand._end+env.code_start
  yield(cand)
 end
end
function M.translator.func(input,seg,env)
 if seg:has_tag(env.tag)==false then
  return
 end
 prompt_connect(env,env.tips)
 local code=input:sub(env.code_start)
 if code=="" then
  return
 end
 local query=env.translator:query(code,seg)
 if query==nil then
  return
 end
 for cand in query:iter() do
  env.yield(cand,seg)
 end
end
return M
