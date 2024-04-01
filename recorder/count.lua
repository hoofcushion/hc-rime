local files={
 "char.txt",
 "word.txt",
}
local function popen(filename,mode)
 local file=io.open(filename,mode)
 if file==nil then error("No file: "..filename) end
 return file
end
local function countcommit()
 local count=0
 for _,filename in ipairs(files) do
  local file=popen(filename,"r")
  for line in file:lines() do
   local word,time=line:match("^(.-)\t([0-9]-)$")
   count=count+utf8.len(word)*time
  end
  file:close()
 end
 return count
end
print(countcommit())
