--- 上屏后都会清除特定用户词信息，从而保证输入稳定性
local H={}
local M={}
M.length={
 ---@param env Env
 init=function(env)
  local len=tonumber(env.name_space)
  assert(len~=nil and len>0,"Invalid length of"..tostring(len))
  H.notifier=env.engine.context.update_notifier:connect(function()
   local mem
   mem=Memory(env.engine,env.engine.schema)
   mem:user_lookup("",true)
   for entry in mem:iter_user() do
    if utf8.len(entry.text)==len then
     mem:update_userdict(entry,-1,"")
    end
   end
   mem=nil
  end)
 end,
 func=function()
  return 2
 end,
 fini=function()
  H.notifier:disconnect()
 end,
}
return M
