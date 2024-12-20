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
 local prev_len,current_len,dup_len_count=0,0,1
 for cand in query:iter() do
  current_len=utf8.len(cand.text) or 0
  if current_len==1 then
   dup_len_count=1
   goto yield
  end
  if current_len==prev_len then
   if dup_len_count==12 then
    goto next
   end
   dup_len_count=dup_len_count+1
  else
   prev_len=current_len
   dup_len_count=1
  end
  ::yield::
  yield(cand)
  ::next::
 end
end
return M
