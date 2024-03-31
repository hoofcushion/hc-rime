local M={}
M.translator={}
function M.translator.init(env)
 local ns=env.name_space
 local config=env.engine.schema.config
 env.syllable_len=config:get_string(ns.."/syllable_len")
 env.translator=Component.Translator(env.engine,"","script_translator@"..ns)
 local mem=Memory(env.engine,env.engine.schema)
 mem:memorize(function(commit)
  for _,dict in ipairs(commit:get()) do
   if utf8.len(dict.text)==1 then
    mem:update_userdict(dict,-2,"")
   end
  end
 end)
end
function M.translator.func(input,seg,env)
 local query=env.translator:query(input,seg)
 if query==nil then
  return
 end
 local incomplete_count=0
 local current_len=0
 local quality_factor
 for cand in query:iter() do
  current_len=utf8.len(cand.text) or 0
  if not quality_factor then
   quality_factor=math.abs(current_len*env.syllable_len-#input)-0.25
  end
  cand.quality=cand.quality-quality_factor/8
  if cand._end-cand._start~=current_len*env.syllable_len then
   if incomplete_count==3 then
    goto continue
   end
   if current_len<4 then
    cand.comment=cand.comment.."〔补〕"
   end
   incomplete_count=incomplete_count+1
  else
   incomplete_count=0
  end
  yield(cand)
  ::continue::
 end
end
return M
