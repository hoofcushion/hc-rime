---@type engine
local M={}
M.filter={
 init=function(env)
  env.limit=tonumber(env.name_space) or 100
  if env.limit==0 then
   function M.filter.func() end
  else
   function M.filter.func(input,env)
    local i=0
    for cand in input:iter() do
     if i==env.limit then
      break
     end
     i=i+1
     yield(cand)
    end
   end
  end
 end,
 func=function() end,
}
return M
