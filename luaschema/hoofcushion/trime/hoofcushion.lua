local fns={}
local function defer(fn)
 table.insert(fns,fn)
end
local function run()
 for _,fn in ipairs(fns) do
  fn()
 end
end
local M={
 config_version="3.0",
 name="hoofcushion",
 trime="hoofcushion",
 author="hoofcushion",
 style={
  -- candidate_font="han.ttf",
  -- comment_font="comment.ttf",
  -- hanb_font="hanb.ttf",
  -- key_font="symbol.ttf",
  -- label_font="label.ttf",
  -- latin_font="latin.ttf",
  -- long_text_font="comment.ttf",
  -- preview_font="latin.ttf",
  -- symbol_font="symbol.ttf",
  -- text_font="latin.ttf",
  auto_caps=false,
  background_dim_amount=0.5,
  candidate_padding=5,
  candidate_spacing=0.5,
  candidate_text_size=22,
  candidate_use_cursor=true,
  candidate_view_height=30,
  color_scheme="default_dark",
  comment_height=12,
  comment_on_top=true,
  comment_text_size=12,
  enter_label_mode=0,
  enter_labels={go="前往",done="完成",next="下个",pre="上个",search="搜索",send="发送",default="Enter"},
  horizontal=true,
  horizontal_gap=2,
  key_height=60,
  key_long_text_border=1,
  key_long_text_size=20,
  key_text_size=22,
  key_width=10.0,
  keyboard_height=380,
  keyboard_height_land=340,
  keyboard_padding=0,
  keyboard_padding_bottom=0,
  keyboard_padding_land=40,
  keyboard_padding_land_bottom=0,
  keyboard_padding_left=0,
  keyboard_padding_right=40,
  keyboards={".default","letter","number"},
  label_text_size=22,
  latin_locale="en_US",
  layout={
   all_phrases=false,
   alpha="0xdd",
   border=2,
   elevation=5,
   line_spacing=0,
   line_spacing_multiplier=1.2,
   margin_bottom=0,
   margin_x=5,
   margin_y=5,
   max_entries=1,
   max_height=400,
   max_length=10,
   max_width=230,
   min_check=3,
   min_height=0,
   min_length=5,
   min_width=40,
   movable="once",
   position="fixed",
   real_margin=3,
   round_corner=0,
   spacing=1,
   sticky_lines=0,
   sticky_lines_land=0,
  },
  locale="zh_CN",
  preview_height=60,
  preview_offset=-12,
  preview_text_size=40,
  proximity_correction=true,
  reset_ascii_mode=false,
  round_corner=0,
  shadow_radius=0.0,
  speech_opencc_config="", --"t2s.json",
  symbol_text_size=10,
  text_size=16,
  vertical_correction=-10,
  vertical_gap=2,
  window={
   {start="",composition="%s",["end"]="",letter_spacing=0},
   {start="",move="ㄓ ",["end"]=""},
   {start="\n",label="%s.",candidate="%s",comment=" %s",["end"]="",sep=" "},
  },
 },
}
---@class trime.colors
M.fallback_colors={
 candidate_text_color        ="text_color",
 comment_text_color          ="candidate_text_color",
 border_color                ="back_color",
 candidate_separator_color   ="border_color",
 hilited_text_color          ="text_color",
 hilited_back_color          ="back_color",
 hilited_candidate_text_color="hilited_text_color",
 hilited_candidate_back_color="hilited_back_color",
 hilited_label_color         ="hilited_candidate_text_color",
 hilited_comment_text_color  ="comment_text_color",
 hilited_key_back_color      ="hilited_candidate_back_color",
 hilited_key_text_color      ="hilited_candidate_text_color",
 hilited_key_symbol_color    ="hilited_comment_text_color",
 hilited_off_key_back_color  ="hilited_key_back_color",
 hilited_on_key_back_color   ="hilited_key_back_color",
 hilited_off_key_text_color  ="hilited_key_text_color",
 hilited_on_key_text_color   ="hilited_key_text_color",
 key_back_color              ="back_color",
 key_border_color            ="border_color",
 key_text_color              ="candidate_text_color",
 key_symbol_color            ="comment_text_color",
 label_color                 ="candidate_text_color",
 off_key_back_color          ="key_back_color",
 off_key_text_color          ="key_text_color",
 on_key_back_color           ="hilited_key_back_color",
 on_key_text_color           ="hilited_key_text_color",
 preview_back_color          ="key_back_color",
 preview_text_color          ="key_text_color",
 shadow_color                ="border_color",
 root_background             ="back_color",
 candidate_background        ="back_color",
 keyboard_back_color         ="border_color",
 liquid_keyboard_background  ="keyboard_back_color",
 text_back_color             ="back_color",
 long_text_back_color        ="key_back_color",
 key_back_indicator_1        ="key_back_color",
 key_back_indicator_2        ="key_back_color",
 key_back_indicator_3        ="key_back_color",
 key_back_indicator_4        ="key_back_color",
 key_back_indicator_5        ="key_back_color",
}
local function c(str)
 return "0x"..str:sub(2)
