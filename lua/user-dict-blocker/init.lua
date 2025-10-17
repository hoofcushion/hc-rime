--- 上屏后都会清除特定用户词信息，从而保证输入稳定性
local H={}
local fn ---@type function?
local M={}
---@type engine_processor_full
M.processor={
 ---@param env Env
 init=function(env)
  local len=tonumber(env.name_space)
  len=len or 1
  local mem=Memory(env.engine,env.engine.schema)
  mem:user_lookup("",true)
  for entry in mem:iter_user() do
   if utf8.len(entry.text)==len then
    mem:update_userdict(entry,-1,"")
   end
  end
  H.notifier=env.engine.context.commit_notifier:connect(function(ctx)
   local commit_text=ctx:get_commit_text()
   -- 限制长度符合要求
   if not (#commit_text~=len and utf8.len(commit_text)==len) then
    return
   end
   -- 取到 Phrase 类型
   local cand
   cand=ctx:get_selected_candidate() or nil
   cand=cand~=nil and cand:get_genuine() or nil
   cand=cand~=nil and cand:to_phrase() or nil
   -- 删除用户词
   if cand~=nil and cand.entry then
    fn=function()
     mem:update_userdict(cand.entry,-1,"")
    end
   end
  end)
 end,
 func=function()
  if fn then
   fn()
   fn=nil
  end
  return 2
 end,
 fini=function()
  H.notifier:disconnect()
 end,
}
return M
