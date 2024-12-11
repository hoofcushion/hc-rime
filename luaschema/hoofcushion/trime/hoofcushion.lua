local yaml2table={
 style={
  keyboards={".default","default","default_decimal","default_simp","number_pad"},
  auto_caps=false,
  preview_offset=0,
  reset_ascii_mode=false,
  proximity_correction=true,
  candidate_use_cursor=true,
  speech_opencc_config="s2t.json",
  locale="zh_CN",
  latin_locale="en_US",
  vertical_correction=-10,
  background_dim_amount=0.5,
  key_long_text_border=1,
  background_folder="",
  color_scheme="HoofCushion_win10_purple",
  horizontal=false,
  comment_on_top=true,
  candidate_padding=9,
  candidate_spacing=0.5,
  horizontal_gap=1,
  vertical_gap=1,
  round_corner=0,
  shadow_radius=0,
  keyboard_padding=0,
  keyboard_padding_left=0,
  keyboard_padding_right=0,
  keyboard_padding_bottom=0,
  keyboard_padding_land=0,
  keyboard_padding_land_bottom=0,
  candidate_view_height=18,
  comment_height=16,
  keyboard_height=260,
  keyboard_height_land=220,
  text_height=22,
  key_height="*inputh",
  key_width="*width_per10_100",
  text_size=12,
  candidate_text_size=16,
  comment_text_size=15,
  label_text_size=12,
  key_text_size=22,
  key_long_text_size=16,
  preview_height=60,
  preview_text_size=40,
  symbol_text_size=10,
  candidate_font="han.ttf",
  comment_font="comment.ttf",
  hanb_font="hanb.ttf",
  key_font="symbol.ttf",
  label_font="label.ttf",
  latin_font="latin.ttf",
  preview_font="latin.ttf",
  symbol_font="symbol.ttf",
  text_font="latin.ttf",
  long_text_font="comment.ttf",
  layout={
   position="fixed",
   movable=false,
   min_width=150,
   min_height=75,
   max_width=512,
   max_height=512,
   min_length=0,
   max_length=0,
   margin_x=2,
   margin_y=4,
   margin_bottom=0,
   line_spacing=0,
   line_spacing_multiplier=1,
   min_check=0,
   max_entries=10,
   all_phrases=true,
   sticky_lines=10,
   sticky_lines_land=0,
   alpha=255,
   border=1,
   spacing=-34,
   elevation=0,
   real_margin=0,
   round_corner=0,
   window={
    {start="",  composition="%s",["end"]="",    send_spacing=0},
    {start="\n",label="%s",      candidate="%s",comment=" %s",["end"]="",sep=" "},
   },
  },
  enter_label_mode=3,
  enter_labels={
   go="前往",
   done="完成",
   next="下个",
   pre="上个",
   search="搜索",
   send="发送",
   default="Enter",
  },
 },
 preset_color_schemes={
  default={
   author="蹄垫HoofCushion <2465403648>",
   name="Win10鸢尾花／Win10 Purple",
   color_format="argb",
   back_color=0x000000,
   border_color=0x503575,
   comment_text_color=0x734ca8,
   label_color=0xb2b2b2,
   -- shadow_color=,
   text_color=0xb2b2b2,
   -- 候选区域
   -- candidate_back_color=,
   -- candidate_border_color=,
   -- candidate_shadow_color=,
   candidate_text_color=0xb2b2b2,
   -- 高亮区域
   hilited_back_color=0x1f1f1f,
   hilited_comment_text_color=0xa86ff5,
   hilited_label_color=0x00000000,
   -- hilited_mark_color=,
   -- hilited_shadow_color=,
   hilited_text_color=0xffffff,
   -- 高亮的候选区域
   hilited_candidate_back_color=0x503575,
   -- hilited_candidate_border_color=,
   -- hilited_candidate_shadow_color=,
   -- hilited_candidate_text_color=,
  },
 },
 liquid_keyboard={
  row=6,
  row_land=5,
  key_height=40,
  key_height_land=40,
  single_width=60,
  vertical_gap=1,
  margin_x=0,
  keyboards={"exit"," candidate"," history"," clipboard"," collection"," draft"},
  exit={
   name="返回",
   type="NO_KEY",
   keys="EXIT",
  },
  candidate={
   name="候选",
   type="CANDIDATE",
  },
  history={
   name="常用",
   type="HISTORY",
  },
  clipboard={
   type="CLIPBOARD",
   name="剪贴",
  },
  collection={
   type="COLLECTION",
   name="收藏",
  },
  draft={
   type="DRAFT",
   name="草稿",
  },
 },
}