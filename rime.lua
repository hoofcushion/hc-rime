logdir=rime_api:get_user_data_dir().."/log.txt"
io.open(logdir,"w"):close()
function write(s)
 local file=io.open(logdir,"r")
 if file then
  file:close()
  io.open(logdir,"a"):write(s):close()
 end
end
function print(...)
 local e=select("#",...)
 for i=1,e do
  write(tostring(select(i,...)))
  if i<e then write("\t") end
 end
 write("\n")
end
local require=function (modname)
 local _,ret=pcall(require,modname)
 if _ then
  return ret
 else
  print(modname.." not exists.")
  return nil
 end
end
---@alias engine_name
---| "processor"
---| "translator"
---| "filter"
---| "segmentor"
---@alias lua_engine
---| engine_processor_simp
---| engine_processor_full
---| engine_translator_simp
---| engine_translator_full
---| engine_filter_simp
---| engine_filter_full
---| engine_segmentor_simp
---| engine_segmentor_full
---@class engine
---@field processor engine_processor_simp|engine_processor_full|nil
---@field translator engine_translator_simp|engine_translator_full|nil
---@field filter engine_filter_simp|engine_filter_full|nil
---@field segmentor engine_segmentor_simp|engine_segmentor_full|nil
---@alias engine_processor_simp fun(key,env):0|1|2
---@class engine_processor_full
---@field init fun(env)?
---@field func fun(key,env):0|1|2
---@field fini fun(env)?
---@alias engine_translator_simp fun(input:string,seg,env)
---@class engine_translator_full
---@field init fun(env)?
---@field func fun(input:string,seg,env)
---@field fini fun(env)?
---@alias engine_filter_simp fun(input:Translation,env)
---@class engine_filter_full
---@field init fun(env)?
---@field func fun(input:Translation,env)
---@field fini fun(env)?
---@field tags_match (fun(seg,env):boolean)?
---@alias engine_segmentor_simp fun(seg,env)
---@class engine_segmentor_full
---@field init fun(env)?
---@field func fun(seg,env)
---@field fini fun(env)?
---@type table<string,lua_engine>|engine
-- package.path      = "./lua/?.lua;" .. package.path
module_cn_en      =require("translator/module_cn_en")
module_fnua_cn    =require("translator/module_fnua_cn")
module_fnua_triple=require("translator/module_fnua_triple")
