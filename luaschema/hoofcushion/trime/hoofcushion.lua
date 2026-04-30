---@type hoofcushion.trime.colors
local color_strref=setmetatable({},{__index=function(_,k) return k end})
---@type hoofcushion.trime.preset_keys
local preset_keys_strref=setmetatable({},{__index=function(_,k) return k end})
local ratio_config={
 default={0.8,0.8,1,1,1,1,0.8},
}
local offset_config={
 keyboard={
  key_hint_offset_x=0,
  key_hint_offset_y=0,
  key_press_offset_x=0,
  key_press_offset_y=0,
  key_symbol_offset_x=0,
  key_symbol_offset_y=-2,
  key_text_offset_x=0,
  key_text_offset_y=0,
 },
 upper_right={
  key_symbol_offset_x=12,
  key_symbol_offset_y=0,
 },
 upper_left={
  key_symbol_offset_x=-12,
  key_symbol_offset_y=0,
 },
 lower_right={
  key_symbol_offset_x=12,
  key_symbol_offset_y=20,
 },
 lower_left={
  key_symbol_offset_x=-12,
  key_symbol_offset_y=20,
 },
}
--- ---
--- basic tool
--- ---
local function deepcopy(t)
 if type(t)~="table" then
  return t
 end
 local ret={}
 for k,v in pairs(t) do
  ret[deepcopy(k)]=deepcopy(v)
 end
 return ret
end
local NIL={}
local function extend(dst,...)
 dst=dst or {}
 for i=1,select("#",...) do
  local t=select(i,...)
  if t then
   for k,v in pairs(t) do
    if v==NIL then
     dst[k]=nil
    else
     dst[k]=v
    end
   end
  end
 end
 return dst
end
local function merge(...)
 return extend({},...)
end
local function walk(t,f)
 for k,v in pairs(t) do
  f(t,k,v)
  if type(v)=="table" then
   walk(v,f)
  end
 end
end
local fns={}
local function defer(fn)
 table.insert(fns,fn)
end
local function run()
 for _,fn in ipairs(fns) do
  fn()
 end
end
local Filter=require("hoofcushion.trime.filter")
local Trime=require("hoofcushion.trime.trime")
local M={
 config_version="3.0",
 name="hoofcushion",
 trime="hoofcushion",
 author="hoofcushion",
 -- 键盘样式配置
 style=Trime.style,

 preedit=Trime.preedit,
 -- 候选窗口（悬浮窗）参数
 window=Trime.window,
}
local text_size_factor=0.75
defer(function()
 walk(M.style,function(t,k,v)
  if string.find(k,"text_size",nil,true)~=nil
  or string.find(k,"font_size",nil,true)~=nil
  then
   t[k]=math.max(0.1,v*text_size_factor)
  end
 end)
end)
---@class hoofcushion.trime.colors
M.fallback_colors=Trime.fallback_colors
local function c(str)
 return "0x"..str:sub(2)
