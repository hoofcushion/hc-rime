-- 简体拼音输入方案共享配置
return {
 engine={
  processors=function(t)
   table.insert(t,1,"lua_processor@*user-dict-blocker*processor")
  end,
  filters={
   {
    name="lua_filter@*cand-decensor*filter",
    option={
     option_name="filter_decensor",
    },
   },
  },
 },
 grammar={
  language="rime-octagram-data/zh-hans-t-essay-bgw",
 },
 translator={
  contextual_suggestions=true,
  max_homophones=7,
  max_homographs=7,
 },
}
