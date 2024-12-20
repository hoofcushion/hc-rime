local OUTPUT="output.txt"
local function popen(filename,mode)
 local file=io.open(filename,mode)
 if file==nil then error("No file: "..filename) end
 return file
end
local function loadInput(minWeight,mapOriginal)
 local map={}
 local file=popen("word.txt","r")
 for line in file:lines() do
  local k,v=line:match("^(.-)\t([0-9]-)$")
  if k and mapOriginal[k]==nil and tonumber(v)>minWeight then
   table.insert(map,{k,v})
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
 popen(OUTPUT,"w"):close()
 local file=popen(OUTPUT,"a")
 for _,v in ipairs(mapInput) do
  file:write(table.concat(v,"\t").."\n")
 end
 file:close()
end
local function loadDict(map,path)
 local file=popen(path,"r")
 for line in file:lines() do
  local k=line:match("^(.-)\t")
  if k and map[k]==nil then
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
while true do
 if input=="q" then
  return
 elseif input=="r" then
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
end
