local Utils <const> = require("utils")
local M <const> = {}
local Translator
M.init=function(env)
 Translator=Component.Translator(env.engine,"","script_translator@"..env.name_space)
end
M.func=function(input,seg)
 local query <const> = Translator:query(input,seg)
 if not query then
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
  if  current_len==1
  and cand._start==seg._start
  then
   cand=Utils.toSimpleCand(cand)
  end
  yield(cand)
  ::next::
 end
end
return M