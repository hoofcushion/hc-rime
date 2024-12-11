local utils=require("utils")
local base_map={
 H={num=16,expattern="[^A-Fa-f0-9]",pattern="A-Fa-f0-9",limit="10FFFF"},
 D={num=10,expattern="[^0-9]",pattern="0-9",limit="1114111"},
 O={num=8,expattern="[^0-7]",pattern="0-7",limit="4177777"},
 B={num=2,expattern="[^1-2]",pattern="1-2",limit="100001111111111111111"},
}
local function prompt(env,str)
 local comp=env.engine.context.composition
 if comp:empty() then
  return
 end
 local seg=comp:back()
 seg.prompt=seg.prompt..str
end
local is_base={
 ["H"]=true,
 ["D"]=true,
 ["O"]=true,
 ["B"]=true,
}
--- Must check before yield, otherwise, it will cause fcitx5 to crash
---@param code integer
local function unicode_valid(code)
 return (code<0x110000) and (code&0xfffff800~=0xd800)
end
--- Set default values
local H=std.class({
 default="H",
 max_candidate=100,
 prefix="",
 quality=0,
 tag="unicode",
 code_start=0,
})
local M={}
M.translator={}
function M.translator.init(env)
 local config=env.engine.schema.config
 local ns=env.name_space~="" and env.name_space or "unicode"
 H.default=config:get_string(ns.."/default")
 H.max_candidate=config:get_int(ns.."/max_candidate")
 H.prefix=config:get_string(ns.."/prefix")
 H.quality=config:get_double(ns.."/initial_quality")
 H.tag=config:get_string(ns.."/tag")
 H.code_start=#H.prefix+1
 function H.prompt(str)
  prompt(env," > "..str)
 end
 function H.yield(seg,text,preedit,comment)
  local cand=Candidate("unicode",seg.start,seg._end,text,comment)
  cand.preedit=preedit
  cand.quality=H.quality
  yield(cand)
 end
end
function M.translator.func(_,seg,env)
 if seg:has_tag(H.tag)==false then
  return
 end
 H.prompt("Unicode")
 ---@type string
 local code=env.engine.context.input:sub(H.code_start,seg.length)
 local base=code:sub(1,1)
 if is_base[base]==nil then
  base=H.default
 else
  code=code:sub(2)
 end
 local base_tab=base_map[base]
 H.prompt(""..base_tab.num.." - based")
 if is_base[code]==true or code=="" then
  H.prompt("Enter Unicode code: ")
  return
 end
 local s_code=code:match("[A-Fa-f0-9]+",#base+1)
 if s_code==nil then
  H.prompt("Invalid code")
  return
 elseif s_code:find(base_tab.expattern) then
  H.prompt("Unrecognized code base, expect:"..base_tab.pattern.."")
  return
 end
 local n_code=tonumber(s_code,base_tab.num)
 if n_code==nil then
  H.prompt("Invalid number")
  return
 elseif n_code>1114111 then
  H.prompt("Unicode out of range: "..base_tab.limit.."")
  return
 end
 local i,e=n_code,n_code+H.max_candidate-1
 if e>1114111 then e=1114111 end
 for index=i,e do
  local text=unicode_valid(index) and utf8.char(index) or "Invalid Unicode code"
  H.yield(seg,text,code,tostring(index))
 end
end
return M
