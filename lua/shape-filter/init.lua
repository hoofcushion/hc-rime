local H={}
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
 return {match=table.concat(ret),represent=table.concat(ret," ")}
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
---@type engine
local M={}
M.processor={
 init=function(env)
  ShapeFilter.env=env
  local config=env.engine.schema.config
  local ns=env.name_space
  H.short_word_first=std.por(config:get_string(ns.."/short_word_first"),false)
  H.keymap={
   toggle_key=std.por(config:get_string(ns.."/toggle"),"Shift+Control+space"),
   escape_key=std.por(config:get_string(ns.."/escape"),"Escape"),
   backspace_key=std.por(config:get_string(ns.."/backspace"),"BackSpace"),
  }
  local is_code={}
  local alphabet=config:get_string("speller/alphabet")
  for char in string.gmatch(alphabet,".") do
   is_code[char]=true
  end
  H.is_code=is_code
  local function clear()
   if ShapeFilter.is_active then
    ShapeFilter:clear()
   end
  end
  local function inactivate()
   if ShapeFilter.is_active then
    ShapeFilter:inactivate()
   end
  end
  local ctx=env.engine.context
  ctx.select_notifier:connect(clear)
  ctx.commit_notifier:connect(inactivate)
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
  if keyName==H.keymap.toggle_key then
   ShapeFilter:toggle()
   return 1
  end
  if ShapeFilter.is_active then
   local char=utf8.char(key.keycode)
   if H.is_code[char] then
    ShapeFilter:push(char)
    return 1
   elseif keyName==H.keymap.backspace_key then
    if ShapeFilter.input=="" then
     ShapeFilter:inactivate()
    else
     ShapeFilter:pop(1)
    end
    return 1
   elseif keyName==H.keymap.escape_key then
    ShapeFilter:inactivate()
    return 1
   end
  end
  return 2
 end,
}
local function sort_short_word_first(a,b)
 local al,bl=#a.text,#b.text
 if al==bl then
  return a.quality>b.quality
 end
 return al<bl
end
M.filter={
 func=function(translation)
  local input=ShapeFilter.input
  local cands={}
  for cand in translation:iter() do
   local shape=str_to_shape(cand.text)
   if string.find(shape.match,input,nil,true)~=nil then
    table.insert(cands,ShadowCandidate(cand,"","",shape.represent))
   end
  end
  if H.short_word_first then
   table.sort(cands,sort_short_word_first)
  end
  for _,cand in ipairs(cands) do
   yield(cand)
  end
 end,
 tags_match=function()
  return ShapeFilter.is_active
 end,
}
return M
