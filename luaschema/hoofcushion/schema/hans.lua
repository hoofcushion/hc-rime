-- 简体拼音输入方案共享配置
return {
 engine={
  -- processors=function(self)
  --  table.insert(
  --   self,
  --   1,
  --   "lua_processor@*user-dict-blocker*processor"
  --  )
  -- end,
  filters={
   "lua_filter@*cand-block-char-ud*filter",
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