end
---@type table<string,trime.colors>
M.preset_color_schemes={
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
  name                ="默认",
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
  key_back_indicator_1=c("#201010"),
  key_back_indicator_2=c("#202010"),
  key_back_indicator_3=c("#102010"),
  key_back_indicator_4=c("#102020"),
  key_back_indicator_5=c("#101020"),
 },
}
---@type trime.colors
local color_config=setmetatable({},{__index=function(_,k) return k end})
---@class hoofcushion.trime.preset_keys
M.preset_keys={
 Shift_L                    ={functional=true,label="上档",send="Shift_L",shift_lock="ascii_long"},
 Return                     ={functional=true,label="enter_labels",send="Return"},
 Return2                    ={functional=true,label="回车",send="Return"},
 Escape                     ={functional=true,label="取消",send="Escape"},
 BackSpace                  ={functional=true,repeatable=true,label="退格",send="BackSpace"},
 Delete                     ={functional=true,repeatable=true,label="刪除",send="Delete"},
 Home                       ={functional=true,repeatable=true,label="行首",send="Home"},
 End                        ={functional=true,repeatable=true,label="行尾",send="End"},
 Page_Up                    ={functional=true,repeatable=true,label="上页",send="Page_Up"},
 Page_Down                  ={functional=true,repeatable=true,label="下页",send="Page_Down"},
 Left                       ={functional=true,repeatable=true,label="←",send="Left"},
 Down                       ={functional=true,repeatable=true,label="↓",send="Down"},
 Up                         ={functional=true,repeatable=true,label="↑",send="Up"},
 Right                      ={functional=true,repeatable=true,label="→",send="Right"},
 Mode_switch                ={functional=true,toggle="ascii_mode",send="Mode_switch",states={"中文","西文"}},
 Shape_switch               ={functional=true,toggle="full_shape",send="Mode_switch",states={"半角","全角"}},
 Simp_switch                ={functional=true,toggle="simplification",send="Mode_switch",states={"汉字","漢字"}},
 Punct_switch               ={functional=true,toggle="ascii_punct",send="Mode_switch",states={"。，","．，"}},
 IME_switch                 ={functional=true,label="语言",send="LANGUAGE_SWITCH"},
 Menu                       ={functional=true,label="菜单",send="Menu"},
 Settings                   ={functional=true,label="设置",send="SETTINGS"},
 Color_settings             ={functional=true,label="配色",send="SETTINGS",option="color"},
 Theme_settings             ={functional=true,label="主題",send="SETTINGS",option="theme"},
 Schema_settings            ={functional=true,label="方案",send="SETTINGS",option="schema"},
 Voice                      ={functional=true,label="语音",command="run",option="android.speech.action.RECOGNIZE_SPEECH"},
 Hide                       ={functional=true,label="隐藏",send="BACK"},
 Keyboard_number            ={functional=true,label="数字",send="Eisu_toggle",select="number"},
 Keyboard_default           ={functional=true,label="字母",send="Eisu_toggle",select="default"},
 Keyboard_back              ={functional=true,label="返回",send="Eisu_toggle",select=".default"},
 Select_All                 ={functional=true,label="全选",send="Control+a"},
 Cut                        ={functional=true,label="剪切",send="Control+x"},
 Copy                       ={functional=true,label="复制",send="Control+c"},
 Paste                      ={functional=true,label="粘贴",send="Control+v"},
 Undo                       ={functional=true,label="撤销",send="Control+z"},
 Redo                       ={functional=true,label="重做",send="Control+Shift+z"},
 Remove_Left                ={functional=true,label="左清",text="{Shift+Home}{Delete}"},
 liquid_keyboard_switch     ={functional=true,label="更多",send="function",command="liquid_keyboard",option="更多"},
 liquid_keyboard_exit       ={functional=true,label="返回",send="function",command="liquid_keyboard",option="-1"},
 liquid_keyboard_clipboard  ={functional=true,label="剪贴",send="function",command="liquid_keyboard",option="剪贴"},
 asciitilde                 ={functional=false,label="~",send="~"},
 grave                      ={functional=false,label="`",send="`"},
 exclam                     ={functional=false,label="!",send="!"},
 at                         ={functional=false,label="@",send="@"},
 numbersign                 ={functional=false,label="#",send="#"},
 dollar                     ={functional=false,label="$",send="$"},
 percent                    ={functional=false,label="%",send="%"},
 asciicircum                ={functional=false,label="^",send="^"},
 ampersand                  ={functional=false,label="&",send="&"},
 asterisk                   ={functional=false,label="*",send="*"},
 parenleft                  ={functional=false,label="(",send="("},
 parenright                 ={functional=false,label=")",send=")"},
 minus                      ={functional=false,label="-",send="-"},
 underscore                 ={functional=false,label="_",send="_"},
 plus                       ={functional=false,label="+",send="+"},
 equal                      ={functional=false,label="= ",send="= "},
 Tab_char                   ={functional=false,label="\\t",send="\t"},
 Tab                        ={functional=false,label="Tab",send="\t"},
 delimiter                  ={functional=false,label="'",send="'"},
 pairs_paren                ={functional=false,label="()",text="(){Left}"},
 pairs_bracket              ={functional=false,label="[]",text="[]{Left}"},
 pairs_brace                ={functional=false,label="{}",text="{}{Left}"},
 pairs_angle                ={functional=false,label="<>",text="<>{Left}"},
 pairs_double_quote         ={functional=false,label="\"\"",text="\"\"{Left}"},
 pairs_single_quote         ={functional=false,label="''",text="''{Left}"},
 --  # exclam	!
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
 liquid_liquid_keyboard_exit={click="liquid_keyboard_exit",width=20},
 -- liquid_space",
 -- liquid_BackSpace",
 -- liquid_Return1",
 -- liquid_liquid_keyboard_clipboard",
 -- liquid_liquid_keyboard_switch",
 --
}
---@class hoofcushion.trime.preset_keys
local K=setmetatable({},{__index=function(_,k) return k end})
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
local function extend(dst,...)
 dst=dst or {}
 for i=1,select("#",...) do
  local t=select(i,...)
  if t then
   for k,v in pairs(t) do
    dst[k]=v
   end
  end
 end
 return dst
