return {
 schema={
  schema_id="module_cn_en_quanpin",
 },
 translator={
  dictionary="module_cn_en",
  prism="module_cn_en_quanpin",
 },
 speller={
  algebra=std.extend(
   require("hoofcushion.schema.han_quanpin").speller.algebra,
   {"xform/`//"}
  ),
 },
}
