local function hue2rgb(p,q,t)
 if t<0 then t=t+1 end
 if t>1 then t=t-1 end
 if t<1/6 then return p+(q-p)*6*t end
 if t<1/2 then return q end
 if t<2/3 then return p+(q-p)*(2/3-t)*6 end
 return p
end
-- HSL 转 RGB
local function hsl_to_rgb(h,s,l)
 local r,g,b
 if s==0 then
  r,g,b=l,l,l
 else
  local q=l<0.5 and l*(1+s) or l+s-l*s
  local p=2*l-q
  r=hue2rgb(p,q,h+1/3)
  g=hue2rgb(p,q,h)
  b=hue2rgb(p,q,h-1/3)
 end
 return math.floor(r*255),math.floor(g*255),math.floor(b*255)
end
-- 十六进制颜色字符串转 RGB
local function hex_to_rgb(hex_str)
 if not hex_str or type(hex_str)~="string" then
  return nil
 end
 local hex=hex_str:match("^0x(.+)$") or hex_str:match("^#(.+)$")
 if not hex then
  return nil
 end
 if #hex==3 then
  local r=tonumber(hex:sub(1,1),16)*17
  local g=tonumber(hex:sub(2,2),16)*17
  local b=tonumber(hex:sub(3,3),16)*17
  return r,g,b
 elseif #hex==6 then
  local r=tonumber(hex:sub(1,2),16)
  local g=tonumber(hex:sub(3,4),16)
  local b=tonumber(hex:sub(5,6),16)
  return r,g,b
 elseif #hex==8 then
  local r=tonumber(hex:sub(3,4),16)
  local g=tonumber(hex:sub(5,6),16)
  local b=tonumber(hex:sub(7,8),16)
  return r,g,b
 end
 return nil
end

-- RGB 转十六进制
local function rgb_to_hex(r,g,b,a)
 if a then
  return string.format("0x%02x%02x%02x%02x",a,r,g,b)
 else
  return string.format("0x%02x%02x%02x",r,g,b)
 end
end
--- ---
--- Filter 命名空间：滤镜引擎
--- ---
local Filter={}
-- 计算行内位置百分比
local function calculate_position_percentage(key_index_in_row,keyboard,row_keys,key_width_default)
 local total_width=0
 for _,key in ipairs(row_keys) do
  total_width=total_width+(key.width or keyboard.width or key_width_default or 10)
 end
 local accumulated_width=0
 for i=1,key_index_in_row-1 do
  accumulated_width=accumulated_width+(row_keys[i].width or keyboard.width or key_width_default or 10)
 end
 local current_key_width=row_keys[key_index_in_row].width or keyboard.width or key_width_default or 10
 local center_position=accumulated_width+current_key_width/2
 return center_position/total_width
end

function Filter.apply_on_key_to_all(config,filter_name,filter_func)
 local original_schemes={}
 for scheme_name,_ in pairs(config.preset_color_schemes) do
  if not string.find(scheme_name,"_"..filter_name.."$") then
   table.insert(original_schemes,scheme_name)
  end
 end
 for _,scheme_name in ipairs(original_schemes) do
  Filter.apply_on_key(config,scheme_name,filter_name,filter_func)
 end
end
-- 应用方案级滤镜
function Filter.apply_on_scheme(config,scheme_name,filter_name,filter_func)
 local current_scheme=config.preset_color_schemes[scheme_name]
 if not current_scheme then
  error("配色方案不存在: "..scheme_name)
 end
 local new_scheme_name=scheme_name.."_"..filter_name
 local new_scheme=std.deepcopy(current_scheme)
 new_scheme.name=current_scheme.name.." - "..filter_name
 local modified_colors=filter_func(current_scheme)
 for color_key,color_value in pairs(modified_colors) do
  new_scheme[color_key]=color_value
 end
 config.preset_color_schemes[new_scheme_name]=new_scheme
 return new_scheme_name
end
function Filter.apply_on_scheme_to_all(config,filter_name,filter_func)
 local original_schemes={}
 for scheme_name,_ in pairs(config.preset_color_schemes) do
  if not string.find(scheme_name,"_"..filter_name.."$") then
   table.insert(original_schemes,scheme_name)
  end
 end
 for _,scheme_name in ipairs(original_schemes) do
  Filter.apply_on_scheme(config,scheme_name,filter_name,filter_func)
 end
end
local presets={}
-- 彩虹滤镜（按键级）
function presets.rainbow_on_key(key_data,key_index,keyboard,key_width_default)
 local rows={}
 local current_row={}
 local current_width=0
 for _,key in ipairs(keyboard.keys) do
  local w=key.width or keyboard.width or key_width_default or 10
  if w==0 then
   if #current_row>0 then
    table.insert(rows,current_row)
    current_row={}
    current_width=0
   end
  else
   if current_width+w>100 and #current_row>0 then
    table.insert(rows,current_row)
    current_row={}
    current_width=0
   end
   table.insert(current_row,key)
   current_width=current_width+w
  end
 end
 if #current_row>0 then
  table.insert(rows,current_row)
 end
 local key_in_row_index=0
 local target_row=nil
 for _,row in ipairs(rows) do
  for i,key_in_row in ipairs(row) do
   if key_in_row==key_data then
    key_in_row_index=i
    target_row=row
    break
   end
  end
  if target_row then break end
 end
 if not target_row then
  return nil
 end
 local position_percentage=calculate_position_percentage(key_in_row_index,keyboard,target_row,key_width_default)
 local h=position_percentage
 local s=1
 local l=0.1
 local r,g,b=hsl_to_rgb(h,s,l)
 local bg_hex_color=string.format("#%02x%02x%02x",r,g,b)
 local bg_color="0x"..bg_hex_color:sub(2)
 local text_r,text_g,text_b=hsl_to_rgb((h+0.5)%1,1,math.min(0.625,1.0))
 local text_hex_color=string.format("#%02x%02x%02x",text_r,text_g,text_b)
 local text_color="0x"..text_hex_color:sub(2)
 return {
  key_back_color=bg_color,
  key_text_color=text_color,
  key_symbol_color=text_color,
 }
end
-- 反转滤镜（方案级）
function presets.invert_on_scheme(scheme)
 local inverted={}
 for color_key,color_value in pairs(scheme) do
  if type(color_value)=="string" and (color_value:match("^0x") or color_value:match("^#")) then
   local r,g,b=hex_to_rgb(color_value)
   if r and g and b then
    r=255-r
    g=255-g
    b=255-b
    inverted[color_key]=rgb_to_hex(r,g,b)
   end
  end
 end
 return inverted
end
-- 灰度滤镜（方案级）
function presets.grayscale_on_scheme(scheme)
 local grayscale={}
 for color_key,color_value in pairs(scheme) do
  if type(color_value)=="string" and (color_value:match("^0x") or color_value:match("^#")) then
   local r,g,b=hex_to_rgb(color_value)
   if r and g and b then
    local gray=math.floor(0.299*r+0.587*g+0.114*b)
    grayscale[color_key]=rgb_to_hex(gray,gray,gray)
   end
  end
 end
 return grayscale
end
Filter.presets=presets
return Filter
