local utils=require("utils")
local keymaps=require("hoofcushion.keymaps")
local switchers=require("hoofcushion.switchers")
local schema=utils.extend(
 require("hoofcushion.schema.base"),
 {
  schema={
   schema_id="ts_en",
   name="英语",
   description=[[
英语输入方案
词库来自网络
]],
  },
  engine={
   translators={
    "lua_translator@*ts_en*translator@translator",
   },
  },
  translator={
   initial_quality=1,
   dictionary="ts_en",
   enable_user_dict=true,
   user_dict="custom_word",
   db_class="stabledb",
   enable_sentence=false,
   comment_format={"xform/^.*$//"},
  },
  speller={
   alphabet="zyxwvutsrqponmlkjihgfedcba;ZYXWVUTSRQPONMLKJIHGFEDCBA-=|",
   algebra={
    "derive/[^A-Za-z]//",
    "derive/.+/\\L$0/",
   },
  },
 },
 {
  key_binder={
   bindings={
    keymaps.ascii_punct,
    keymaps.full_shape,
   },
  },
  switches={
   switchers.ascii_mode,
   switchers.ascii_punct,
   switchers.full_shape,
   switchers.filter_trans,
   switchers.filter_Unicode,
   switchers.filter_Reverse,
  },
 }
)
return schema
