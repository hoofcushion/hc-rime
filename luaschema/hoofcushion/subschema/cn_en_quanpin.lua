return {
 schema={
  schema_id=NS.module_cn_en_quanpin,
 },
 translator={
  dictionary=NS.module_cn_en,
  prism=NS.module_cn_en_quanpin,
 },
 speller={
  algebra=std.extend(
   require("hoofcushion.schema.han_quanpin").speller.algebra,
   {"xform/`//"}
  ),
 },
}
