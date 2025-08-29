--- 禁用单字记录词频
local coderange=require("commit-recorder.coderange_list")
---@type engine
local M={}
M.filter={
 func=function(input)
  for cand in input:iter() do
   if cand:get_genuine():get_dynamic_type()=="Phrase" then
    if utf8.len(cand.text)==1 and coderange.is_chinese(utf8.codepoint(cand.text)) then
     local _cand=Candidate(cand.type,cand._start,cand._end,cand.text,cand.comment)
     _cand.quality=cand.quality
     _cand.preedit=cand.preedit
     cand=_cand
    end
   end
   yield(cand)
  end
 end,
}
return M
