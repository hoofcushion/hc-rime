local utils=require("utils")
local schema=utils.tbl_extend(
 require("hoofcushion.ts_detail"),
 require("hoofcushion.speller.double.chaos_20"),
 require("hoofcushion.schema_settings.ts_en"),
 function(schema)
  table.insert(schema.engine.translators,"lua_translator@*ts_en*translator@translator")
 end,
 {
  schema={
   schema_id="ts_en",
   name="英语",
   description=[[
英语输入方案
词库来自网络
]],
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
    {"derive/[^A-Za-z]//"},
    {"derive/.+/\\L$0/"},
   },
  },
 }
)
return schema
