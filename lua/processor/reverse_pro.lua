local Utils <const> = require("utils")
local symbol
local prefix_len
local M <const> = {}
function M.init(env)
 symbol=env.engine.schema.config:get_string("recognizer/lua/"..env.name_space)
 prefix_len=#symbol
end
function M.func(key,env)
 local ctx <const> = env.engine.context
 if ctx:has_menu() then
  local seg <const> = ctx.composition:back()
  if not Utils.move_true_index(key,env) then
   return 2
  end
  local cand <const> = seg:get_selected_candidate()
  if cand.type=="fancha" then
   local ctxlen <const> = #ctx.input
   local result=cand.text:gsub("[^%a;]",""):lower()
   if cand._end~=ctxlen then
    result=result..symbol
    if seg._end==ctxlen then
     result=result..ctx.input:sub(cand._end+1)
    end
   end
   ctx:pop_input(prefix_len+seg.length)
   ctx:push_input(result)
   ctx.caret_pos=#ctx.input
   return 1
  end
 end
 return 2
end
return M