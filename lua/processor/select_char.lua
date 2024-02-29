local Utils <const> = require("utils")
local map={}
local M <const> = {}
function M.init(env)
 map[env.engine.schema.config:get_string("key_binder/select_first_character")]=1
 map[env.engine.schema.config:get_string("key_binder/select_last_character")]=-1
end
function M.func(key,env)
 if not env.engine.context:has_menu() then
  return 2
 end
 local n <const> = map[key:repr()]
 if not n then
  return 2
 end
 env.engine:commit_text(Utils.utf8_sub(env.engine.context:get_selected_candidate().text,n,n))
 env.engine.context:clear()
 return 1
end
return M