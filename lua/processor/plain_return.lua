local keyMap <const> = {Return=true,KP_Return=true}
local M <const> = {}
function M.func(key,env)
 if keyMap[key:repr()] and env.engine.context:is_composing() then
  env.engine:commit_text(env.engine.context.input)
  env.engine.context:clear()
  return 1
 end
 return 2
end
return M