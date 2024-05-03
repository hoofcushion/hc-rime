local utils=require("utils")
local ENV={
 io=nil,
 os=nil,
 debug=nil,
 coroutine=nil,
 print=function(...)
  local text={}
  for _,v in ipairs({...}) do
   table.insert(text,utils.serialize(v))
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
local M={}
M.translator={}
function M.translator.init(env)
 local config=env.engine.schema.config
 local ns=env.name_space~="" and env.name_space or "execute"
 env.delimiter=utils.por(config:get_string(ns.."/delimiter"),"|")
 env.fin=utils.por(config:get_string(ns.."/fin"),";")
 env.greedy=utils.por(config:get_bool(ns.."/greedy"),true)
 env.prefix=utils.por(config:get_string(ns.."/prefix"),"")
 env.tag=utils.por(config:get_string(ns.."/tag"),ns)
 env.quality=utils.por(config:get_double(ns.."/initial_quality"),0)
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
  utils.prompt(env,"Lua execute")
  return
 end
 env.yield(exp,"Expression",seg)
 local code=exp:find("return ") and exp or "return "..exp
 local fn,err=loadstr(code)
 if fn==nil then
  env.yield(err,"Comptime Error",seg)
  return
 end
 local ok,ret=pcall(fn)
 if ok==false then
  env.yield(ret,"Runtime Error",seg)
  return
 end
 ret=utils.serialize(ret)
 env.yield(ret,"Value",seg)
 env.yield(exp.."="..ret,"Equality",seg)
 if ret:find([[^".*"$]])~=nil then
  env.yield(ret:sub(2,-2),"Without quote",seg)
 end
end
return M
