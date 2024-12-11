---@class chinese_number_style
---@field unit string[]
---@field innermag string[]
---@field outermag string[]
---@field decmag string[]
---@field sep string[]
local upper={
 unit={[0]="零","壹","贰","叁","肆","伍","陆","柒","捌","玖"},
 innermag={nil,"拾","佰","仟"},
 outermag={"万","亿","兆","京","垓","秭","穰","沟","涧","正","载","极"},
 decmag={"角","分","厘","毫"},
 sep={
  [true]={[true]="元",[false]="元整"},
  [false]={[true]="點"},
 },
}
---@class chinese_number_style
local lower={
 unit={[0]="〇","一","二","三","四","五","六","七","八","九"},
 innermag={nil,"十","百","千"},
 outermag={"万","亿","兆","京","垓","秭","穰","沟","涧","正","载","极"},
 decmag={"角","分","厘","毫"},
 sep={
  [true]={[true]="元",[false]="元整"},
  [false]={[true]="点"},
 },
}
local map={
 [true]=upper,
 [false]=lower,
}
--- like normal mod but 1-indexed so it matches lua's list
local function mod1(a,b)
 return (a-1)%b+1
end
local MAX_INTMAG=#(upper.outermag)*#(upper.unit)
local MAX_DECMAG=#(upper.decmag)
---
---@param fn function
---@return function
local function count_wrap(fn)
 local i=0
 return function()
  local v=fn()
  if v~=nil then
   i=i+1
   return i,v
  end
 end
end
---@param fn function
---@return function
local function format_wrap(fn,format)
 return function()
  local v=fn()
  if v~=nil then
   return format(v)
  end
 end
end
--- example:
--- for i,v in iter("1324") do
---  print(i,v)
--- end
--- > 1	1
---   2	3
---   3	2
---   4	4
local function strint_iter(str)
 -- if tonumber(str)==nil then
 --  error("#1 must be a integer-like string")
 -- end
 local iter=string.gmatch(str,".")
 return count_wrap(format_wrap(iter,tonumber))
end
---
---@param str string
---@param style chinese_number_style
local function numberInteger(str,style)
 local len=#str
 if len==1 then
  return style.unit[tonumber(str)]
 elseif len>MAX_INTMAG then
  return str:sub(len-MAX_INTMAG,len)
 end
 local result={}
 local after_0=false
 local l=len
 for _,digit in strint_iter(str) do
  if digit~=0 then
   if after_0 then
    table.insert(result,style.unit[0])    -- 10*1* -> 零一
   end
   table.insert(result,style.unit[digit]) -- *1* -> 一
   local size=mod1(l,4)
   if size>1 then
    table.insert(result,style.innermag[size]) -- 十百千
   end
   if l>4 and l%4==1 then
    table.insert(result,style.outermag[math.floor(l/4)]) -- 万亿兆
   end
  end
  after_0=digit==0
  l=l-1
 end
 return table.concat(result)
end
---
---@param str string
---@param style chinese_number_style
local function numberDecimal(str,style)
 local result={}
 local len=#str
 if len==1 then
  return style.unit[tonumber(str)]
 end
 for _,digit in strint_iter(str) do
  table.insert(result,style.unit[digit])
 end
 return table.concat(result)
end
---
---@param str string
---@param style chinese_number_style
local function moneyDecimal(str,style)
 local result={}
 local len=#str
 if len>MAX_DECMAG then
  str=str:sub(1,MAX_DECMAG)
 end
 local after_0=false
 for i,digit in strint_iter(str) do
  if digit~=0 then
   if after_0 then
    table.insert(result,style.unit[0])
   end
   table.insert(result,style.unit[digit])
   table.insert(result,style.decmag[i])
  end
  after_0=digit==0
 end
 return table.concat(result)
end
if false then
 ---@class characterizer_mode
 local mode={
  is_money=true,
  is_upper=true,
 }
end
---@param str string
---@param mode characterizer_mode
---@return string
local function characterizer(str,mode)
 local int_part=str:match("^%d+") --[[@as string]]
 local dec_part=str:match("%.(0*[1-9]%d*)$") --[[@as string|nil]]
 local has_dec=dec_part~=nil and dec_part:gsub("0","")~=""
 local num_style=map[mode.is_upper]
 local result={}
 if not (mode.is_money and int_part=="0" and has_dec==false) then
  table.insert(result,numberInteger(int_part,num_style))
  table.insert(result,num_style.sep[mode.is_money][has_dec])
 end
 if has_dec then ---@cast dec_part -nil
  if mode.is_money then
   table.insert(result,moneyDecimal(dec_part,num_style))
  else
   table.insert(result,numberDecimal(dec_part,num_style))
  end
 end
 return table.concat(result)
end
local modes={
 {is_money=false,is_upper=true},
 {is_money=false,is_upper=false},
 {is_money=true, is_upper=true},
 {is_money=true, is_upper=false},
}
local comments={
 "大写数字",
 "小写数字",
 "大写金额",
 "小写金额",
}
local function prompt_connect(env,str)
 local comp=env.engine.context.composition
 if comp:empty() then
  return
 end
 local seg=comp:back()
 seg.prompt=seg.prompt..str
end
local M={}
M.translator={}
function M.translator.init(env)
 local config=env.engine.schema.config
 local ns=env.name_space~="" and env.name_space or "chinese_number"
 env.tag=config:get_string(ns.."/tag") or ns
 env.prefix=config:get_string(ns.."/prefix") or ""
 env.quality=config:get_double(ns.."/initial_quality") or 0
 env.code_start=#env.prefix+1
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
 local code=input:sub(env.code_start):gsub("^0+","")
 if code=="" then
  env.yield("请输入数字","",seg)
  return
 elseif code:find("^%d+$")==nil and code:find("^%d-%.%d*$")==nil then
  env.yield("数字不合法","",seg)
  return
 elseif #code:match("^%d+")>MAX_INTMAG then
  env.yield("位数超过限制","",seg)
  return
 end
 prompt_connect(env,"〔大写数字〕")
 for i,mode in ipairs(modes) do
  local text=characterizer(code,mode)
  env.yield(text,comments[i],seg)
 end
end
return M
