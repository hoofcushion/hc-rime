local hc=require("hclib")
local M <const> = {}
M.conditions={
 is_composing=function(env)
  return env.engine.context:is_composing()
 end,
 has_menu=function(env)
  return env.engine.context:has_menu()
 end,
 paging=function(env)
  local comp=env.engine.context:composition()
  if comp.empty()==false then
   local seg=comp.back()
   return seg.has_tag("paging")
  end
  return false
 end,
 prediction=function(env)
  local comp=env.engine.context:composition()
  if comp.empty()==false then
   local seg=comp.back()
   return seg.has_tag("prediction")
  end
  return false
 end,
}
M.mappings={}
function M:add(lhs,rhs,cond)
 if type(cond)=="string" then
  cond=self.conditions[cond]
 end
 local mapping={fn=rhs,cond=cond}
 for _,v in hc.pipairs(lhs) do
  M.mappings[v]=mapping
 end
end
function M.func(key,env)
 local name=key:repr()
 local mapping=M.mappings[name]
 if mapping~=nil and mapping.cond(env) then
  return mapping.fn(env)
 end
 return 2
end
M:add("Control+Escape",
      function(env)
       env.engine.context:clear()
       return 1
      end,
      "is_composing"
)
M:add({"Return","KP_Return"},
      function(env)
       env.engine:commit_text(env.engine.context.input)
       env.engine.context:clear()
       return 1
      end,
      "is_composing"
)
local Utils <const> = require("utils")
M:add("bracketleft",
      function(env)
       local cand=env.engine.context:get_selected_candidate().text
       env.engine:commit_text(Utils.utf8_sub(cand,1,1))
       env.engine.context:clear()
       return 1
      end,
      "has_menu"
)
M:add("bracketright",
      function(env)
       local cand=env.engine.context:get_selected_candidate().text
       env.engine:commit_text(Utils.utf8_sub(cand,-1))
       env.engine.context:clear()
       return 1
      end,
      "has_menu"
)
return M
