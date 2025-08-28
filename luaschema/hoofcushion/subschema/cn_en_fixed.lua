local utils=require("utils")
return {
 schema={
  schema_id="module_cn_en_fixed",
 },
 translator={
  dictionary="module_cn_en",
  prism="module_cn_en_fixed",
 },
 speller={
  algebra=utils.extend(
   require("hoofcushion.schema.han_quanpin_fixed").speller.algebra,
   {"xform/`//"}
  ),
 },
}
