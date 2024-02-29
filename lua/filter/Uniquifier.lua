local M <const> = {}
local function add_comment(cand)
 if cand:get_dynamic_type()=="Phrase" then
  cand.comment=cand.comment.."!"
 end
 if cand.type:find("user") then
  cand.comment=cand.comment.."*"
 end
end
function M.func(input)
 local cands={}
 local reverse={}
 for cand in input:iter() do
  local text <const> = cand.text
  if cands[text] then
   if cands[text].comment=="" then
    cands[text].comment=cand.comment
   end
  else
   add_comment(cand)
   cands[text]=cand
   table.insert(reverse,text)
  end
 end
 for _,index in ipairs(reverse) do
  yield(cands[index])
 end
end
return M