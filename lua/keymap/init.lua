local M={}
---@enum (key) mapping.default_conditions
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
---@alias mapping.rhs fun(env):0|1|2
---@alias mapping.cond fun(env):boolean
---@class mapping
---@field rhs mapping.rhs
---@field cond mapping.cond
---@field release boolean|nil
---@type table<string,mapping>
M.mappings={}
---@param cond mapping.cond|mapping.default_conditions|nil
---@param lhs string|string[]
---@param rhs mapping.rhs
---@param opts {release:boolean}|nil
function M:add(cond,lhs,rhs,opts)
 local new={}
 new.rhs=rhs
 if type(cond)=="string" then
  new.cond=self.conditions[cond]
 end
 if opts~=nil then
  new.release=opts.release
 end
 if type(lhs)=="table" then
  for _,v in ipairs(lhs) do
   M.mappings[v]=new
  end
 else
  M.mappings[lhs]=new
 end
end
M:add(
 "is_composing",
 {"Control+c","Control+e","Control+Escape"},
 function(env)
  env.engine.context:clear()
  return 1
 end
)
M:add(
 "is_composing",
 {"Return","KP_Return"},
 function(env)
  env.engine:commit_text(env.engine.context.input)
  env.engine.context:clear()
  return 1
 end
)

M:add(
 "has_menu",
 "bracketleft",
 function(env)
  local cand=env.engine.context:get_selected_candidate().text
  env.engine:commit_text(rime.utf8.sub(cand,1,1))
  env.engine.context:clear()
  return 1
 end
)
M:add(
 "is_composing",
 "Control+u",
 function(env)
  local pos=env.engine.context.caret_pos+1
  local inp=env.engine.context.input
  env.engine.context.input=string.sub(inp,pos)
  env.engine.context.caret_pos=0
  return 1
 end
)
M:add(
 "has_menu",
 "bracketright",
 function(env)
  local cand=env.engine.context:get_selected_candidate().text
  env.engine:commit_text(rime.utf8.sub(cand,-1))
  env.engine.context:clear()
  return 1
 end
)
local function goto_diff(segment,start,next)
 local cur=segment.selected_index
 local i,e,s
 if next then
  i,e,s=cur+1,math.maxinteger,1
 else
  i,e,s=cur-1,0,-1
 end
 local last
 for index=i,e,s do
  local cand=segment:get_candidate_at(index)
  if cand==nil then
   break
  end
  last=index
  if utf8.len(cand.text)~=start then
   segment.selected_index=index
   return 1
  end
 end
 if last~=nil then
  segment.selected_index=last
 end
 return 1
end
M:add(
 "has_menu",
 "Tab",
 function(env)
  local composition=env.engine.context.composition
  if composition:empty()==false then
   local segment=composition:back()
   local selected=env.engine.context:get_selected_candidate()
   local start=utf8.len(selected.text)
   return goto_diff(segment,start,true)
  end
  return 1
 end
)
M:add(
 "has_menu",
 "Control+Tab",
 function(env)
  local composition=env.engine.context.composition
  if composition:empty()==false then
   local segment=composition:back()
   local selected=env.engine.context:get_selected_candidate()
   local start=utf8.len(selected.text)
   return goto_diff(segment,start,false)
  end
  return 1
 end
)
M.processor={}
function M.processor.func(key,env)
 local name=key:repr()
 local mapping=M.mappings[name]
 if mapping~=nil then
  if mapping.cond~=nil and mapping.cond(env)==false then
   return 2
  end
  if mapping.release~=true and key:release() then
   return 2
  end
  return mapping.rhs(env)
 end
 return 2
end
return M
