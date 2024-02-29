local Utils <const> = require("utils")
local symbol
local code_start
local baseMap <const> =
{
 H={num=16,expattern="[^a-f0-9]",pattern="0-9a-f",limit="10FFFF"},
 D={num=10,expattern="[^0-9]",pattern="0-9",limit="1114111"},
 O={num=8,expattern="[^0-7]",pattern="0-7",limit="4177777"},
 B={num=2,expattern="[^1-2]",pattern="1-2",limit="100001111111111111111"},
}
local M <const> = {}
function M.init(env)
 symbol=env.engine.schema.config:get_string("recognizer/lua/unicode")
 code_start=#symbol+1
end
function M.func(_,seg,env)
 if not seg:has_tag("unicode") then
  return
 end
 local tip="〔Unicode〕"
 local code <const> = env.engine.context.input:sub(code_start,seg.length)
 if code=="" then
  Utils.tipsEnv(env,tip.."〔请输入编码〕",true)
  return
 end
 local baseTab <const> = baseMap[code:match("([HDOB])") or "H"]
 tip=tip.."〔"..baseTab.num.." 进制〕"
 local sCode=code:match("[a-f0-9]+")
 if not sCode then
  Utils.tipsEnv(env,tip.."〔编码错误〕",true)
  return
 elseif sCode:find(baseTab.expattern) then
  Utils.tipsEnv(env,tip.."〔超出进制范围: "..baseTab.pattern.."〕",true)
  return
 end
 local nCode <const> = tonumber(sCode,baseTab.num)
 if not nCode then
  Utils.tipsEnv(env,tip.."〔数值错误〕",true)
  return
 elseif nCode>1114111 then
  Utils.tipsEnv(env,tip.."〔超出数值范围: "..baseTab.limit.."〕",true)
  return
 end
 for i=0,9 do
  local iConde <const> = nCode+i
  if iConde>1114111 then
   break
  end
  local cand <const> = Candidate("unicode",seg.start,seg._end,utf8.char(iConde),iConde)
  cand.preedit=code
  yield(cand)
 end
 Utils.tipsEnv(env,tip,true)
end
return M