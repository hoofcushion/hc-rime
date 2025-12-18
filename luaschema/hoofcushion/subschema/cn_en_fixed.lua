return {
 schema={
  schema_id=NS.module_cn_en_fixed,
 },
 translator={
  dictionary=NS.module_cn_en,
  prism=NS.module_cn_en_fixed,
 },
 speller={
  algebra=std.extend(
   require("hoofcushion.schema.han_quanpin_fixed").speller.algebra,
   {"xform/`//"}
  ),
 },
}
