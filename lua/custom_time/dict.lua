--[[
示例表格:
{
 {
  codes  ={编码1,编码2},
  comment=分提示码,
  {
   text   =日期格式1
   comment=特殊提示码1
  },{
   text   =日期格式2
   comment=特殊提示码2
  },{
   text   =日期格式3
   comment=特殊提示码3
  },{
   text   =日期格式4
   comment=特殊提示码4
  },{
   text   =日期格式5
   comment=特殊提示码5
  },
 }
}
编码　　　:字符串　键盘打得出来
日期格式　:字符串　合法Lua代码
总提示码　:字符串　　　　　优先级低
分提示码　:字符串或false　优先级中
特殊提示码:字符串或false　优先级高
--]]
local week={
 {"日","一","二","三","四","五","六"},
 {"天","一","二","三","四","五","六"},
 {"日","月","火","水","木","金","土"},
 {"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"},
 {"Dies Solis","Dies Lunae","Dies Martis","Dies Mercurii","Dies Iovis","Dies Veneris","Dies Saturni"},
}
local function thisYearlength(str)
 local year=os.date("%Y")
 local map={d=1,m=1440,s=86400}
 return (year%4==0 and (year%100~=0 or year%400==0) and 366 or 365)*map[str]
end
local function thisYearpast()
 return os.time()-os.time{year=os.date("%Y"),month=1,day=1}
end
return {
 {
  codes  ={"date"},
  comment="日期",
  {text=function() return os.date("%Y-%m-%d") end,comment=false},
  {text=function() return os.date("%Y/%m/%d") end,comment=false},
  {text=function() return os.date("%Y.%m.%d") end,comment=false},
  {text=function() return os.date("%Y%m%d") end,comment=false},
  {text=function() return os.date("%Y年 %m月 %d日"):gsub(" 0?","") end,comment=false},
 },
 {
  codes  ={"time"},
  comment="时间",
  {text=function() return os.date("%H:%M") end,   comment=false},
  {text=function() return os.date("%H:%M:%S") end,comment=false},
 },
 {
  codes  ={"datetime"},
  comment="日期+时间",
  {text=function() return os.date("%Y-%m-%dT%H:%M:%S+08:00") end,comment=false},
  {text=function() return os.date("%Y%m%d%H%M%S") end,           comment=false},
 },
 {
  codes  ={"week"},
  comment="星期",
  {text=function() return "星期"..week[1][os.date("%w")+1] end,comment=false},
  {text=function() return "礼拜"..week[2][os.date("%w")+1] end,comment=false},
  {text=function() return "周"..week[1][os.date("%w")+1] end,comment=false},
  {text=function() return week[3][os.date("%w")+1].."曜日" end,comment=false},
  {text=function() return week[4][os.date("%w")+1] end,comment=false},
  {text=function() return week[5][os.date("%w")+1] end,comment=false},
 },
 {
  codes  ={"timestamp"},
  comment="时间戳",
  {text=function() return os.time() end,comment=false},
 },
 {
  codes  ={"D"},
  comment="普通格式日期",
  {text=function() return os.date("%Y年%m月%d日") end,comment=false},
  {text=function() return os.date("%Y年 %m月 %d日"):gsub(" 0?","") end,comment=false},
  {text=function() return os.date("%Y%m%d") end,comment=false},
 },
 {
  codes  ={"DD"},
  comment="纯ASCII日期",
  {text=function() return os.date("%Y/%m/%d") end,comment=false},
  {text=function() return os.date("%Y-%m-%d") end,comment=false},
  {text=function() return os.date("%Y.%m.%d") end,comment=false},
 },
 {
  codes  ={"S"},
  comment="普通格式日期+时间",
  {text=function() return os.date("%Y年%m月%d日%H时%M分%S秒") end,comment=false},
  {text=function() return os.date("%Y年 %m月 %d日 %H时 %M分 %S秒"):gsub(" 0?","") end,comment=false},
  {text=function() return os.date("%Y%m%d%H%M%S") end,comment=false},
 },
 {
  codes  ={"SS"},
  comment="纯ASCII日期+时间",
  {text=function() return os.date("%Y/%m/%d %H:%M:%S") end,comment=false},
  {text=function() return os.date("%Y-%m-%d %H:%M:%S") end,comment=false},
  {text=function() return os.date("%Y.%m.%d %H:%M:%S") end,comment=false},
 },
 {
  codes  ={"ISO"},
  comment=false,
  {text=function() return os.date("%Y-%m-%dT%H:%M:%S+08:00") end,comment="中国标准时间"},
  {text=function() return os.date("%Y-%m-%dT%H:%M:%S.000Z") end,comment="ISO 8601"},
 },
 {
  codes  ={"ver"},
  comment="快速设置版本号",
  {text=function() return os.date("%Y%m%d%H%M%S") end,comment=false},
  {text=function() return os.time() end,              comment=false},
  {text=function() return os.date("%Y%m%d") end,      comment=false},
  {text=function() return os.date("%H%M%S") end,      comment=false},
 },
 {
  codes  ={"L"},
  comment=false,
  {text=function() return os.date("%j") end,comment="今年的第几天"},
  {text=function() return thisYearlength("d")-os.date("%j") end,comment="今年还剩几天"},
  {text=function() return thisYearpast()/thisYearlength("s")*100 .. "%" end,comment="今年已过去多久"},
  {text=function() return math.abs(-1+thisYearpast()/thisYearlength("s"))*100 .. "%" end,comment="今年还剩多久"},
 },
}
