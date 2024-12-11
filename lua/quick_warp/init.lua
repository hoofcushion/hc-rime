local Utils=require("utils")
local keyMap={}
do
 for key,v in
 pairs({[0]=-1,1,2,3,4,5,6,7,8,9})
 do
  keyMap[string.byte(key)]=v
 end
 local i=1
 for char in
 string.gmatch("qwertyuiopasdfghjkl;zxcvbnm,./",".")
 do
  keyMap[string.byte(char)]=i
  i=i%10+1
 end
end
---@param syllables string
---@param x_th integer
---@return integer caret_pos # target pos
local function get_pos(syllables,x_th)
 ---@type table<integer,integer>
 local map={}
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
local Actions={
 [false]={
  start=function(_,env)
   env.warp_mode=true
   env.engine.context.caret_pos=0
   env.engine.context.caret_pos=#env.engine.context.input
   Utils.prompt(env,"跳转模式")
   return 1
  end,
 },
 [true]={
  start=function(_,env)
   env.warp_mode=false
   Utils.prompt(env,"跳转关闭")
   return 1
  end,
  move=function(key,env)
   env.warp_mode=false
   env.engine.context.caret_pos=get_pos(env.engine.context:get_script_text(),keyMap[key.keycode])
   Utils.prompt(env,"跳转完毕")
   return 1
  end,
  stop=function(_,env)
   env.warp_mode=false
   return 2
  end,
 },
}
local M={}
M.processor={}
function M.processor.init(env)
 env.start_key=env.engine.schema.config:get_string(env.name_space.."/start_key") or "Control+Control_R"
 env.warp_mode=false
end
function M.processor.func(key,env)
 if key:release() then
  return 2
 end
 if env.engine.context:has_menu()==false then
  env.warp_mode=false
  return 2
 end
 local keyName=key:repr()
 local action
 if keyName==env.start_key then
  action="start"
 else
  local target=keyMap[key.keycode]
  action=target~=nil and "move" or "stop"
 end
 local fn=Actions[env.warp_mode][action]
 if fn~=nil then
  return fn(key,env)
 end
 return 2
end
return M
