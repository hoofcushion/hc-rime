local M <const> = {}
Sep=string.sub(package.config,1,1)
local user <const> = rime_api:get_user_data_dir()
local data <const> = rime_api:get_shared_data_dir()
local function file_exist(filename)
 local file=io.open(filename,"r")
 if file then
  file:close()
  return filename
 end
end
local userS=user..Sep
local dataS=data..Sep
---@return string
function M.rime_file_exist(filename)
 return file_exist(userS..filename) or file_exist(dataS..filename) or log:error("could not find "..filename)
end
---@param filename string
---@return file*
function M.rime_file_open(filename,mode)
 ---@type file*
 return io.open(M.rime_file_exist(filename),mode)
end
function M.tipsEnv(env,str,add)
 M.tipsCtx(env.engine.context,str,add)
end
function M.tipsCtx(ctx,str,add)
 local comp <const> = ctx.composition
 if comp:empty() then
  return
 end
 local seg=comp:back()
 if add then
  seg.prompt=seg.prompt..str
 else
  seg.prompt=str
 end
end
---@param str string
---@param start integer
---@param final integer
---@return string
function M.utf8_sub(str,start,final)
 local len_p <const> = #str+1
 if final then
  local i1 <const> = start<0 and len_p or 1
  local i2 <const> = final<0 and len_p or 1
  final=final+1
  start,final=utf8.offset(str,start,i1),utf8.offset(str,final,i2)
  final=final-1
  str=string.sub(str,start,final)
  return str
 end
 local i1 <const> = start<0 and len_p or 1
 start=utf8.offset(str,start,i1)
 str=string.sub(str,start)
 return str
end
function M.toSimpleCand(cand)
 local ncand <const> = Candidate(cand.type,cand.start,cand._end,cand.text,cand.comment)
 ncand.quality=cand.quality
 ncand.preedit=cand.preedit
 return ncand
end
M.keyMap=
{
 ["space"]=-1,
 ["0"]=9,
 ["1"]=0,
 ["2"]=1,
 ["3"]=2,
 ["4"]=3,
 ["5"]=4,
 ["6"]=5,
 ["7"]=6,
 ["8"]=7,
 ["9"]=8,
}
function M.keyMapInitialize(env)
 local select_keys=env.engine.schema.select_keys
 if select_keys and select_keys~="" then
  M.keyMap={["space"]=-1}
  local count=0
  for substr in select_keys:gmatch(".") do
   M.keyMap[substr]=count
   count=count+1
  end
 end
end
function M.move_true_index(key,env)
 local index <const> = M.keyMap[key:repr()]
 if not index then
  return false
 end
 local seg <const> = env.engine.context.composition:back()
 if index>-1 then
  local page_size <const> = env.engine.schema.page_size
  seg.selected_index=index+math.floor(seg.selected_index/page_size)*page_size
 end
 return true
end
function M.table_deep_copy(tab)
 local ret={}
 for k,v in next,tab do
  ret[k]=v
 end
 return ret
end
function M.table_extend(main,sub)
 local ret=M.table_deep_copy(main)
 for k,v in next,sub do
  ret[k]=v
 end
 return ret
end
return M