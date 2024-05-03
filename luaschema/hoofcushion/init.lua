local specs={
 require("hoofcushion.cn_en"),
 require("hoofcushion.cn_en_quanpin"),
 require("hoofcushion.custom_phrase"),
 require("hoofcushion.custom_symbol"),
 require("hoofcushion.fnua_cn"),
 require("hoofcushion.fnua_triple"),
 require("hoofcushion.ts_cn"),
 require("hoofcushion.ts_cn_quanpin"),
 require("hoofcushion.ts_triple"),
 require("hoofcushion.ts_en"),
}
local M={}
function M.setup()
 local LuaSchema=require("luaschema")
 for _,v in ipairs(specs) do
  LuaSchema.load(v)
 end
end
return M
