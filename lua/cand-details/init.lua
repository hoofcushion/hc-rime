local is_user={
 user_table=true,
 user_phrase=true,
}
---@type engine
local M={}
M.filter={
 func=function(input)
  for cand in input:iter() do
   if cand.text==cand:get_genuine().text then
    if is_user[cand.type]==true then
     cand=ShadowCandidate(cand,"","",cand.comment.."*")
    end
   end
   yield(cand)
  end
 end,
}
return M
