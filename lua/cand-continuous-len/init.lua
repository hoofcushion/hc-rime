---@type engine
local M={}
M.filter={
 init=function(env)
  -- 0 based
  env.limit=tonumber(env.name_space) or 6
 end,
 func=function(input,env)
  local last_len,cur_len,dup_len=0,0,0
  for cand in input:iter() do
   cur_text=cand:get_genuine().text
   if cand.text~=cur_text then
    goto yield
   end
   cur_len=utf8.len(cur_text) --[[@as integer]]
   if cur_len==1 then
    goto yield
   end
   if cur_len==last_len then
    dup_len=dup_len+1
   else
    dup_len=0
   end
   if dup_len>=env.limit then
    goto continue
   end
   last_len=cur_len
   ::yield::
   yield(cand)
   ::continue::
  end
 end,
}
return M
