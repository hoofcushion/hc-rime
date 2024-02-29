local Utils <const> = require("utils")
local M <const> = {}
M.Dict={}; do
 local mini_dict <const> = Utils.rime_file_open("lua/mini_dict.txt","r")
 for line in mini_dict:lines() do
  local word,hanzi,sinifi,ensinifi=string.match(line,"^(.-)\t(.-)\t(.-\t.+)$")
  table.insert(M.Dict,{word,hanzi,sinifi,ensinifi})
 end
end
M.Reverse={}; do
 for index,entry in ipairs(M.Dict) do
  print(entry[1])
  M.Reverse[entry[1]]=entry
  M.Reverse[index]=entry
 end
end
do
 local hanzify <const> = {}
 function hanzify.word(word)
  if string.find(word,"%-") then
   return hanzify.compound(word)
  else
   local miniEntry=M.Reverse[word]
   return miniEntry and miniEntry[2] or word
  end
 end
 function hanzify.compound(word)
  word=string.gsub(word,"%-"," ")
  return "「"..hanzify.main(word).."」"
 end
 function hanzify.main(sentence)
  local result=""
  for word,others in string.gmatch(sentence,"([%a-]+)([^%a-]*)") do
   result=result..hanzify.word(word)
   result=result..others
  end
  return result
 end
 M.Hanzify=hanzify.main
end
return M