end
---@type table<string,hoofcushion.trime.colors>
M.preset_color_schemes=merge(Trime.preset_color_schemes,{
 default_light={
  name                        ="默认",
  back_color                  =c("#e4e7e9"),
  border_color                =c("#c1c7ca"),
  candidate_separator_color   =c("#c1c7ca"),
  candidate_text_color        =c("#5a676e"),
  comment_text_color          =c("#7b868c"),
  hilited_back_color          =c("#ccd3d7".."da"),
  hilited_candidate_back_color=c("#d3d7da"),
  hilited_candidate_text_color=c("#000000"),
  hilited_comment_text_color  =c("#000000"),
  hilited_key_back_color      =c("#d3d7da"),
  hilited_key_symbol_color    =c("#000000"),
  hilited_key_text_color      =c("#000000"),
  hilited_off_key_back_color  =c("#d3d7da"),
  hilited_off_key_text_color  =c("#000000"),
  hilited_on_key_back_color   =c("#d3d7da"),
  hilited_on_key_text_color   =c("#000000"),
  hilited_text_color          =c("#23948e"),
  key_back_color              =c("#eceff1"),
  key_symbol_color            =c("#5f6b73"),
  key_text_color              =c("#37474f"),
  keyboard_back_color         =c("#ffffff"),
  label_color                 =c("#000000"),
  off_key_back_color          =c("#d3d7da"),
  off_key_text_color          =c("#000000"),
  on_key_back_color           =c("#23948e"),
  on_key_text_color           =c("#37474f"),
  preview_back_color          =c("#55bfbf".."bf"),
  preview_text_color          =c("#23948e"),
  shadow_color                =c("#000000"),
  text_color                  =c("#5a676e"),
  text_back_color             =c("#cce4e7".."e9"),
 },
 default_dark={
  name                ="默认黑暗",
  text_color          =c("#eeeeee"),
  back_color          =c("#101010"),
  off_key_text_color  =c("#eeeeee"),
  off_key_back_color  =c("#080808"),

  border_color        =c("#202020"),
  keyboard_back_color =c("#202020"),
  preview_back_color  =c("#202020"),
  preview_text_color  =c("#eeeeee"),

  comment_text_color  =c("#cc4488"),
  hilited_text_color  =c("#cc4488"),
  hilited_back_color  =c("#404040"),
  candidate_text_color=c("#eeeeee"),
  candidate_background=c("#202020"),
 },
})
---@class hoofcushion.trime.preset_keys
M.preset_keys={
 Shift_L                  ={functional=true,label="上档",send="Shift_L"},
 Shift_L_Lock             ={functional=true,label="大写锁",send="Shift_L",shift_lock="long"},
 Return                   ={functional=true,label="enter_labels",send="Return"},
 Escape                   ={functional=true,label="取消",send="Escape"},
 BackSpace                ={functional=true,repeatable=true,label="退格",send="BackSpace"},
 Delete                   ={functional=true,repeatable=true,label="刪除",send="Delete"},
 Home                     ={functional=true,repeatable=true,label="行首",send="Home"},
 End                      ={functional=true,repeatable=true,label="行尾",send="End"},
 Page_Up                  ={functional=true,repeatable=true,label="上页",send="Page_Up"},
 Page_Down                ={functional=true,repeatable=true,label="下页",send="Page_Down"},
 Left                     ={functional=true,repeatable=true,label="←",send="Left"},
 Down                     ={functional=true,repeatable=true,label="↓",send="Down"},
 Up                       ={functional=true,repeatable=true,label="↑",send="Up"},
 Right                    ={functional=true,repeatable=true,label="→",send="Right"},
 Mode_switch              ={functional=true,toggle="ascii_mode",send="Mode_switch",states={"中文","西文"}},
 Shape_switch             ={functional=true,toggle="full_shape",send="Mode_switch",states={"半角","全角"}},
 Simp_switch              ={functional=true,toggle="simplification",send="Mode_switch",states={"汉字","漢字"}},
 Punct_switch             ={functional=true,toggle="ascii_punct",send="Mode_switch",states={"。，","．，"}},
 IME_switch               ={functional=true,label="语言",send="LANGUAGE_SWITCH"},
 Menu                     ={functional=true,label="菜单",send="Menu"},
 Settings                 ={functional=true,label="设置",send="SETTINGS"},
 Color_settings           ={functional=true,label="配色",send="SETTINGS",option="color"},
 Theme_settings           ={functional=true,label="主題",send="SETTINGS",option="theme"},
 Schema_settings          ={functional=true,label="方案",send="SETTINGS",option="schema"},
 Voice                    ={functional=true,label="语音",command="run",option="android.speech.action.RECOGNIZE_SPEECH"},
 Hide                     ={functional=true,label="隐藏",send="BACK"},
 Keyboard_number          ={functional=true,label="数字",send="Eisu_toggle",select="number"},
 Keyboard_default         ={functional=true,label="字母",send="Eisu_toggle",select="default"},
 Keyboard_back            ={functional=true,label="返回",send="Eisu_toggle",select=".default"},
 Select_All               ={functional=true,label="全选",send="Control+a"},
 Cut                      ={functional=true,label="剪切",send="Control+x"},
 Copy                     ={functional=true,label="复制",send="Control+c"},
 Paste                    ={functional=true,label="粘贴",send="Control+v"},
 Undo                     ={functional=true,label="撤销",send="Control+z"},
 Redo                     ={functional=true,label="重做",send="Control+Shift+z"},
 Remove_Left              ={functional=true,label="左清",text="{Shift+Home}{Delete}"},
 liquid_keyboard_switch   ={functional=true,label="更多",send="function",command="liquid_keyboard",option="更多"},
 liquid_keyboard_exit     ={functional=true,label="返回",send="function",command="liquid_keyboard",option="-1"},
 liquid_keyboard_clipboard={functional=true,label="剪贴",send="function",command="liquid_keyboard",option="剪贴"},
 asciitilde               ={functional=false,label="~",send="~"},
 grave                    ={functional=false,label="`",send="`"},
 exclam                   ={functional=false,label="!",send="!"},
 at                       ={functional=false,label="@",send="@"},
 numbersign               ={functional=false,label="#",send="#"},
 dollar                   ={functional=false,label="$",send="$"},
 percent                  ={functional=false,label="%",send="%"},
 asciicircum              ={functional=false,label="^",send="^"},
 ampersand                ={functional=false,label="&",send="&"},
 asterisk                 ={functional=false,label="*",send="*"},
 parenleft                ={functional=false,label="(",send="("},
 parenright               ={functional=false,label=")",send=")"},
 minus                    ={functional=false,label="-",send="-"},
 underscore               ={functional=false,label="_",send="_"},
 plus                     ={functional=false,label="+",send="+"},
 equal                    ={functional=false,label="= ",send="= "},
 Tab_char                 ={functional=false,label="\\t",send="\t"},
 Tab                      ={functional=false,label="Tab",send="\t"},
 delimiter                ={functional=false,label="'",send="'"},
 pairs_paren              ={functional=false,label="()",text="(){Left}"},
 pairs_bracket            ={functional=false,label="[]",text="[]{Left}"},
 pairs_brace              ={functional=false,label="{}",text="{}{Left}"},
 pairs_angle              ={functional=false,label="<>",text="<>{Left}"},
 pairs_double_quote       ={functional=false,label="\"\"",text="\"\"{Left}"},
 pairs_single_quote       ={functional=false,label="''",text="''{Left}"},
 -- # exclam	!
 -- # quotedbl	"
 -- # numbersign	#
 -- # dollar	$
 -- # percent	%
 -- # ampersand	&
 -- # apostrophe	'
 -- # parenleft	(
 -- # parenright	)
 -- # asterisk	*
 -- # plus	+
 -- # comma	,
 -- # minus	-
 -- # period	.
 -- # slash	/
 -- # colon	:
 -- # semicolon	;
 -- # less	<
 -- # equal	=
 -- # greater	>
 -- # question	?
 -- # at	@
 -- # bracketleft	[
 -- # backslash	\
 -- # bracketright	]
 -- # asciicircum	^
 -- # underscore	_
 -- # grave	`
 -- # braceleft	{
 -- # bar	|
 -- # braceright	}
 -- # asciitilde	~
}
local function apply_size(ratio_list,t)
 local total_height=M.style.keyboard_height
 local rows,current_row,current_width={},{},0
 for _,key in ipairs(t) do
  local width=key.width or M.style.key_width or 10
  if current_width+width>100 then
   table.insert(rows,current_row)
   current_row,current_width={},0
  end
  table.insert(current_row,key)
  current_width=current_width+width
 end
 if #current_row>0 then
  table.insert(rows,current_row)
 end
 local total_ratio=0
 for _,ratio in ipairs(ratio_list) do
  total_ratio=total_ratio+ratio
 end
 for i,row in ipairs(rows) do
  local row_height=total_height*(ratio_list[i] or 1)/total_ratio
  for _,key in ipairs(row) do
   key.height=row_height
  end
 end
 return t
