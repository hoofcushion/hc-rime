local M={}
local F={}
M.filter=F
---@class Translation
---@field iter fun(self):(fun(Translation):Candidate)
---@param input Translation
function F.func(input)
 ---@type table<string,Candidate>
 local cands={}
 ---@type table<integer,string>
 local reverse={}
 for cand in input:iter() do
  local text=cand.text
  if cands[text]~=nil then
   --- Replace the comment
   if cands[text].comment=="" and cand.comment~="" then
    cands[text]=cand
    cand:append(cands[text])
   else
    cands[text]:append(cand)
   end
  else
   cands[text]=cand
   table.insert(reverse,text)
  end
 end
 for _,text in ipairs(reverse) do
  yield(cands[text])
 end
 for cand in input:iter() do
  yield(cand)
 end
end
return M
