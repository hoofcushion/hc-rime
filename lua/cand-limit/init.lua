---限制最多显示多少候选，防止大量候选卡顿
---@type engine
local M={}
local config={}
M.filter={
 init=function(env)
  config={
   limit=tonumber(env.name_space) or 100,
  }
 end,
 func=function(input)
  local i=0
  for cand in input:iter() do
   if i==config.limit then
    break
   end
   i=i+1
   yield(cand)
  end
 end,
}
return M
