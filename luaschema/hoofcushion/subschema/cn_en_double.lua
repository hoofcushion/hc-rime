
return {
 schema={
  schema_id="module_cn_en_double",
 },
 translator={
  dictionary="module_cn_en_quanpin",
  prism="module_cn_en_double"
 },
 speller={
  algebra=rime.extend(
   require("hoofcushion.schema.han_quanpin").speller.algebra,
   {"xform/`//"}
  ),
 },
}
