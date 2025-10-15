---@type rime_schema
return std.extend(
 {
  engine={
   filters={
    {
     name="simplifier@filter_simplification",
     option={
      option_name="filter_simplification",
      tags={"abc"},
     },
    },
    {
     name="simplifier@filter_emoji",
     option={
      opencc_config="emoji.json",
      option_name="filter_emoji",
      tags={"abc"},
      tips="all",
     },
    },
    {
     name="simplifier@filter_users",
     options={
      opencc_config="users.json",
      option_name="filter_emoji",
      tags={"abc"},
      tips="all",
     },
    },
    {
     name="simplifier@filter_symbol",
     option={
      opencc_config="sym.json",
      option_name="filter_symbol",
      tags={"abc"},
      tips="all",
     },
    },
    {
     name="simplifier@filter_zhuyin",
     option={
      comment_format={"xform/&nbsp/｜/"},
      opencc_config="pinyin.json",
      option_name="filter_zhuyin",
      show_in_comment=true,
      tags={"abc"},
      tips="all",
     },
    },
    {
     name="simplifier@filter_trans",
     option={
      opencc_config="dic_4w_en.json",
      option_name="filter_trans",
      tags={"english"},
      tips="all",
     },
    },
    "lua_filter@*cand-continuous-len*filter",
    "lua_filter@*cand-limit*filter@100",
    "lua_filter@*uniquifier*filter",
    "lua_filter@*cand-details*filter",
   },
   processors={
    "ascii_composer",
    "recognizer",
    "key_binder",
    "lua_processor@*keymap*processor",
    "lua_processor@*quick_warp*processor",
    "speller",
    "punctuator",
    "selector",
    "navigator",
    "express_editor",
    "lua_processor@*commit-recorder*processor@recorder",
   },
   segmentors={
    "ascii_segmentor",
    "matcher",
    "abc_segmentor",
    "punct_segmentor",
    "fallback_segmentor",
   },
   translators={
    "punct_translator",
    "lua_translator@*custom_word*translator@custom_word",
    "lua_translator@*custom_time*translator@custom_time",
   },
  },
  custom_word={
   delimiter="|",
   initial_quality=2,
   suffix="-=",
   user_dict="custom_word",
  },
  key_binder={
   bindings={
    {accept="Control+j",          send="Down",             when="composing"},
    {accept="Control+k",          send="Up",               when="composing"},
    {accept="Shift+Control+J",    send="Page_Down",        when="composing"},
    {accept="Shift+Control+K",    send="Page_Up",          when="composing"},
    {accept="Control+h",          send="Left",             when="composing"},
    {accept="Control+l",          send="Right",            when="composing"},
    {accept="Shift+Control+H",    send="Control+Left",     when="composing"},
    {accept="Shift+Control+L",    send="Control+Right",    when="composing"},
    {accept="Control+w",          send="BackSpace",        when="composing"},
    {accept="Control+e",          send="Delete",           when="composing"},
    {accept="Shift+Control+W",    send="Control+BackSpace",when="composing"},
    {accept="Shift+Control+E",    send="Control+Delete",   when="composing"},
    {accept="Control+y",          send="space",            when="has_menu"},
    {accept="Control+m",          send="Return",           when="composing"},
    {accept="Control+bracketleft",send="Escape",           when="composing"},
    {accept="Control+c",          send="Escape",           when="composing"},
   },
  },
  punctuator={
   import_preset="default",
  },
  recognizer={
   import_preset="default",
  },
  speller={
   delimiter=" '",
  },
  ascii_composer={
   good_old_caps_lock=true,
   switch_key={
    Shift_L="inline_ascii",
    Eisu_toggle="clear",
    Caps_Lock="clear",
   },
  },
 },
 --- Custom Phrase
 {
  custom_phrase={
   dictionary="custom_phrase",
   enable_completion=false,
   enable_sentence=false,
   enable_user_dict=false,
   initial_quality=64,
  },
  engine={
   translators={
    "table_translator@custom_phrase",
   },
  },
  schema={
   dependencies={
    "custom_phrase",
   },
  },
 },
 --- Custom symbol
 {
  schema={
   dependencies={
    "custom_symbol",
   },
  },
  engine={
   segmentors=function(self)
    std.tbl.insert_at(self,"affix_segmentor@custom_symbol","matcher",1)
   end,
   translators={
    "table_translator@custom_symbol",
   },
  },
  custom_symbol={
   initial_quality=64,
   prefix="\\",
   tips="[Symbol]",
   dictionary="custom_symbol",
   tag="custom_symbol",
  },
  recognizer={
   patterns={
    custom_symbol=[[^\\(?:10?|[0-9]|[A-Za-z]+)?]],
   },
  },
 },
 --- Lua filters
 {
  engine={
   filters={
    "lua_filter@*cand-reverse*filter@filter_Reverse",
    "lua_filter@*cand-unicode*filter@filter_Unicode",
   },
  },
  filter_Reverse={
   option_name="filter_Reverse",
  },
  filter_Unicode={
   option_name="filter_Unicode",
  },
 },
 {
  engine={
   filters={
    "lua_filter@*shape-filter*filter",
   },
   processors=function(self)
    std.tbl.insert_at(self,"lua_processor@*shape-filter*processor","key_binder",1)
   end,
  },
 },
 {
  execute={initial_quality=64,prefix="//",tag="execute"},
  recognizer={patterns={execute="^//.*"}},
  engine={translators={"lua_translator@*execute*translator@execute"}},
  key_binder={
   bindings={
    {accept="KP_1",       send="1",       when="composing"},
    {accept="KP_2",       send="2",       when="composing"},
    {accept="KP_3",       send="3",       when="composing"},
    {accept="KP_4",       send="4",       when="composing"},
    {accept="KP_5",       send="5",       when="composing"},
    {accept="KP_6",       send="6",       when="composing"},
    {accept="KP_7",       send="7",       when="composing"},
    {accept="KP_8",       send="8",       when="composing"},
    {accept="KP_9",       send="9",       when="composing"},
    {accept="KP_0",       send="0",       when="composing"},
    {accept="KP_Multiply",send="asterisk",when="composing"},
    {accept="KP_Add",     send="plus",    when="composing"},
    {accept="KP_Subtract",send="minus",   when="composing"},
    {accept="KP_Divide",  send="slash",   when="composing"},
    {accept="KP_Decimal", send="period",  when="composing"},
   },
  },
 },
 {
  chinese_number={initial_quality=64,prefix="/J",tag="chinese_number"},
  recognizer={patterns={chinese_number="^/J.*"}},
  engine={translators={"lua_translator@*chinese_number*translator@chinese_number"}},
 },
 {
  unicode={initial_quality=64,prefix="U",tag="unicode"},
  recognizer={patterns={unicode="^U(?:[HDOB]?[a-f0-9]*|[a-f0-9]*[HDOB]?)$"}},
  engine={translators={"lua_translator@*unicode*translator@unicode"}},
 }
)
