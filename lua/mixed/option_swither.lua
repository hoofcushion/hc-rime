local Utils <const> = require("utils")
local M <const> ={}
local switcher
local symbol
local code_start
local optionMap
---@return table
local function get_option_map(optionList)
 local map={}
 for i=0,optionList.size-1 do
  local name <const> = optionList:get_at(i):get_map():get_value("name"):get_string()
  local text <const> = name:gsub("^fil_","")
  local auto_save <const> = switcher:is_auto_save(name)
  local mapEntry <const> = {text=text,option_name=name,auto_save=auto_save}
  if not map[name] then map[name]={} end
  table.insert(map[name],mapEntry)
 end
 return map
end
M.processor={}
---@return nil
function M.processor.init(env)
 switcher=Switcher(env.engine)
 symbol=env.engine.schema.config:get_string("recognizer/lua/"..env.name_space)
 code_start=#symbol+1
 optionMap=get_option_map(env.engine.schema.config:get_list("switches"))
end
---@return 0|1|2
function M.processor.func(key,env)
 local ctx <const> = env.engine.context
 local item <const> = optionMap[string.sub(ctx.input,code_start)]
 if not item then
  return 2
 end
 if ctx:has_menu() then
  local seg <const> = ctx.composition:back()
  if not Utils.move_true_index(key,env) then
   return 2
  end
  local cand <const> = seg:get_selected_candidate()
  local optionEntry <const> = item[tonumber(cand.type:match("index_(%d)"))]
  if not optionEntry then
   return 2
  end
  local name <const> = optionEntry.option_name
  local target_state <const> = not env.engine.context:get_option(name)
  ctx:set_option(name,target_state)
  if optionEntry.auto_save then
   switcher.user_config:set_bool("var/option/"..name,target_state)
  end
  return 1
 end
 return 2
end
M.translator={}
---@return nil
function M.translator.func(_,seg,env)
 if not seg:has_tag(env.name_space) then
  return
 end
 Utils.tipsEnv(env,"〔选项切换〕",true)
 local code <const> = env.engine.context.input:sub(code_start)
 local item <const> = optionMap[code]
 if not item then
  return
 end
 for index,optionEntry in ipairs(item) do
  local state <const> = env.engine.context:get_option(optionEntry.option_name)
  local cand=Candidate("index_"..index,seg.start,seg._end,optionEntry.text,state and "开" or "关")
  cand.preedit=code
  cand.quality=8102
  yield(cand)
 end
end
return M