end
local function merge(...)
 return extend({},...)
end
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
   "liquid_keyboard_exit",
   "space",
   "BackSpace",
   "Return1",
   "liquid_keyboard_clipboard",
   "liquid_keyboard_switch",
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
local ratio_config={
 default={0.6,0.6,1,1,1,1,1},
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
local keys={
 status_mode=merge({click=K.Mode_switch}),
 status_shape=merge({click=K.Shape_switch}),
 status_simp=merge({click=K.Simp_switch}),
 status_punct=merge({click=K.Punct_switch}),
 status_deploy=merge({click=K.IME_switch}),
 status_menu=merge({click=K.Menu}),
 status_settings=merge({click=K.Settings}),
 status_color=merge({click=K.Color_settings}),
 status_theme=merge({click=K.Theme_settings}),
 status_schema=merge({click=K.Schema_settings}),
 status_voice=merge({click=K.Voice}),
 status_hide=merge({click=K.Hide}),
 key_1=merge({click="1"},{swipe_left=K.exclam,swipe_right=K.exclam,long_click=K.exclam,swipe_up=K.exclam,swipe_down=K.exclam},offset_config.upper_right),
 key_2=merge({click="2"},{swipe_left=K.at,swipe_right=K.at,long_click=K.at,swipe_up=K.at,swipe_down=K.at},offset_config.upper_right),
 key_3=merge({click="3"},{swipe_left=K.numbersign,swipe_right=K.numbersign,long_click=K.numbersign,swipe_up=K.numbersign,swipe_down=K.numbersign},offset_config.upper_right),
 key_4=merge({click="4"},{swipe_left=K.dollar,swipe_right=K.dollar,long_click=K.dollar,swipe_up=K.dollar,swipe_down=K.dollar},offset_config.upper_right),
 key_5=merge({click="5"},{swipe_left=K.percent,swipe_right=K.percent,long_click=K.percent,swipe_up=K.percent,swipe_down=K.percent},offset_config.upper_right),
 key_home=merge({click=K.Home}),
 key_up=merge({click=K.Up}),
 key_end=merge({click=K.End}),
 key_page_up=merge({click=K.Page_Up}),
 key_backspace_1=merge({click=K.BackSpace}),
 key_6=merge({click="6"},{swipe_left=K.asciicircum,swipe_right=K.asciicircum,long_click=K.asciicircum,swipe_up=K.asciicircum,swipe_down=K.asciicircum},offset_config.upper_right),
 key_7=merge({click="7"},{swipe_left=K.ampersand,swipe_right=K.ampersand,long_click=K.ampersand,swipe_up=K.ampersand,swipe_down=K.ampersand},offset_config.upper_right),
 key_8=merge({click="8"},{swipe_left=K.asterisk,swipe_right=K.asterisk,long_click=K.asterisk,swipe_up=K.asterisk,swipe_down=K.asterisk},offset_config.upper_right),
 key_9=merge({click="9"},{swipe_left=K.grave,swipe_right=K.grave,long_click=K.grave,swipe_up=K.grave,swipe_down=K.grave},offset_config.upper_right),
 key_0=merge({click="0"},{swipe_left=K.asciitilde,swipe_right=K.asciitilde,long_click=K.asciitilde,swipe_up=K.asciitilde,swipe_down=K.asciitilde},offset_config.upper_right),
 key_left=merge({click=K.Left}),
 key_down=merge({click=K.Down}),
 key_right=merge({click=K.Right}),
 key_page_down=merge({click=K.Page_Down}),
 key_delete=merge({click=K.Delete}),
 key_q=merge({click="q"},{swipe_left=K.Escape,swipe_right=K.Escape,long_click=K.Escape,swipe_up=K.Escape,swipe_down=K.Escape}),
 key_w=merge({click="w"}),
 key_e=merge({click="e"}),
 key_r=merge({click="r"}),
 key_t=merge({click="t"},{swipe_left=K.Tab_char,swipe_right=K.Tab_char,long_click=K.Tab_char,swipe_up=K.Tab_char,swipe_down=K.Tab_char}),
 key_y=merge({click="y"}),
 key_u=merge({click="u"},{swipe_left="[",swipe_right="]",long_click=K.pairs_bracket,swipe_up=K.pairs_bracket,swipe_down=K.pairs_bracket,label_symbol="[   ]"}),
 key_i=merge({click="i"},{swipe_left="{",swipe_right="}",long_click=K.pairs_brace,swipe_up=K.pairs_brace,swipe_down=K.pairs_brace,label_symbol="{   }"}),
 key_o=merge({click="o"},{swipe_left="(",swipe_right=")",long_click=K.pairs_paren,swipe_up=K.pairs_paren,swipe_down=K.pairs_paren,label_symbol="(   )"}),
 key_p=merge({click="p"},{swipe_left=K.Hide,swipe_right=K.Hide,long_click=K.Hide,swipe_up=K.Hide,swipe_down=K.Hide}),
 key_a=merge({click="a"},{swipe_left=K.Tab,swipe_right=K.Tab,long_click=K.Tab,swipe_up=K.Tab,swipe_down=K.Tab}),
 key_s=merge({click="s"},{swipe_left=K.Home,swipe_right=K.End,label_symbol="↞   ↠"}),
 key_d=merge({click="d"}),
 key_f=merge({click="f"}),
 key_g=merge({click="g"},{swipe_left=K.Undo,swipe_right=K.Undo,long_click=K.Undo,swipe_up=K.Undo,swipe_down=K.Undo,label_symbol="↺"}),
 key_h=merge({click="h"},{swipe_left=K.Redo,swipe_right=K.Redo,long_click=K.Redo,swipe_up=K.Redo,swipe_down=K.Redo,label_symbol="↻"}),
 key_j=merge({click="j"},{swipe_left=":",swipe_right=";",label_symbol=":   ;"}),
 key_k=merge({click="k"},{swipe_left="\"",swipe_right="'",long_click=K.pairs_double_quote,swipe_up=K.pairs_single_quote,swipe_down=K.pairs_single_quote,label_symbol="\"   '"}),
 key_l=merge({click="l"},{swipe_left="/",swipe_right="\\",long_click="|",swipe_up="|",swipe_down="|",label_symbol="/ | \\"}),
 key_semicolon=merge({click=";"},{swipe_left=K.delimiter,swipe_right=K.delimiter,long_click=K.delimiter,swipe_up=K.delimiter,swipe_down=K.delimiter}),
 key_shift=merge({click=K.Shift_L}),
 key_z=merge({click="z"},{swipe_left=K.Select_All,swipe_right=K.Select_All,long_click=K.Select_All,swipe_up=K.Select_All,swipe_down=K.Select_All}),
 key_x=merge({click="x"},{swipe_left=K.Cut,swipe_right=K.Cut,long_click=K.Cut,swipe_up=K.Cut,swipe_down=K.Cut}),
 key_c=merge({click="c"},{swipe_left=K.Copy,swipe_right=K.Copy,long_click=K.Copy,swipe_up=K.Copy,swipe_down=K.Copy}),
 key_v=merge({click="v"},{swipe_left=K.Paste,swipe_right=K.Paste,long_click=K.Paste,swipe_up=K.Paste,swipe_down=K.Paste}),
 key_b=merge({click="b"},{swipe_left="<",swipe_right=">",long_click=K.pairs_angle,swipe_up=K.pairs_angle,label_symbol="<   >"}),
 key_n=merge({click="n"},{swipe_left="+",swipe_right="-",label_symbol="+   -"}),
 key_m=merge({click="m"},{swipe_left="_",swipe_right="=",label_symbol="_   ="}),

 key_backspace_2=merge({click=K.BackSpace},{swipe_left=K.Remove_Left,swipe_right=K.Remove_Left,swipe_up=K.Remove_Left,swipe_down=K.Remove_Left,label_symbol="左清"}),
 key_keyboard_number=merge({click=K.Keyboard_number},{long_click=K.liquid_keyboard_clipboard}),
 key_keyboard_back=merge({click=K.Keyboard_back},{long_click=K.liquid_keyboard_clipboard}),
 key_comma=merge({click=","},{swipe_left="!",swipe_right="!",long_click="!",swipe_up="!",swipe_down="!",label_symbol="!"}),
 key_space=merge({click=K.space},{long_click=K.Mode_switch,swipe_up=K.Mode_switch,swipe_left=K.Left,swipe_right=K.Right}),
 key_period=merge({click="."},{swipe_left="?",swipe_right="?",long_click="?",swipe_up="?",swipe_down="?",label_symbol="?"}),
 key_return=merge({click=K.Return},{long_click=K.Menu,swipe_up=K.Theme_settings,swipe_left=K.Color_settings}),
 key_line={width=100},
}
M.preset_keyboards={}
defer(function()
 M.preset_keyboards=deepcopy(M.preset_keyboards)
 for name,keyboard in pairs(M.preset_keyboards) do
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
  merge(keys.key_1,{key_back_color=color_config.key_back_indicator_1}),
  merge(keys.key_2,{key_back_color=color_config.key_back_indicator_2}),
  merge(keys.key_3,{key_back_color=color_config.key_back_indicator_3}),
  merge(keys.key_4,{key_back_color=color_config.key_back_indicator_4}),
  merge(keys.key_5,{key_back_color=color_config.key_back_indicator_5}),
  merge(keys.key_home,{key_back_color=color_config.key_back_indicator_5}),
  merge(keys.key_up,{key_back_color=color_config.key_back_indicator_4}),
  merge(keys.key_end,{key_back_color=color_config.key_back_indicator_3}),
  merge(keys.key_page_up,{key_back_color=color_config.key_back_indicator_2}),
  merge(keys.key_backspace_1,{key_back_color=color_config.key_back_indicator_1}),
  {width=0},
  merge(keys.key_6,{key_back_color=color_config.key_back_indicator_1}),
  merge(keys.key_7,{key_back_color=color_config.key_back_indicator_2}),
  merge(keys.key_8,{key_back_color=color_config.key_back_indicator_3}),
  merge(keys.key_9,{key_back_color=color_config.key_back_indicator_4}),
  merge(keys.key_0,{key_back_color=color_config.key_back_indicator_5}),
  merge(keys.key_left,{key_back_color=color_config.key_back_indicator_5}),
  merge(keys.key_down,{key_back_color=color_config.key_back_indicator_4}),
  merge(keys.key_right,{key_back_color=color_config.key_back_indicator_3}),
  merge(keys.key_page_down,{key_back_color=color_config.key_back_indicator_2}),
  merge(keys.key_delete,{key_back_color=color_config.key_back_indicator_1}),
  {width=0},
  merge(keys.key_q,{key_back_color=color_config.key_back_indicator_1}),
  merge(keys.key_w,{key_back_color=color_config.key_back_indicator_2}),
  merge(keys.key_e,{key_back_color=color_config.key_back_indicator_3}),
  merge(keys.key_r,{key_back_color=color_config.key_back_indicator_4}),
  merge(keys.key_t,{key_back_color=color_config.key_back_indicator_5}),
  merge(keys.key_y,{key_back_color=color_config.key_back_indicator_5}),
  merge(keys.key_u,{key_back_color=color_config.key_back_indicator_4}),
  merge(keys.key_i,{key_back_color=color_config.key_back_indicator_3}),
  merge(keys.key_o,{key_back_color=color_config.key_back_indicator_2}),
  merge(keys.key_p,{key_back_color=color_config.key_back_indicator_1}),
  {width=0},
  {width=5},
  merge(keys.key_a,{key_back_color=color_config.key_back_indicator_1}),
  merge(keys.key_s,{key_back_color=color_config.key_back_indicator_2}),
  merge(keys.key_d,{key_back_color=color_config.key_back_indicator_3}),
  merge(keys.key_f,{key_back_color=color_config.key_back_indicator_4}),
  merge(keys.key_g,{key_back_color=color_config.key_back_indicator_5}),
  merge(keys.key_h,{key_back_color=color_config.key_back_indicator_4}),
  merge(keys.key_j,{key_back_color=color_config.key_back_indicator_3}),
  merge(keys.key_k,{key_back_color=color_config.key_back_indicator_2}),
  merge(keys.key_l,{key_back_color=color_config.key_back_indicator_1}),
  {width=5},
  {width=0},
  merge(keys.key_shift,{width=15,key_back_color=color_config.key_back_indicator_1}),
  merge(keys.key_z,{key_back_color=color_config.key_back_indicator_2}),
  merge(keys.key_x,{key_back_color=color_config.key_back_indicator_3}),
  merge(keys.key_c,{key_back_color=color_config.key_back_indicator_4}),
  merge(keys.key_v,{key_back_color=color_config.key_back_indicator_5}),
  merge(keys.key_b,{key_back_color=color_config.key_back_indicator_4}),
  merge(keys.key_n,{key_back_color=color_config.key_back_indicator_3}),
  merge(keys.key_m,{key_back_color=color_config.key_back_indicator_2}),
  merge(keys.key_backspace_2,{width=15,key_back_color=color_config.key_back_indicator_1}),
  {width=0},
  merge(keys.key_keyboard_number,{width=20,key_back_color=color_config.key_back_indicator_1}),
  merge(keys.key_comma,{width=15,key_back_color=color_config.key_back_indicator_3}),
  merge(keys.key_space,{width=30,key_back_color=color_config.key_back_indicator_5}),
  merge(keys.key_period,{width=15,key_back_color=color_config.key_back_indicator_3}),
  merge(keys.key_return,{width=20,key_back_color=color_config.key_back_indicator_1}),
  {width=0},
  merge(keys.status_mode,{key_back_color=color_config.key_back_indicator_1}),
  merge(keys.status_shape,{key_back_color=color_config.key_back_indicator_2}),
  merge(keys.status_simp,{key_back_color=color_config.key_back_indicator_3}),
  merge(keys.status_punct,{key_back_color=color_config.key_back_indicator_4}),
  merge(keys.status_deploy,{key_back_color=color_config.key_back_indicator_5}),
  merge(keys.status_menu,{key_back_color=color_config.key_back_indicator_5}),
  merge(keys.status_settings,{key_back_color=color_config.key_back_indicator_4}),
  merge(keys.status_color,{key_back_color=color_config.key_back_indicator_3}),
  merge(keys.status_theme,{key_back_color=color_config.key_back_indicator_2}),
  merge(keys.status_schema,{key_back_color=color_config.key_back_indicator_1}),
}
}
M.preset_keyboards.letter={
 name="字母",
 ascii_mode=1,
 reset_ascii_mode=true,
 lock=false,
 width=10,
 offsets=offset_config.keyboard,
 height_ratio=ratio_config.default,
 keys=M.preset_keyboards.default.keys,
}
M.preset_keyboards.number={
 name="数字",
 width=10,
 offsets=offset_config.keyboard,
 height_ratio=ratio_config.default,
 keys={
  keys.key_1,
  keys.key_2,
  keys.key_3,
  keys.key_4,
  keys.key_5,
  keys.key_home,
  keys.key_up,
  keys.key_end,
  keys.key_page_up,
  keys.key_backspace_1,
  keys.key_6,
  keys.key_7,
  keys.key_8,
  keys.key_9,
  keys.key_0,
  keys.key_left,
  keys.key_down,
  keys.key_right,
  keys.key_page_down,
  keys.key_delete,
  merge({click="%"}),merge({click="^"}),merge({click=1},{width=20}),merge({click=2},{width=20}),merge({click=3},{width=20}),merge({click="+"}),merge({click="-"}),
  merge({click="!"}),merge({click="|"}),merge({click=4},{width=20}),merge({click=5},{width=20}),merge({click=6},{width=20}),merge({click="*"}),merge({click="/"}),
  merge({click="("}),merge({click=")"}),merge({click=7},{width=20}),merge({click=8},{width=20}),merge({click=9},{width=10}),merge({click=0},{width=10}),merge({click="="}),merge(keys.key_backspace_2,{width=10}),
  merge(keys.key_keyboard_back,{width=20}),
  merge(keys.key_comma,{width=15}),
  merge(keys.key_space,{width=30}),
  merge(keys.key_period,{width=15}),
  merge(keys.key_return,{width=20}),
  keys.status_mode,
  keys.status_shape,
  keys.status_simp,
  keys.status_punct,
  keys.status_deploy,
  keys.status_menu,
  keys.status_settings,
  keys.status_color,
  keys.status_theme,
  keys.status_schema,
  -- keys.key_line,
 },
}
run()
return M
