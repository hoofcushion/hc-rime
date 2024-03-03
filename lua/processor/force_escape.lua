local M <const> = {}
function M.func(key,env)
 if env.engine.context:is_composing() and key:repr()=="Control+Escape" then
  env.engine.context:clear()
  return 1
 end
 return 2
end
return M
