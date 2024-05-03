local utils=require("utils")
local schema=utils.tbl_extend(
 require("hoofcushion.ts_detail"),
 require("hoofcushion.speller.quanpin"),
 require("hoofcushion.schema_settings.ts_cn_quanpin"),
 {
  schema={
   schema_id="ts_cn_quanpin",
   name="全拼",
   description=
   [[
汉语输入方案之全拼
词库基于雾凇拼音 (https://github.com/iDvel/rime-ice)
]],
   dependencies={
    "ts_en",
    "module_cn_en_quanpin",
   },
  },
  engine={
   translators={
    "lua_translator@*ts_cn_quanpin*translator@translator",
    "lua_translator@*ts_en*translator@module_en",
    "script_translator@module_cn_en",
   },
  },
  translator={
   initial_quality=1,
   dictionary="ts_cn",
   user_dict="ts_cn_quanpin",
  },
  module_cn_en={
   initial_quality=1,
   dictionary="module_cn_en_quanpin",
   user_dict="module_cn_en_quanpin",
  },
  module_en=utils.tbl_extend(
   require("hoofcushion.ts_en").translator,
   {tag="ts_en"}
  ),
 }
)
return schema
