local function load_chai_file(buffer,filename)
 for line in io.lines(filename) do
  local char,components=line:match("^([^\t]+)\t(.+)$")
  if char and not buffer[char] then
   local variants={}
   for variant in components:gmatch("[^\t]+") do
    local comp_list={}
    for comp in variant:gmatch("%S+") do
     table.insert(comp_list,comp)
    end
    table.insert(variants,comp_list)
   end
   buffer[char]=variants
  end
 end
 return buffer
end
local map={}
local utils=require("utils")
load_chai_file(map,utils.check_file"lua/cand-decensor/chaizi-jt.txt")
load_chai_file(map,utils.check_file"lua/cand-decensor/chaizi-jt.txt")
local reverse_map={}
for char,variants in pairs(map) do
 for _,variant in ipairs(variants) do
  for _,comp in ipairs(variant) do
   local reverses=reverse_map[comp] or {}
   reverse_map[comp]=reverses
   reverses.seen=reverses.seen or {}
   if not reverses.seen[char] then
    reverses.seen[char]=true
    table.insert(reverses,char)
   end
  end
 end
end
local all_chars={}
for char,variants in pairs(map) do
 all_chars[char]=true
 for _,variant in ipairs(variants) do
  for _,component in ipairs(variant) do
   all_chars[component]=true
  end
 end
end
local extra_comps_set={}
for char in pairs(all_chars) do
 extra_comps_set[char]=true
end
local comps_map={}
for char in pairs(all_chars) do
 local valid_chars={}
 for _,reverse_char in ipairs(reverse_map[char] or {}) do
  for _,components in ipairs(map[reverse_char] or {}) do
   if #components==2 then
    local valid=true
    for _,comp in ipairs(components) do
     if comp~=char and not extra_comps_set[comp] then
      valid=false
      break
     end
    end
    if valid then
     table.insert(valid_chars,reverse_char)
    end
   end
  end
 end
 if #valid_chars>0 then
  comps_map[char]=valid_chars
 end
end
local function utf8_sub(s,i,j)
 i=utf8.offset(s,i)
 j=utf8.offset(s,j+1)-1
 return string.sub(s,i,j)
end
local function complicator(input_str)
 local result={}
 for i=1,utf8.len(input_str) do
  local char=utf8_sub(input_str,i,i)
  local chars=comps_map[char]
  if chars then
   char=chars[math.random(#chars)]
  end
  table.insert(result,char)
 end
 return table.concat(result)
end
---@type engine
local M={}
M.filter={
 init=function(env)
  local config=env.engine.schema.config
  local ns=env.name_space
  env.option_name=config:get_string(ns.."/option_name")
 end,
 func=function(input)
  for cand in input:iter() do
   local complicated=complicator(cand.text)
   if complicated~=cand.text then
    local shadow=ShadowCandidate(cand,"",complicated,cand.text)
    yield(shadow)
   else
    yield(cand)
   end
  end
 end,
 tags_match=function(_,env)
  return env.engine.context:get_option(env.option_name)
 end,
}
return M
