--- 在用户词后添加 `*` 标记
local is_user={
 user_table=true,
 user_phrase=true,
}
---@type engine
local M={}
M.filter={
 func=function(input)
  for cand in input:iter() do
   local yield_cand=cand
   if cand.text==cand:get_genuine().text then
    if is_user[cand.type]==true then
     yield_cand=ShadowCandidate(cand,"","",cand.comment.."*")
    end
   end
   yield(yield_cand)
  end
 end,
}
return M
