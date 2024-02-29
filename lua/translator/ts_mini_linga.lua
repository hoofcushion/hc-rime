local Mini <const> =require("mini_dict")
local M={}
local function autoUppercase(input,text)
 if string.find(input,"^%u") then
  if string.find(input,".%u$") then
   return string.gsub(text,"%l",string.upper)
  end
  return string.gsub(text,"%l",string.upper,1)
 end
 return text
end
local TranslatorList <const> = {}
local function candLimit_make(isModule)
 return isModule and
  function(yieldCount,text)
   if yieldCount>1 then
    return false
   end
   return yieldCount+5/(#text+5)
  end
  or
  function(yieldCount)
   if yieldCount==10 then
    return false
   end
   return yieldCount+1
  end
end
local candLimit
function M.init(env)
 local isModule <const> = env.name_space~="translator"
 candLimit=candLimit_make(isModule)
 local engineCallName <const> = isModule and env.name_space or "translator"
 TranslatorList[#TranslatorList+1]=Component.Translator(env.engine,"","script_translator@"..engineCallName)
 TranslatorList[#TranslatorList+1]=Component.Translator(env.engine,"","table_translator@"..engineCallName)
end
function M.func(input,seg)
 local candYieldMap={}
 local yieldCount=0
 for i=1,#TranslatorList do
  local Translator <const> = TranslatorList[i]
  local query <const> = Translator:query(string.lower(input),seg)
  if not query then
   return
  end
  for cand in query:iter() do
   local text=cand.text
   text=string.gsub(text," $","")
   text=string.gsub(text," %-","-")
   text=autoUppercase(input,text)
   cand.preedit=autoUppercase(input,cand.preedit)
   if candYieldMap[text] then
    goto next
   end
   candYieldMap[text]=true
   local comment_hanzi <const> = string.gsub(Mini.Hanzify(text)," ","")
   yieldCount=candLimit(yieldCount,text)
   if not yieldCount then
    return
   end
   yield(ShadowCandidate(cand,cand.type,text,comment_hanzi))
   ::next::
  end
 end
end
return M