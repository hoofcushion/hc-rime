----- 降低非完全匹配候选词的优先级
local M={}
M.translator={}
function M.translator.init(env)
 local ns=env.name_space
 local config=env.engine.schema.config
 env.syllable_len=config:get_int(ns.."/syllable_len")
 env.translator=Component.Translator(env.engine,"","script_translator@"..ns)
end
function M.translator.func(input,seg,env)
 local query=env.translator:query(input,seg)
 if query==nil then
  return
 end
 local current_len=0
 local quality_factor
 for cand in query:iter() do
  current_len=utf8.len(cand.text) or 0
  if not quality_factor then
   local mismatch=math.abs(current_len*env.syllable_len-#input)
   quality_factor=math.max(0,1-mismatch/8)
  end
  cand.quality=cand.quality*quality_factor
  yield(cand)
 end
end
return M
