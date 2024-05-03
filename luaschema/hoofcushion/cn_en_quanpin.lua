local utils=require("utils")
return {
 schema={
  schema_id="module_cn_en_quanpin",
 },
 translator={
  dictionary="module_cn_en_quanpin",
 },
 speller={
  algebra=utils.tbl_extend(
   require("hoofcushion.ts_cn_quanpin").speller.algebra,
   {"xform/\"//"}
  ),
 },
}
