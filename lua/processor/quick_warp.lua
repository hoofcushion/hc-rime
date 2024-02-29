local Utils <const> = require("utils")
local H={
 warp_mode=false,
 start_key="",
}
local M <const> = {}
local keyMap <const> = {
 [1]=1,
 [2]=2,
 [3]=3,
 [4]=4,
 [5]=5,
 [6]=6,
 [7]=7,
 [8]=8,
 [9]=9,
 [0]=-1,
}
do
 for key,v in pairs(keyMap) do
  keyMap[key]=nil
  keyMap[string.byte(key)]=v
 end
 local i=1
 for char in string.gmatch("qwertyuiopasdfghjkl;zxcvbnm,./",".") do
  keyMap[string.byte(char)]=i
  i=i%10+1
 end
end
---@param syllables string
---@param x_th integer
---@return integer caret_pos # target pos
local function get_pos(syllables,x_th)
 ---@type table<integer,integer>
 local map <const> = {}
 local position=0
 for syllable in syllables:gmatch("[^ ]+") do
  position=position+#syllable
  table.insert(map,position)
 end
 local max=#syllables
 if x_th<0 then
  x_th=max+x_th
 end
 return map[x_th]
end
local Actions <const> = {
 [false]={
  start=function(ctx)
   H.wrap_mode=true
   ctx.caret_pos=0
   ctx.caret_pos=#ctx.input
   Utils.tipsCtx(ctx,"跳转模式")
   return 1
  end,
 },
 [true]={
  start=function(ctx)
   H.wrap_mode=false
   Utils.tipsCtx(ctx,"跳转关闭")
   return 1
  end,
  move=function(ctx,target)
   H.wrap_mode=false
   ctx.caret_pos=get_pos(ctx:get_script_text(),target)
   Utils.tipsCtx(ctx,"跳转完毕")
   return 1
  end,
  stop=function()
   H.wrap_mode=false
   return 2
  end,
 },
}
function M.init(env)
 local start_key=env.engine.schema.config:get_string(env.name_space)
 if start_key==nil then
  error("No start key for quick_warp")
 end
 H.start_key=start_key
end
function M.func(key,env)
 if key:release() then
  return 2
 end
 local ctx <const> = env.engine.context
 if ctx:has_menu()==false then
  H.wrap_mode=false
  return 2
 end
 local keyName <const> = key:repr()
 local target <const> = keyMap[key.keycode]
 local action
 if keyName==H.start_key then
  action="start"
 else
  if target~=nil then
   action="move"
  else
   action="stop"
  end
 end
 local fn=Actions[H.wrap_mode][action]
 if fn~=nil then
  return fn(ctx,target)
 end
 return 2
end
return M
