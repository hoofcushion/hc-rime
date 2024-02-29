local Mini <const> =require("mini_dict")
local startPrompt
local codeBeginning
local M={}
---@param t       (string|number)[]
---@param pattern string|number
---@param init?   integer
---@param plain?  boolean
local function array_find(t,pattern,init,plain)
 for i=1,#t do
  if string.find(t[i],pattern,init,plain) then
   return true
  end
 end
 return false
end
function M.init(env)
 startPrompt=env.engine.schema.config:get_string("recognizer/lua/"..env.name_space)
 codeBeginning=#startPrompt+1
end
function M.func(_,seg,env)
 if not seg:has_tag(env.name_space) then
  return
 end
 local context=env.engine.context
 local contextInput <const> = context.input
 if not string.find(contextInput,"^"..startPrompt) then
  return
 end
 local inputCode <const> = string.sub(contextInput,codeBeginning)
 for _,miniEntry in ipairs(Mini.Dict) do
  if contextInput==startPrompt or array_find(miniEntry,inputCode) then
   local text <const> = miniEntry[1]
   local comment <const> = miniEntry[2].."\t"..miniEntry[3]
   local cand=Candidate("",seg.start,seg._end,text,comment)
   cand.quality=8102
   cand.preedit=inputCode
   yield(cand)
  end
 end
end
return M