end
local key_specs={
 status_mode=merge({click=preset_keys_strref.Mode_switch}),
 status_shape=merge({click=preset_keys_strref.Shape_switch}),
 status_simp=merge({click=preset_keys_strref.Simp_switch}),
 status_punct=merge({click=preset_keys_strref.Punct_switch}),
 status_deploy=merge({click=preset_keys_strref.IME_switch}),
 status_menu=merge({click=preset_keys_strref.Menu}),
 status_settings=merge({click=preset_keys_strref.Settings}),
 status_color=merge({click=preset_keys_strref.Color_settings}),
 status_theme=merge({click=preset_keys_strref.Theme_settings}),
 status_schema=merge({click=preset_keys_strref.Schema_settings}),
 status_voice=merge({click=preset_keys_strref.Voice}),
 status_hide=merge({click=preset_keys_strref.Hide}),
 key_1=merge({click="1"},{swipe_left=preset_keys_strref.exclam,swipe_right=preset_keys_strref.exclam,long_click=preset_keys_strref.exclam,swipe_up=preset_keys_strref.exclam,swipe_down=preset_keys_strref.exclam},offset_config.upper_right),
 key_2=merge({click="2"},{swipe_left=preset_keys_strref.at,swipe_right=preset_keys_strref.at,long_click=preset_keys_strref.at,swipe_up=preset_keys_strref.at,swipe_down=preset_keys_strref.at},offset_config.upper_right),
 key_3=merge({click="3"},{swipe_left=preset_keys_strref.numbersign,swipe_right=preset_keys_strref.numbersign,long_click=preset_keys_strref.numbersign,swipe_up=preset_keys_strref.numbersign,swipe_down=preset_keys_strref.numbersign},offset_config.upper_right),
 key_4=merge({click="4"},{swipe_left=preset_keys_strref.dollar,swipe_right=preset_keys_strref.dollar,long_click=preset_keys_strref.dollar,swipe_up=preset_keys_strref.dollar,swipe_down=preset_keys_strref.dollar},offset_config.upper_right),
 key_5=merge({click="5"},{swipe_left=preset_keys_strref.percent,swipe_right=preset_keys_strref.percent,long_click=preset_keys_strref.percent,swipe_up=preset_keys_strref.percent,swipe_down=preset_keys_strref.percent},offset_config.upper_right),
 key_home=merge({click=preset_keys_strref.Home}),
 key_up=merge({click=preset_keys_strref.Up}),
 key_end=merge({click=preset_keys_strref.End}),
 key_page_up=merge({click=preset_keys_strref.Page_Up}),
 key_backspace_1=merge({click=preset_keys_strref.BackSpace}),
 key_6=merge({click="6"},{swipe_left=preset_keys_strref.asciicircum,swipe_right=preset_keys_strref.asciicircum,long_click=preset_keys_strref.asciicircum,swipe_up=preset_keys_strref.asciicircum,swipe_down=preset_keys_strref.asciicircum},offset_config.upper_right),
 key_7=merge({click="7"},{swipe_left=preset_keys_strref.ampersand,swipe_right=preset_keys_strref.ampersand,long_click=preset_keys_strref.ampersand,swipe_up=preset_keys_strref.ampersand,swipe_down=preset_keys_strref.ampersand},offset_config.upper_right),
 key_8=merge({click="8"},{swipe_left=preset_keys_strref.asterisk,swipe_right=preset_keys_strref.asterisk,long_click=preset_keys_strref.asterisk,swipe_up=preset_keys_strref.asterisk,swipe_down=preset_keys_strref.asterisk},offset_config.upper_right),
 key_9=merge({click="9"},{swipe_left=preset_keys_strref.grave,swipe_right=preset_keys_strref.grave,long_click=preset_keys_strref.grave,swipe_up=preset_keys_strref.grave,swipe_down=preset_keys_strref.grave},offset_config.upper_right),
 key_0=merge({click="0"},{swipe_left=preset_keys_strref.asciitilde,swipe_right=preset_keys_strref.asciitilde,long_click=preset_keys_strref.asciitilde,swipe_up=preset_keys_strref.asciitilde,swipe_down=preset_keys_strref.asciitilde},offset_config.upper_right),
 key_left=merge({click=preset_keys_strref.Left}),
 key_down=merge({click=preset_keys_strref.Down}),
 key_right=merge({click=preset_keys_strref.Right}),
 key_page_down=merge({click=preset_keys_strref.Page_Down}),
 key_delete=merge({click=preset_keys_strref.Delete}),
 key_q=merge({click="q"},{swipe_left=preset_keys_strref.Escape,swipe_right=preset_keys_strref.Escape,long_click=preset_keys_strref.Escape,swipe_up=preset_keys_strref.Escape,swipe_down=preset_keys_strref.Escape}),
 key_w=merge({click="w"}),
 key_e=merge({click="e"}),
 key_r=merge({click="r"}),
 key_t=merge({click="t"},{swipe_left=preset_keys_strref.Tab_char,swipe_right=preset_keys_strref.Tab_char,long_click=preset_keys_strref.Tab_char,swipe_up=preset_keys_strref.Tab_char,swipe_down=preset_keys_strref.Tab_char}),
 key_y=merge({click="y"}),
 key_u=merge({click="u"},{swipe_left="[",swipe_right="]",long_click=preset_keys_strref.pairs_bracket,swipe_up=preset_keys_strref.pairs_bracket,swipe_down=preset_keys_strref.pairs_bracket,label_symbol="[   ]"}),
 key_i=merge({click="i"},{swipe_left="{",swipe_right="}",long_click=preset_keys_strref.pairs_brace,swipe_up=preset_keys_strref.pairs_brace,swipe_down=preset_keys_strref.pairs_brace,label_symbol="{   }"}),
 key_o=merge({click="o"},{swipe_left="(",swipe_right=")",long_click=preset_keys_strref.pairs_paren,swipe_up=preset_keys_strref.pairs_paren,swipe_down=preset_keys_strref.pairs_paren,label_symbol="(   )"}),
 key_p=merge({click="p"},{swipe_left=preset_keys_strref.Hide,swipe_right=preset_keys_strref.Hide,long_click=preset_keys_strref.Hide,swipe_up=preset_keys_strref.Hide,swipe_down=preset_keys_strref.Hide}),
 key_a=merge({click="a"},{swipe_left=preset_keys_strref.Tab,swipe_right=preset_keys_strref.Tab,long_click=preset_keys_strref.Tab,swipe_up=preset_keys_strref.Tab,swipe_down=preset_keys_strref.Tab}),
 key_s=merge({click="s"},{swipe_left=preset_keys_strref.Home,swipe_right=preset_keys_strref.End,label_symbol="↞   ↠"}),
 key_d=merge({click="d"}),
 key_f=merge({click="f"},{swipe_left=preset_keys_strref.Undo,swipe_right=preset_keys_strref.Undo,long_click=preset_keys_strref.Undo,swipe_up=preset_keys_strref.Undo,swipe_down=preset_keys_strref.Undo,label_symbol="↺"}),
 key_g=merge({click="g"},{swipe_left=preset_keys_strref.Redo,swipe_right=preset_keys_strref.Redo,long_click=preset_keys_strref.Redo,swipe_up=preset_keys_strref.Redo,swipe_down=preset_keys_strref.Redo,label_symbol="↻"}),
 key_h=merge({click="h"},{swipe_left=":",swipe_right=";",label_symbol=":   ;"}),
 key_j=merge({click="j"},{swipe_left="\"",swipe_right="'",long_click=preset_keys_strref.pairs_double_quote,swipe_up=preset_keys_strref.pairs_single_quote,swipe_down=preset_keys_strref.pairs_single_quote,label_symbol="\"   '"}),
 key_k=merge({click="k"},{swipe_left="/",swipe_right="\\",long_click="|",swipe_up="|",swipe_down="|",label_symbol="/ | \\"}),
 key_l=merge({click="l"}),
 key_semicolon=merge({click=";"},{swipe_left=preset_keys_strref.delimiter,swipe_right=preset_keys_strref.delimiter,long_click=preset_keys_strref.delimiter,swipe_up=preset_keys_strref.delimiter,swipe_down=preset_keys_strref.delimiter}),
 key_shift=merge({click=preset_keys_strref.Shift_L,long_click=preset_keys_strref.Shift_L_Lock}),
 key_z=merge({click="z"},{swipe_left=preset_keys_strref.Select_All,swipe_right=preset_keys_strref.Select_All,long_click=preset_keys_strref.Select_All,swipe_up=preset_keys_strref.Select_All,swipe_down=preset_keys_strref.Select_All}),
 key_x=merge({click="x"},{swipe_left=preset_keys_strref.Cut,swipe_right=preset_keys_strref.Cut,long_click=preset_keys_strref.Cut,swipe_up=preset_keys_strref.Cut,swipe_down=preset_keys_strref.Cut}),
 key_c=merge({click="c"},{swipe_left=preset_keys_strref.Copy,swipe_right=preset_keys_strref.Copy,long_click=preset_keys_strref.Copy,swipe_up=preset_keys_strref.Copy,swipe_down=preset_keys_strref.Copy}),
 key_v=merge({click="v"},{swipe_left=preset_keys_strref.Paste,swipe_right=preset_keys_strref.Paste,long_click=preset_keys_strref.Paste,swipe_up=preset_keys_strref.Paste,swipe_down=preset_keys_strref.Paste}),
 key_b=merge({click="b"},{swipe_left="<",swipe_right=">",long_click=preset_keys_strref.pairs_angle,swipe_up=preset_keys_strref.pairs_angle,label_symbol="<   >"}),
 key_n=merge({click="n"},{swipe_left="+",swipe_right="-",label_symbol="+   -"}),
 key_m=merge({click="m"},{swipe_left="_",swipe_right="=",label_symbol="_   ="}),

 key_backspace_2=merge({click=preset_keys_strref.BackSpace},{swipe_left=preset_keys_strref.Remove_Left,swipe_right=preset_keys_strref.Remove_Left,swipe_up=preset_keys_strref.Remove_Left,swipe_down=preset_keys_strref.Remove_Left,label_symbol="左清"}),
 key_keyboard_number=merge({click=preset_keys_strref.Keyboard_number},{long_click=preset_keys_strref.liquid_keyboard_clipboard}),
 key_keyboard_back=merge({click=preset_keys_strref.Keyboard_back},{long_click=preset_keys_strref.liquid_keyboard_clipboard}),
 key_comma=merge({click=","},{swipe_left="!",swipe_right="!",long_click="!",swipe_up="!",swipe_down="!",label_symbol="!"}),
 key_space=merge({click=preset_keys_strref.space},{long_click=preset_keys_strref.Mode_switch,swipe_up=preset_keys_strref.Mode_switch,swipe_left=preset_keys_strref.Left,swipe_right=preset_keys_strref.Right}),
 key_period=merge({click="."},{swipe_left="?",swipe_right="?",long_click="?",swipe_up="?",swipe_down="?",label_symbol="?"}),
 key_return=merge({click=preset_keys_strref.Return},{long_click=preset_keys_strref.Menu,swipe_up=preset_keys_strref.Theme_settings,swipe_left=preset_keys_strref.Color_settings}),
 key_line={width=100},
}
M.liquid_keyboard={
 row            =5,
 row_land       =5,
 key_height     =60,
 key_height_land=60,
 single_width   =60,
 vertical_gap   =M.style.vertical_gap,
 margin_x       =M.style.horizontal_gap,
 fixed_key_bar  ={
  position="bottom",
  keys={
   preset_keys_strref.liquid_keyboard_exit,
   preset_keys_strref.space,
   preset_keys_strref.BackSpace,
   preset_keys_strref.Return,
   preset_keys_strref.liquid_keyboard_clipboard,
   preset_keys_strref.liquid_keyboard_switch,
  },
 },
 keyboards      ={"tabs","candidate","history","clipboard","collection","draft"},
 tabs           ={name="更多",type="TABS"},
 candidate      ={name="候选",type="CANDIDATE"},
 history        ={name="常用",type="HISTORY"},
 clipboard      ={type="CLIPBOARD",name="剪贴"},
 collection     ={type="COLLECTION",name="收藏"},
 draft          ={type="DRAFT",name="草稿"},
}
M.preset_keyboards={}
defer(function()
 M.preset_keyboards=deepcopy(M.preset_keyboards)
 for _,keyboard in pairs(M.preset_keyboards) do
  if keyboard.offset then
   extend(keyboard,keyboard.offset)
   keyboard.offset=nil
  end
  if keyboard.height_ratio then
   local heights=keyboard.height_ratio
   apply_size(heights,keyboard.keys)
   keyboard.height_ratio=nil
  end
 end
end)
M.preset_keyboards.default={
 name="默认",
 ascii_mode=0,
 lock=true,
 width=10,
 offsets=offset_config.keyboard,
 height_ratio=ratio_config.default,
 keys={
  {width=0},
  merge(key_specs.key_1),
  merge(key_specs.key_2),
  merge(key_specs.key_3),
  merge(key_specs.key_4),
  merge(key_specs.key_5),
  merge(key_specs.key_home),
  merge(key_specs.key_up),
  merge(key_specs.key_end),
  merge(key_specs.key_page_up),
  merge(key_specs.key_backspace_1),
  {width=0},
  merge(key_specs.key_6),
  merge(key_specs.key_7),
  merge(key_specs.key_8),
  merge(key_specs.key_9),
  merge(key_specs.key_0),
  merge(key_specs.key_left),
  merge(key_specs.key_down),
  merge(key_specs.key_right),
  merge(key_specs.key_page_down),
  merge(key_specs.key_delete),
  {width=0},
  merge(key_specs.key_q),
  merge(key_specs.key_w),
  merge(key_specs.key_e),
  merge(key_specs.key_r),
  merge(key_specs.key_t),
  merge(key_specs.key_y),
  merge(key_specs.key_u),
  merge(key_specs.key_i),
  merge(key_specs.key_o),
  merge(key_specs.key_p),
  {width=0},
  {width=5},
  merge(key_specs.key_a),
  merge(key_specs.key_s),
  merge(key_specs.key_d),
  merge(key_specs.key_f),
  merge(key_specs.key_g),
  merge(key_specs.key_h),
  merge(key_specs.key_j),
  merge(key_specs.key_k),
  merge(key_specs.key_l),
  {width=5},
  {width=0},
  merge(key_specs.key_shift,{width=15}),
  merge(key_specs.key_z),
  merge(key_specs.key_x),
  merge(key_specs.key_c),
  merge(key_specs.key_v),
  merge(key_specs.key_b),
  merge(key_specs.key_n),
  merge(key_specs.key_m),
  merge(key_specs.key_backspace_2,{width=15}),
  {width=0},
  merge(key_specs.key_keyboard_number,{width=20}),
  merge(key_specs.key_comma,{width=15}),
  merge(key_specs.key_space,{width=30}),
  merge(key_specs.key_period,{width=15}),
  merge(key_specs.key_return,{width=20}),
  {width=0},
  merge(key_specs.status_mode),
  merge(key_specs.status_shape),
  merge(key_specs.status_simp),
  merge(key_specs.status_punct),
  merge(key_specs.status_deploy),
  merge(key_specs.status_menu),
  merge(key_specs.status_settings),
  merge(key_specs.status_color),
  merge(key_specs.status_theme),
  merge(key_specs.status_schema),
 },
}
M.preset_keyboards.number={
 name="数字",
 width=10,
 offsets=offset_config.keyboard,
 height_ratio=ratio_config.default,
 keys={
  key_specs.key_1,
  key_specs.key_2,
  key_specs.key_3,
  key_specs.key_4,
  key_specs.key_5,
  key_specs.key_home,
  key_specs.key_up,
  key_specs.key_end,
  key_specs.key_page_up,
  key_specs.key_backspace_1,
  key_specs.key_6,
  key_specs.key_7,
  key_specs.key_8,
  key_specs.key_9,
  key_specs.key_0,
  key_specs.key_left,
  key_specs.key_down,
  key_specs.key_right,
  key_specs.key_page_down,
  key_specs.key_delete,
  merge({click="%"}),merge({click="^"}),merge({click=1},{width=20}),merge({click=2},{width=20}),merge({click=3},{width=20}),merge({click="+"}),merge({click="-"}),
  merge({click="!"}),merge({click="|"}),merge({click=4},{width=20}),merge({click=5},{width=20}),merge({click=6},{width=20}),merge({click="*"}),merge({click="/"}),
  merge({click="("}),merge({click=")"}),merge({click=7},{width=20}),merge({click=8},{width=20}),merge({click=9},{width=10}),merge({click=0},{width=10}),merge({click="="}),merge(key_specs.key_backspace_2,{width=10}),
  merge(key_specs.key_keyboard_back,{width=20}),
  merge(key_specs.key_comma,{width=15}),
  merge(key_specs.key_space,{width=30}),
  merge(key_specs.key_period,{width=15}),
  merge(key_specs.key_return,{width=20}),
  key_specs.status_mode,
  key_specs.status_shape,
  key_specs.status_simp,
  key_specs.status_punct,
  key_specs.status_deploy,
  key_specs.status_menu,
  key_specs.status_settings,
  key_specs.status_color,
  key_specs.status_theme,
  key_specs.status_schema,
  -- keys.key_line,
 },
}
-- 删除所有按键的滑动、长按和长按标签功能
-- defer(function()
-- walk(M.preset_keyboards, function(t, k, v)
-- if type(k) == "number" and type(v) == "table" then
-- -- 删除滑动相关
-- v.swipe_left = nil
-- v.swipe_right = nil
-- v.swipe_up = nil
-- v.swipe_down = nil
-- -- 删除长按相关
-- v.long_click = nil
-- -- 删除长按标签
-- v.label_symbol = nil
-- end
-- end)
-- end)
run()
return M
