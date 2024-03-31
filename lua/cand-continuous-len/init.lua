---@type engine
local M={}
M.filter={
 init=function(env)
  -- 0 based
  env.limit=(tonumber(env.name_space) or 6)-1
 end,
 func=function(input,env)
  local last_len,cur_len,dup_len=0,0,0
  local last_text,cur_text="",""
  local blocked_text=""
  for cand in input:iter() do
   cur_text=cand:get_genuine().text
   if cur_text==blocked_text then
    goto continue
   end
   if cur_text==last_text then
    goto yield
   else
    last_text=cur_text
   end
   cur_len=utf8.len(cand.text) --[[@as integer]]
   if cur_len==1 then
    goto yield
   end
   if cur_len==last_len then
    if dup_len==env.limit then
     goto continue
    end
    dup_len=dup_len+1
   else
    dup_len=0
   end
   last_len=cur_len
   ::yield::
   yield(cand)
   ::continue::
  end
 end
}
return M
