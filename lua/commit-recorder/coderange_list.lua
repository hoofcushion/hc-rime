local M={
 minimum=11904,
 maximum=205743,
 {11904, 12031},
 {12032, 12255},
 {12272, 12287},
 {12544, 12591},
 {12704, 12735},
 {12736, 12783},
 {13312, 19903},
 {19968, 40959},
 {63744, 64223},
 {131072,173791},
 {173824,177983},
 {177984,178207},
 {178208,183983},
 {183984,191471},
 {194560,195103},
 {196608,201551},
 {201552,205743},
}
local function is_chinese(code)
 if code<=M.minimum
 or code>=M.maximum then
  return false
 end
 local left,right=1,#M
 while left<=right do
  local mid=(left+right)//2
  local range=M[mid]
  local min=range[1]
  local max=range[2]
  if code>=min and code<=max then
   return true
  end
  if code<min then
   right=mid-1
  elseif code>max then
   left=mid+1
  end
 end
 return false
end
local cache={}
function M.is_chinese(code)
 local ret=cache[code]
 if ret==nil then
  ret=is_chinese(code)
  cache[code]=ret
 end
 return ret
end
return M
