local specs={
 require("hoofcushion.subschema.cn_en_fixed"),
 require("hoofcushion.subschema.cn_en_quanpin"),
 require("hoofcushion.subschema.custom_phrase"),
 require("hoofcushion.subschema.custom_symbol"),
 require("hoofcushion.subschema.reverse_quanpin"),
 require("hoofcushion.subschema.reverse_toned"),
 require("hoofcushion.schema.han_quanpin"),
 require("hoofcushion.schema.han_quanpin_fixed"),
 require("hoofcushion.schema.han_toned"),
 require("hoofcushion.schema.english"),
 require("hoofcushion.default"),
 nil,
}
local M={}
function M.setup()
 local LuaSchema=require("luaschema")
 for _,v in ipairs(specs) do
  LuaSchema.load(v)
 end
end
return M
