---@type rime_schema
return std.extend(
 {
  engine={
   filters={
    {
     name="simplifier@"..NS.filter_simplification,
     option={
      option_name=NS.simplification,
      tags={"abc"},
     },
    },
    {
     name="simplifier@"..NS.filter_emoji,
     option={
      opencc_config="emoji.json",
      option_name=NS.filter_emoji,
      tags={"abc"},
      tips="all",
     },
    },
    {
     name="simplifier@"..NS.filter_users,
     options={
      opencc_config="users.json",
      option_name=NS.filter_emoji,
      tags={"abc"},
      tips="all",
     },
    },
    {
     name="simplifier@"..NS.filter_symbol,
     option={
      opencc_config="sym.json",
      option_name=NS.filter_symbol,
      tags={"abc"},
      tips="all",
     },
    },
    {
     name="simplifier@"..NS.filter_zhuyin,
     option={
      comment_format={"xform/&nbsp/｜/"},
      opencc_config="pinyin.json",
      option_name=NS.filter_zhuyin,
      show_in_comment=true,
      tags={"abc"},
      tips="all",
     },
    },
    {
     name="simplifier@"..NS.filter_trans,
     option={
      opencc_config="dic_4w_en.json",
      option_name=NS.filter_trans,
      tags={"english"},
      tips="all",
     },
    },
    {
     name="lua_filter",
     module=require("cand-continuous-len").filter,
    },
    {
     name="lua_filter@100",
     module=require("cand-limit").filter,
    },
    {
     name="lua_filter",
     module=require("uniquifier").filter,
    },
    {
     name="lua_filter",
     module=require("cand-details").filter,
    },
   },
   processors={
    "ascii_composer",
    "recognizer",
    "key_binder",
    {
     name="lua_processor",
     module=require("keymap").processor,
    },
    {
     name="lua_processor",
     module=require("quick_warp").processor,
    },
    "speller",
    "punctuator",
    "selector",
    "navigator",
    "express_editor",
    {
     name="lua_processor@"..NS.recorder,
     module=require("commit-recorder").processor,
    },
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
    {
     name="lua_translator@"..NS.custom_word,
     module=require("custom_word").translator,
     option={
      delimiter="|",
      initial_quality=2,
      suffix="-=",
      user_dict=NS.custom_word,
     },
    },
    {
     name="lua_translator@"..NS.custom_time,
     module=require("custom_time").translator,
    },
   },
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
  engine={
   translators={
    {
     name="table_translator@"..NS.custom_phrase,
     option={
      dictionary=NS.custom_phrase,
      enable_completion=false,
      enable_sentence=false,
      enable_user_dict=false,
      initial_quality=64,
     },
    },
   },
  },
  schema={
   dependencies={
    NS.custom_phrase,
   },
  },
 },
 --- Custom symbol
 {
  schema={
   dependencies={
    NS.custom_symbol,
   },
  },
  engine={
   segmentors=function(self)
    std.tbl.insert_at(self,"affix_segmentor@"..NS.custom_symbol,"matcher",1)
   end,
   translators={
    {
     name="table_translator@"..NS.custom_symbol,
     option={
      initial_quality=64,
      prefix="\\",
      tips="[Symbol]",
      dictionary=NS.custom_symbol,
      tag=NS.custom_symbol,
     },
    },
   },
  },
  recognizer={
   patterns={
    [NS.custom_symbol]=[[^\\(?:10?|[0-9]|[A-Za-z]+)?]],
   },
  },
 },
 --- Lua filters
 {
  engine={
   filters={
    {
     name="lua_filter@"..NS.filter_Reverse,
     module=require("cand-reverse").filter,
     option={
      option_name=NS.filter_Reverse,
     },
    },
    {
     name="lua_filter@"..NS.filter_Unicode,
     module=require("cand-unicode").filter,
     option={
      option_name=NS.filter_Unicode,
     },
    },
   },
  },
 },
 {
  engine={
   filters={
    {
     name="lua_filter",
     module=require("shape-filter").filter,
    },
   },
   processors=function(self)
    std.tbl.insert_at(self,"lua_processor@*shape-filter*processor","key_binder",1)
   end,
  },
 },
 {
  engine={
   translators={
    {
     name="lua_translator@"..NS.execute,
     module=require("execute").translator,
     option={
      initial_quality=64,
      prefix="//",
      tag="execute",
     },
    },
   },
  },
  recognizer={
   patterns={execute="^//.*"},
  },
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
  engine={
   translators={
    {
     name="lua_translator@"..NS.chinese_number,
     module=require("chinese_number").translator,
     option={
      initial_quality=64,
      prefix="/J",
      tag=NS.chinese_number,
     },
    },
   },
  },
  recognizer={
   patterns={
    [NS.chinese_number]="^/J.*",
   },
  },
 },
 {
  engine={
   translators={
    {
     name="lua_translator@"..NS.unicode,
     module=require("unicode").translator,
     option={
      initial_quality=64,
      prefix="U",
      tag=NS.unicode,
     },
    },
   },
  },
  recognizer={
   patterns={
    [NS.unicode]="^U(?:[HDOB]?[a-f0-9]*|[a-f0-9]*[HDOB]?)$",
   },
  },
 }
)
