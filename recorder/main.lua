local OUTPUT="output"
local function loadInput(minWeight,mapOriginal)
 local map={}
 local file=io.open("recorder_words.txt","r")
 if not file then error("没有 input 文件") end
 if minWeight==0 then
  for line in file:lines() do
   local k,v=line:match("^(.-)\t([0-9]-)$")
   if k and not mapOriginal[k] then
    table.insert(map,{k,v})
   end
  end
 else
  for line in file:lines() do
   local k,v=line:match("^(.-)\t([0-9]-)$")
   if k and tonumber(v)>minWeight and not mapOriginal[k] then
    table.insert(map,{k,v})
   end
  end
 end
 file:close()
 return map
end
local function loadWeight()
 local minWeight
 print("输入纳入新词的最小次数, 如为0则纳入全部")
 while true do
  minWeight=tonumber(io.read())
  if minWeight~=nil and math.floor(minWeight)==minWeight then
   break
  end
  print("请输入整数")
 end
 return minWeight
end
local function writeOutput(mapInput)
 io.open(OUTPUT,"w"):close()
 local file=io.open(OUTPUT,"a")
 if file==nil then
  error("Not File:"..OUTPUT)
 end
 for _,v in ipairs(mapInput) do
  file:write(table.concat(v,"\t").."\n")
 end
 file:close()
end
local function loadDict(map,path)
 local file=io.open(path,"r")
 if not file then error(path.." 词典未找到") end
 for line in file:lines() do
  local k=line:match("^(.-)\t.-[0-9]-$")
  if k and not map[k] then
   map[k]=true
  end
 end
 file:close()
end
local function loadDicts()
 local dicts=require("dicts")
 local map={}
 for _,path in ipairs(dicts) do
  loadDict(map,path)
 end
 return map
end
local input="r"
local mapOriginal
repeat
 if input=="r" then
  input=false
  print("正在读取原始词库")
  mapOriginal=loadDicts()
 end
 local minWeight=0
 local mapInput=loadInput(minWeight,mapOriginal)
 table.sort(mapInput,function(a,b) return tonumber(a[2])>tonumber(b[2]) end)
 writeOutput(mapInput)
 print("生成完毕")
 print("r: 重新读取 dict 文件\nq: 退出程序\n回车: 重新生成去重词库")
 input=io.read()
until input=="q"
