---@param obj any
---@return string
local function serialize(obj)
 local t=type(obj)
 if t=="string" then
  return '"'..obj:gsub('"','\\"')..'"'
 elseif t=="table" then
  local ret=""
  for k,v in pairs(obj) do
   ret=ret.."["..serialize(k).."]="..serialize(v)..","
  end
  return "{"..ret:sub(1,-2).."}"
 end
 return tostring(obj)
end
local function prompt_connect(env,str)
 local comp=env.engine.context.composition
 if comp:empty()==false then
  local seg=comp:back()
  seg.prompt=seg.prompt..str
 end
end
local ENV={
 io=nil,
 os=nil,
 debug=nil,
 print=function(...)
  local text={}
  for _,v in ipairs({...}) do
   table.insert(text,serialize(v))
  end
  yield(Candidate("print",0,0,table.concat(text,"	"),"print"))
 end,
}
for k,v in pairs(math) do
 ENV[k]=v
end
local function loadstr(exp)
 return load(exp,"","t",ENV)
end
local function por(a,b)
 return a~=nil and a or b
end
local M={}
M.translator={}
function M.translator.init(env)
 local config=env.engine.schema.config
 local ns=env.name_space~="" and env.name_space or "execute"
 env.delimiter=por(config:get_string(ns.."/delimiter"),"|")
 env.fin=por(config:get_string(ns.."/fin"),";")
 env.greedy=por(config:get_bool(ns.."/greedy"),true)
 env.prefix=por(config:get_string(ns.."/prefix"),ns)
 env.tag=por(config:get_string(ns.."/tag"),ns)
 env.tips=por(config:get_string(ns.."/tips"),"Lua execute")
 env.quality=por(config:get_double(ns.."/initial_quality"),0)
 env.code_start=#env.prefix+1
 env.fin_p=env.fin.."$"
 function env.yield(text,comment,seg)
  local cand=Candidate(env.name_space,seg.start,seg._end,text,comment)
  cand.quality=env.quality
  yield(cand)
 end
end
function M.translator.func(input,seg,env)
 if seg:has_tag(env.tag)==false then
  return
 end
 local finished=env.greedy or input:find(env.fin_p)~=nil
 if finished==false then
  return
 end
 local end_pos=input:find(env.fin_p)~=nil and -2 or nil
 local exp=input:sub(env.code_start,end_pos)
 exp=exp:gsub(env.delimiter," ")
 if exp=="" then
  prompt_connect(env,env.tips)
  return
 end
 env.yield(exp,"Expression",seg)
 local code=exp:find("return ") and exp or "return "..exp
 local fn,err=loadstr(code)
 if fn==nil then
  env.yield(err,"Error",seg)
  return
 end
 local result=fn()
 result=serialize(result)
 env.yield(result,"Value",seg)
 env.yield(exp.."="..result,"Equality",seg)
 if result:find([[^['"].*['"]$]])~=nil then
  env.yield(result:sub(2,-2),"Without quote",seg)
 end
end
return M
