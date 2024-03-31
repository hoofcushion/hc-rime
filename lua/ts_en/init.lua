local function auto_uppercase(input,text)
 if input:find("^[A-Z][A-Z]") then
  return text:upper()
 end
 return text:gsub("^(.)",string.upper)
end
local function fmain(input,seg,env)
 local query=env.translator:query(input:lower(),seg)
 if query==nil then
  return
 end
 local count=0
 for cand in query:iter() do
  if input:find("^[A-Z]") then
   yield(ShadowCandidate(cand,"",auto_uppercase(input,cand.text),""))
  else
   yield(cand)
  end
  count=count+1
  if count>60 then
   return
  end
 end
end
local function fmodule(input,seg,env)
 if #input==1 then
  return
 end
 local query=env.translator:query(input:lower(),seg)
 if query==nil then
  return
 end
 local count=0
 for cand in query:iter() do
  cand.quality=cand.quality-0.0625
  if input:find("^[A-Z]") then
   yield(ShadowCandidate(cand,"",auto_uppercase(input,cand.text),""))
  else
   yield(cand)
  end
  count=count+5/(#cand.text+5)
  if count>1 then
   return
  end
 end
end
local is_module
local M={}
local T={}
M.translator=T
function T.init(env)
 env.translator=Component.Translator(env.engine,"","table_translator@"..env.name_space)
 is_module=env.name_space~="translator"
 T.func=is_module and fmodule or fmain
end
return M
