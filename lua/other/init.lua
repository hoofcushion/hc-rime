local Utils <const> = require("utils")
local M <const> = {}
function M.init(env)
 Utils.keyMapInitialize(env)
end
function M.func()
 return 2
end
return M