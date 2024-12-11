local M={}
M.length={
 init=function(env)
  local len=tonumber(env.name_space)
  assert(len~=nil and len>0,"Invalid length of" .. tostring(len))
  local mem=Memory(env.engine,env.engine.schema)
  env.mem=mem
  mem:user_lookup("",true)
  for entry in mem:iter_user() do
   if utf8.len(entry.text)==len then
    mem:update_userdict(entry,-1,"")
   end
  end
  mem:memorize(function(commit)
   for _,entry in ipairs(commit:get()) do
    if utf8.len(entry.text)==len then
     mem:update_userdict(entry,-1,"")
    end
   end
  end)
 end,
 func=function()
  return 2
 end,
 fini=function(env)
  env.mem=nil
 end,
}
return M
