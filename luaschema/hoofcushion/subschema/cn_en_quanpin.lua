
return {
 schema={
  schema_id="module_cn_en_quanpin",
 },
 translator={
  dictionary="module_cn_en_quanpin",
 },
 speller={
  algebra=rime.extend(
   require("hoofcushion.schema.han_quanpin").speller.algebra,
   {"xform/`//"}
  ),
 },
}
