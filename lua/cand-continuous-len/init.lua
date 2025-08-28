--- 用于过滤重复长度的候选词，防止大量重码候选词影响输入体验。

---@type engine
local M={}
local H={}
M.filter={
 init=function(env)
  H.limit=tonumber(env.name_space) or 6
 end,
 func=function(input)
  local last,cur,dup_count=0,0,1
  for cand in input:iter() do
   local genuine_text=cand:get_genuine().text
   --- skip for ShadowCandidate
   if cand.text~=genuine_text then
    goto yield
   end
   cur=utf8.len(genuine_text) --[[@as integer]]
   --- skip for single character
   if cur==1 then
    goto yield
   end
   if cur==last then
    if dup_count>=H.limit then
     goto continue
    end
    dup_count=dup_count+1
   else
    dup_count=1
   end
   last=cur
   ::yield::
   yield(cand)
   ::continue::
  end
 end,
}
return M
