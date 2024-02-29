local Utils <const> = require("utils")
local M <const> = {}
local default_opts <const> = {
 syllableLength=2,
}
function M.setup(user_opts)
 local opts <const> = Utils.table_extend(default_opts,user_opts)
 local T <const> = {}
 local Translator
 T.init=function(env)
  Translator=Component.Translator(env.engine,"","script_translator@"..env.name_space)
 end
 T.func=function(input,seg,env)
  local query <const> = Translator:query(input,seg)
  if not query then
   return
  end
  local incomplete_count=0
  local prev_len,current_len,dup_len_count=0,0,1
  local quality_factor
  for cand in query:iter() do
   current_len=utf8.len(cand.text) or 0
   if not quality_factor then
    quality_factor=math.abs(current_len*opts.syllableLength-#input)-0.25
   end
   cand.quality=cand.quality-quality_factor/8
   if current_len==1 then
    dup_len_count=1
    incomplete_count=0
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
   if cand._end-cand._start~=current_len*opts.syllableLength then
    if incomplete_count==3 then
     goto next
    end
    if current_len<4 then
     cand.comment=cand.comment.."〔补〕"
    end
    incomplete_count=incomplete_count+1
   else
    incomplete_count=0
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
 return T
end
return M