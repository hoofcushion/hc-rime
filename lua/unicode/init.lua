local baseMap={
 H={num=16,expattern="[^a-f0-9]",pattern="0-9a-f",limit="10FFFF"},
 D={num=10,expattern="[^0-9]",pattern="0-9",limit="1114111"},
 O={num=8,expattern="[^0-7]",pattern="0-7",limit="4177777"},
 B={num=2,expattern="[^1-2]",pattern="1-2",limit="100001111111111111111"},
}
local function prompt_connect(env,str)
 local comp=env.engine.context.composition
 if comp:empty() then
  return
 end
 local seg=comp:back()
 seg.prompt=seg.prompt..str
end
local is_empty_input={
 [""]=true,
 ["H"]=true,
 ["D"]=true,
 ["O"]=true,
 ["B"]=true,
}
local M={}
M.translator={}
function M.translator.init(env)
 local config=env.engine.schema.config
 local ns=env.name_space~="" and env.name_space or "unicode"
 env.tag=config:get_string(ns.."/tag") or ns
 env.prefix=config:get_string(ns.."/prefix") or ""
 env.quality=config:get_double(ns.."/initial_quality") or 0
 env.default=config:get_string(ns.."/default") or "H"
 env.code_start=#env.prefix+1
end
function M.translator.func(_,seg,env)
 if seg:has_tag(env.tag)==false then
  return
 end
 prompt_connect(env,"〔Unicode〕")
 local code=env.engine.context.input:sub(env.code_start,seg.length)
 if is_empty_input[code]==true then
  prompt_connect(env,"〔请输入编码〕")
  return
 end
 local baseTab=baseMap[code:match("([HDOB])") or env.default]
 prompt_connect(env,"〔"..baseTab.num.." 进制〕")
 local sCode=code:match("[a-f0-9]+")
 if sCode==nil then
  prompt_connect(env,"〔编码错误〕")
  return
 elseif sCode:find(baseTab.expattern) then
  prompt_connect(env,"〔超出进制范围: "..baseTab.pattern.."〕")
  return
 end
 local nCode=tonumber(sCode,baseTab.num)
 if nCode==nil then
  prompt_connect(env,"〔数值错误〕")
  return
 elseif nCode>1114111 then
  prompt_connect(env,"〔超出数值范围: "..baseTab.limit.."〕")
  return
 end
 for i=0,9 do
  local iConde=nCode+i
  if iConde>1114111 then
   break
  end
  local cand=Candidate("unicode",seg.start,seg._end,utf8.char(iConde),tostring(iConde))
  cand.preedit=code
  cand.quality=env.quality
  yield(cand)
 end
end
return M
