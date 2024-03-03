local Utils <const> = require("utils")
local filter
local option_name
local processor <const> =
{
 init=function(env)
  local name <const> = env.name_space:match("^%*?(.*)$")
  filter=Opencc(env.engine.schema.config:get_string(name.."/opencc_config"))
  option_name=env.engine.schema.config:get_string(name.."/option_name")
 end,
 func=function(key,env)
  local ctx <const> = env.engine.context
  if ctx:has_menu() and ctx:get_option(option_name) then
   local seg <const> = ctx.composition:back()
   if not Utils.move_relative_index_by_key(key,env) then
    return 2
   end
   if seg:get_selected_candidate()._end~=#ctx.input then
    return 2
   end
   env.engine:commit_text(filter:convert_text(ctx:get_commit_text()))
   ctx:clear()
   return 1
  end
  return 2
 end,
}
return processor
