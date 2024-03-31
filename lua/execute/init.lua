-- 来自https://github.com/baopaau/rime-lua-collection
-- 没有许可信息
-- 做了一部分修改
local function str_escape(str)
 return string.gsub(str,'"','\\"')
end
local function serialize(obj)
 local type=type(obj)
 if type=="string" then
  return '"'..str_escape(obj)..'"'
 elseif type=="table" then
  local ret={}
  table.insert(ret,"{")
  for k,v in pairs(obj) do
   table.insert(ret,"["..serialize(k).."]="..serialize(v)..",")
  end
  table.insert(ret,"}")
  return table.concat(ret)
 elseif type=="function" then
  return "callable"
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
local ENV={io=nil,os=nil}
local function loadstr(exp,_env)
 return load(exp,"","t",_env)
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
 env.code_start=#env.prefix+1
 env.fin_p=env.fin.."$"
 function env.yield(text,comment,seg)
  yield(Candidate(ns,seg.start,seg._end,text,comment))
 end
end
function M.translator.func(input,seg,env)
 if seg:has_tag(env.tag)==false then
  return
 end
 prompt_connect(env,env.tips)
 local finished=env.greedy or input:find(env.fin_p)~=nil
 if finished==false then
  return
 end
 local exp=input:find(env.fin_p)~=nil
  and input:sub(env.code_start,-2)
  or input:sub(env.code_start)
 exp=exp:gsub(env.delimiter," ")
 if exp:find("^%s*$") then
  env.yield("Run lua code","Input",seg)
  return
 end
 env.yield(exp,"Expression",seg)
 local code=exp:find("return ") and exp or "return "..exp
 local fn,err=loadstr(code,ENV)
 if fn==nil then
  env.yield(err,"Error",seg)
  return
 end
 local result=fn()
 if result==nil then
  env.yield("nil","No output",seg)
  return
 end
 result=serialize(result)
 env.yield(result,"Value",seg)
 env.yield(exp.."="..result,"Equality",seg)
 if result:find([[^['"].*['"]$]])~=nil then
  env.yield(result:sub(2,-2),"Without quote",seg)
 end
end
return M
