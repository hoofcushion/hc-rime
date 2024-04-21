--- Take a list, return a set of the elements in the list.
---@generic V:any
---@param list V[]
---@return table<V,true>
local function set(list)
 local r={}
 for _,v in ipairs(list) do r[v]=true end
 return r
end
local is_code=set({
 "^","$","%",".","?","-",
 "*","+","[","]","(",")",
 "a","b","c","d","e","f","g",
 "h","i","j","k","l","m","n",
 "o","p","q","r","s","t",
 "u","v","w","x","y","z",
})
local is_key=set({
 "BackSpace","Escape"
})
local shape_code=require("shape-filter.code")
local function str_to_shape(str)
 local ret={}
 for _,code in utf8.codes(str) do
  local char=utf8.char(code)
  local shape=shape_code[char]
  if shape~=nil then
   table.insert(ret,shape)
  end
 end
 return table.concat(ret)
end
---@class shape_filter_status
---@field input string
---@field is_active boolean
local ShapeFilter={
 input="",
 is_active=false,
}
function ShapeFilter:push(char)
 self.input=self.input..char
 self:refresh()
 self:update_prompt()
end
---@param length integer
function ShapeFilter:pop(length)
 self.input=self.input:sub(1,-length-1)
 self:refresh()
 self:update_prompt()
end
function ShapeFilter:clear()
 self.input=""
 self:refresh()
end
function ShapeFilter:activate()
 self.is_active=true
 self:clear()
 self:refresh()
end
function ShapeFilter:inactivate()
 self.is_active=false
 self:clear()
 self:refresh()
end
local function prompt_connect(env,str)
 local comp=env.engine.context.composition
 if comp:empty() then
  return
 end
 local seg=comp:back()
 seg.prompt=seg.prompt..str
end
function ShapeFilter:update_prompt()
 prompt_connect(self.env," filter: "..self.input)
end
function ShapeFilter:refresh()
 self.env.engine.context:refresh_non_confirmed_composition()
end
function ShapeFilter:toggle()
 if self.is_active then
  self:inactivate()
 else
  self:activate()
 end
end
function ShapeFilter:process_key(key)
 local keyName=key:repr()
 local char=utf8.char(key.keycode)
 if is_key[keyName] or is_code[char] then
  if keyName=="BackSpace" then
   if self.input~="" then
    self:pop(1)
   else
    self:inactivate()
   end
  elseif keyName=="Escape" then
   self:inactivate()
  else
   self:push(char)
  end
  return 1
 end
 return 2
end
---@type engine
local M={}
M.processor={
 init=function(env)
  ShapeFilter.env=env
  local function clear()
   if ShapeFilter.is_active then
    ShapeFilter:inactivate()
   end
  end
  local ctx=env.engine.context
  ctx.select_notifier:connect(clear)
  ctx.commit_notifier:connect(clear)
  local config=env.engine.schema.config
  local ns=env.name_space
  env.toggle_key=config:get_string(ns.."/toggle_key") or "Shift+Control+space"
 end,
 func=function(key,env)
  if key:release() then
   return 2
  end
  if env.engine.context.input=="" then
   ShapeFilter:inactivate()
   return 2
  end
  local keyName=key:repr()
  if keyName==env.toggle_key then
   ShapeFilter:toggle()
   return 1
  end
  if ShapeFilter.is_active then
   return ShapeFilter:process_key(key)
  end
  return 2
 end,
}
M.filter={
 func=function(translation)
  local input=ShapeFilter.input
  for cand in translation:iter() do
   local cand_shape=str_to_shape(cand.text)
   if string.find(cand_shape,input)~=nil then
    yield(ShadowCandidate(cand,"","",cand_shape))
   end
  end
 end,
 tags_match=function()
  return ShapeFilter.is_active
 end,
}
return M
