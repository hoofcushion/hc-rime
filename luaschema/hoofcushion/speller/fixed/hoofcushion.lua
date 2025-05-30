local M={
 speller={
  initials="zyxwvutsrqponmlkjihgfedcbaZYXWVUTSRQPONMLKJIHGFEDCBA",
  alphabet="zyxwvutsrqponmlkjihgfedcbaZYXWVUTSRQPONMLKJIHGFEDCBA-=|",
  jian={"xform/^zh/v/","xform/^ch/u/","xform/^sh/i/"},
  algebra={
   "xform/^a$/\"ab\"/",
   "xform/^ai$/\"ai\"/",
   "xform/^an$/\"an\"/",
   "xform/^ang$/\"ag\"/",
   "xform/^ao$/\"ao\"/",
   "xform/^e$/\"wy\"/",
   "xform/^ei$/\"ey\"/",
   "xform/^en$/\"en\"/",
   "xform/^er$/\"eg\"/",
   "xform/^o$/\"oh\"/",
   "xform/^ou$/\"wb\"/",
   "xform/^ba$/\"ba\"/",
   "xform/^bai$/\"vl\"/",
   "xform/^ban$/\"bx\"/",
   "xform/^bang$/\"bz\"/",
   "xform/^bao$/\"bv\"/",
   "xform/^bei$/\"bs\"/",
   "xform/^ben$/\"bd\"/",
   "xform/^beng$/\"bd\"/",
   "xform/^bi$/\"br\"/",
   "xform/^bian$/\"bw\"/",
   "xform/^biang$/\"bj\"/",
   "xform/^biao$/\"bc\"/",
   "xform/^bie$/\"be\"/",
   "xform/^bin$/\"bf\"/",
   "xform/^bing$/\"bf\"/",
   "xform/^bo$/\"bt\"/",
   "xform/^bu$/\"bg\"/",
   "xform/^ca$/\"ca\"/",
   "xform/^cai$/\"ch\"/",
   "xform/^can$/\"cn\"/",
   "xform/^cang$/\"cg\"/",
   "xform/^cao$/\"cj\"/",
   "xform/^ce$/\"cy\"/",
   "xform/^cen$/\"ck\"/",
   "xform/^ceng$/\"ck\"/",
   "xform/^cha$/\"ua\"/",
   "xform/^chai$/\"ux\"/",
   "xform/^chan$/\"uw\"/",
   "xform/^chang$/\"uz\"/",
   "xform/^chao$/\"ay\"/",
   "xform/^che$/\"ue\"/",
   "xform/^chen$/\"au\"/",
   "xform/^cheng$/\"au\"/",
   "xform/^chi$/\"yg\"/",
   "xform/^chong$/\"us\"/",
   "xform/^chou$/\"uq\"/",
   "xform/^chu$/\"ug\"/",
   "xform/^chuai$/\"ut\"/",
   "xform/^chuan$/\"ur\"/",
   "xform/^chuang$/\"ud\"/",
   "xform/^chui$/\"uv\"/",
   "xform/^chun$/\"uc\"/",
   "xform/^chuo$/\"uf\"/",
   "xform/^ci$/\"ci\"/",
   "xform/^cong$/\"cl\"/",
   "xform/^cou$/\"cb\"/",
   "xform/^cu$/\"cu\"/",
   "xform/^cuan$/\"cm\"/",
   "xform/^cui$/\"cv\"/",
   "xform/^cun$/\"cp\"/",
   "xform/^cuo$/\"co\"/",
   "xform/^da$/\"ap\"/",
   "xform/^dai$/\"dh\"/",
   "xform/^dan$/\"dn\"/",
   "xform/^dang$/\"dg\"/",
   "xform/^dao$/\"dj\"/",
   "xform/^de$/\"dy\"/",
   "xform/^dei$/\"ds\"/",
   "xform/^den$/\"dk\"/",
   "xform/^deng$/\"dk\"/",
   "xform/^di$/\"di\"/",
   "xform/^dia$/\"dt\"/",
   "xform/^dian$/\"dm\"/",
   "xform/^diao$/\"tx\"/",
   "xform/^die$/\"de\"/",
   "xform/^ding$/\"vf\"/",
   "xform/^diu$/\"dq\"/",
   "xform/^dong$/\"dl\"/",
   "xform/^dou$/\"db\"/",
   "xform/^du$/\"du\"/",
   "xform/^duan$/\"dw\"/",
   "xform/^dui$/\"dv\"/",
   "xform/^dun$/\"dp\"/",
   "xform/^duo$/\"do\"/",
   "xform/^fa$/\"fp\"/",
   "xform/^fan$/\"fn\"/",
   "xform/^fang$/\"fg\"/",
   "xform/^fei$/\"fi\"/",
   "xform/^fen$/\"fk\"/",
   "xform/^feng$/\"fk\"/",
   "xform/^fo$/\"fo\"/",
   "xform/^fou$/\"fb\"/",
   "xform/^fu$/\"fu\"/",
   "xform/^ga$/\"ga\"/",
   "xform/^gai$/\"gx\"/",
   "derive/^gan$/\"gn\"/",
   "xform/^gan$/\"gw\"/",
   "xform/^gang$/\"gz\"/",
   "xform/^gao$/\"gj\"/",
   "xform/^ge$/\"ge\"/",
   "xform/^gei$/\"gi\"/",
   "derive/^gen$/\"gk\"/",
   "xform/^gen$/\"gf\"/",
   "derive/^geng$/\"gk\"/",
   "xform/^geng$/\"gf\"/",
   "derive/^gong$/\"gl\"/",
   "xform/^gong$/\"gs\"/",
   "derive/^gou$/\"gq\"/",
   "xform/^gou$/\"gb\"/",
   "xform/^gu$/\"gh\"/",
   "xform/^gua$/\"gy\"/",
   "xform/^guai$/\"gu\"/",
   "derive/^guan$/\"gr\"/",
   "xform/^guan$/\"gm\"/",
   "xform/^guang$/\"gd\"/",
   "xform/^gui$/\"gv\"/",
   "derive/^gun$/\"gp\"/",
   "xform/^gun$/\"gc\"/",
   "derive/^guo$/\"gt\"/",
   "xform/^guo$/\"go\"/",
   "xform/^ha$/\"ha\"/",
   "xform/^hai$/\"hx\"/",
   "xform/^han$/\"hw\"/",
   "xform/^hang$/\"hz\"/",
   "xform/^hao$/\"ah\"/",
   "xform/^he$/\"he\"/",
   "xform/^hei$/\"hi\"/",
   "xform/^hen$/\"hf\"/",
   "xform/^heng$/\"hf\"/",
   "xform/^hong$/\"hs\"/",
   "xform/^hou$/\"hq\"/",
   "xform/^hu$/\"hg\"/",
   "xform/^hua$/\"ho\"/",
   "xform/^huai$/\"hb\"/",
   "xform/^huan$/\"hr\"/",
   "xform/^huang$/\"hd\"/",
   "xform/^hui$/\"hv\"/",
   "xform/^hun$/\"hc\"/",
   "xform/^huo$/\"ht\"/",
   "xform/^ji$/\"jd\"/",
   "xform/^jia$/\"ja\"/",
   "xform/^jian$/\"jw\"/",
   "xform/^jiang$/\"jx\"/",
   "xform/^jiao$/\"jc\"/",
   "xform/^jie$/\"je\"/",
   "xform/^jin$/\"jf\"/",
   "xform/^jing$/\"jf\"/",
   "xform/^jiong$/\"js\"/",
   "xform/^jiu$/\"jq\"/",
   "xform/^ju$/\"jv\"/",
   "xform/^juan$/\"jr\"/",
   "xform/^jue$/\"jt\"/",
   "xform/^jun$/\"jz\"/",
   "xform/^ka$/\"ka\"/",
   "xform/^kai$/\"kx\"/",
   "xform/^kan$/\"kw\"/",
   "xform/^kang$/\"kz\"/",
   "xform/^kao$/\"kb\"/",
   "xform/^ke$/\"ke\"/",
   "xform/^ken$/\"kf\"/",
   "xform/^keng$/\"kf\"/",
   "xform/^kong$/\"ks\"/",
   "xform/^kou$/\"kq\"/",
   "xform/^ku$/\"kg\"/",
   "xform/^kua$/\"ky\"/",
   "xform/^kuai$/\"ev\"/",
   "xform/^kuan$/\"kr\"/",
   "xform/^kuang$/\"kd\"/",
   "xform/^kui$/\"kv\"/",
   "xform/^kun$/\"kc\"/",
   "xform/^kuo$/\"kt\"/",
   "xform/^la$/\"la\"/",
   "xform/^lai$/\"fh\"/",
   "xform/^lan$/\"fm\"/",
   "xform/^lang$/\"lz\"/",
   "xform/^lao$/\"fj\"/",
   "xform/^le$/\"le\"/",
   "xform/^lei$/\"al\"/",
   "xform/^leng$/\"ld\"/",
   "xform/^li$/\"fl\"/",
   "xform/^lia$/\"lj\"/",
   "xform/^lian$/\"lw\"/",
   "xform/^liang$/\"lx\"/",
   "xform/^liao$/\"lc\"/",
   "xform/^lie$/\"fy\"/",
   "xform/^lin$/\"lf\"/",
   "xform/^ling$/\"lf\"/",
   "xform/^liu$/\"lq\"/",
   "xform/^lo$/\"lt\"/",
   "xform/^long$/\"ls\"/",
   "xform/^lou$/\"lb\"/",
   "xform/^lu$/\"lg\"/",
   "xform/^luan$/\"lr\"/",
   "xform/^lun$/\"wl\"/",
   "xform/^luo$/\"lt\"/",
   "xform/^lv$/\"lv\"/",
   "xform/^lve$/\"fv\"/",
   "xform/^ma$/\"ma\"/",
   "xform/^mai$/\"mx\"/",
   "xform/^man$/\"wm\"/",
   "xform/^mang$/\"mz\"/",
   "xform/^mao$/\"mv\"/",
   "xform/^me$/\"me\"/",
   "xform/^mei$/\"ms\"/",
   "xform/^men$/\"md\"/",
   "xform/^meng$/\"md\"/",
   "xform/^mi$/\"mr\"/",
   "xform/^mian$/\"mw\"/",
   "xform/^miao$/\"mc\"/",
   "xform/^mie$/\"mt\"/",
   "xform/^min$/\"mf\"/",
   "xform/^ming$/\"mf\"/",
   "xform/^miu$/\"mq\"/",
   "xform/^mo$/\"wp\"/",
   "xform/^mou$/\"mq\"/",
   "xform/^mu$/\"mg\"/",
   "xform/^na$/\"na\"/",
   "xform/^nai$/\"nx\"/",
   "xform/^nan$/\"am\"/",
   "xform/^nang$/\"nz\"/",
   "xform/^nao$/\"nb\"/",
   "xform/^ne$/\"nr\"/",
   "xform/^nei$/\"yx\"/",
   "xform/^nen$/\"nd\"/",
   "xform/^neng$/\"nd\"/",
   "xform/^ni$/\"ne\"/",
   "xform/^nian$/\"nw\"/",
   "xform/^niang$/\"ni\"/",
   "xform/^niao$/\"nc\"/",
   "xform/^nie$/\"ny\"/",
   "xform/^nin$/\"nf\"/",
   "xform/^ning$/\"nf\"/",
   "xform/^niu$/\"nq\"/",
   "xform/^nong$/\"ns\"/",
   "xform/^nou$/\"nj\"/",
   "xform/^nu$/\"ng\"/",
   "xform/^nuan$/\"nk\"/",
   "xform/^nuo$/\"nt\"/",
   "xform/^nv$/\"nv\"/",
   "xform/^nve$/\"no\"/",
   "xform/^pa$/\"pa\"/",
   "xform/^pai$/\"bq\"/",
   "xform/^pan$/\"px\"/",
   "xform/^pang$/\"pz\"/",
   "xform/^pao$/\"pv\"/",
   "xform/^pei$/\"ps\"/",
   "xform/^pen$/\"pd\"/",
   "xform/^peng$/\"pd\"/",
   "xform/^pi$/\"pr\"/",
   "xform/^pian$/\"pw\"/",
   "xform/^piao$/\"pc\"/",
   "xform/^pie$/\"pe\"/",
   "xform/^pin$/\"pf\"/",
   "xform/^ping$/\"pf\"/",
   "xform/^po$/\"pt\"/",
   "xform/^pou$/\"pq\"/",
   "xform/^pu$/\"pg\"/",
   "xform/^qi$/\"qi\"/",
   "xform/^qia$/\"qg\"/",
   "xform/^qian$/\"qn\"/",
   "xform/^qiang$/\"qh\"/",
   "xform/^qiao$/\"qj\"/",
   "xform/^qie$/\"qy\"/",
   "xform/^qin$/\"qk\"/",
   "xform/^qing$/\"qk\"/",
   "xform/^qiong$/\"ql\"/",
   "xform/^qiu$/\"qo\"/",
   "xform/^qu$/\"qu\"/",
   "xform/^quan$/\"qm\"/",
   "xform/^que$/\"qt\"/",
   "xform/^qun$/\"qp\"/",
   "xform/^ran$/\"rn\"/",
   "derive/^rang$/\"rh\"/",
   "xform/^rang$/\"rg\"/",
   "xform/^rao$/\"rj\"/",
   "xform/^re$/\"ry\"/",
   "xform/^ren$/\"rk\"/",
   "xform/^reng$/\"rk\"/",
   "xform/^ri$/\"ri\"/",
   "xform/^rong$/\"rl\"/",
   "xform/^rou$/\"rb\"/",
   "xform/^ru$/\"ru\"/",
   "xform/^ruan$/\"rm\"/",
   "xform/^rui$/\"rv\"/",
   "xform/^run$/\"rp\"/",
   "xform/^ruo$/\"ro\"/",
   "derive/^sa$/\"sa\"/",
   "xform/^sa$/\"st\"/",
   "xform/^sai$/\"sh\"/",
   "xform/^san$/\"sn\"/",
   "xform/^sang$/\"sg\"/",
   "xform/^sao$/\"sj\"/",
   "xform/^se$/\"sy\"/",
   "xform/^sen$/\"sk\"/",
   "xform/^seng$/\"sk\"/",
   "xform/^sha$/\"ia\"/",
   "xform/^shai$/\"ix\"/",
   "xform/^shan$/\"iw\"/",
   "xform/^shang$/\"iz\"/",
   "xform/^shao$/\"aj\"/",
   "xform/^she$/\"ie\"/",
   "xform/^shei$/\"vm\"/",
   "xform/^shen$/\"ak\"/",
   "xform/^sheng$/\"ak\"/",
   "xform/^shi$/\"is\"/",
   "xform/^shou$/\"iq\"/",
   "xform/^shu$/\"ig\"/",
   "xform/^shua$/\"it\"/",
   "xform/^shuai$/\"iy\"/",
   "xform/^shuan$/\"ir\"/",
   "xform/^shuang$/\"id\"/",
   "xform/^shui$/\"iv\"/",
   "xform/^shun$/\"ic\"/",
   "xform/^shuo$/\"if\"/",
   "xform/^si$/\"si\"/",
   "xform/^song$/\"sl\"/",
   "xform/^sou$/\"sb\"/",
   "xform/^su$/\"su\"/",
   "xform/^suan$/\"sm\"/",
   "xform/^sui$/\"sv\"/",
   "xform/^sun$/\"sp\"/",
   "xform/^suo$/\"so\"/",
   "xform/^ta$/\"ta\"/",
   "xform/^tai$/\"th\"/",
   "xform/^tan$/\"tn\"/",
   "derive/^tang$/\"tz\"/",
   "xform/^tang$/\"tg\"/",
   "xform/^tao$/\"tj\"/",
   "xform/^te$/\"te\"/",
   "derive/^teng$/\"tk\"/",
   "xform/^teng$/\"td\"/",
   "xform/^ti$/\"ti\"/",
   "derive/^tian$/\"tm\"/",
   "xform/^tian$/\"tw\"/",
   "xform/^tiao$/\"tc\"/",
   "xform/^tie$/\"ty\"/",
   "xform/^ting$/\"tf\"/",
   "derive/^tong$/\"tl\"/",
   "xform/^tong$/\"ts\"/",
   "derive/^tou$/\"tq\"/",
   "xform/^tou$/\"tb\"/",
   "xform/^tu$/\"tu\"/",
   "xform/^tuan$/\"tr\"/",
   "xform/^tui$/\"tv\"/",
   "xform/^tun$/\"tp\"/",
   "xform/^tuo$/\"to\"/",
   "xform/^wa$/\"wj\"/",
   "xform/^wai$/\"wh\"/",
   "xform/^wan$/\"wn\"/",
   "xform/^wang$/\"wg\"/",
   "xform/^wei$/\"wi\"/",
   "xform/^wen$/\"wk\"/",
   "xform/^weng$/\"wk\"/",
   "xform/^wo$/\"wo\"/",
   "xform/^wu$/\"wu\"/",
   "xform/^xi$/\"xi\"/",
   "xform/^xia$/\"xg\"/",
   "xform/^xian$/\"xn\"/",
   "xform/^xiang$/\"xh\"/",
   "xform/^xiao$/\"xj\"/",
   "xform/^xie$/\"xy\"/",
   "xform/^xin$/\"xk\"/",
   "xform/^xing$/\"xk\"/",
   "xform/^xiong$/\"xl\"/",
   "xform/^xiu$/\"xo\"/",
   "xform/^xu$/\"xu\"/",
   "xform/^xuan$/\"xm\"/",
   "xform/^xue$/\"xt\"/",
   "xform/^xun$/\"xp\"/",
   "xform/^ya$/\"ya\"/",
   "xform/^yan$/\"yw\"/",
   "derive/^yang$/\"eh\"/",
   "xform/^yang$/\"yz\"/",
   "derive/^yao$/\"ej\"/",
   "xform/^yao$/\"yd\"/",
   "xform/^ye$/\"ye\"/",
   "xform/^yi$/\"ei\"/",
   "derive/^yin$/\"ek\"/",
   "xform/^yin$/\"yf\"/",
   "derive/^ying$/\"ek\"/",
   "xform/^ying$/\"yf\"/",
   "xform/^yo$/\"eo\"/",
   "derive/^yong$/\"el\"/",
   "xform/^yong$/\"ys\"/",
   "derive/^you$/\"eb\"/",
   "xform/^you$/\"yq\"/",
   "derive/^yu$/\"eu\"/",
   "xform/^yu$/\"yv\"/",
   "derive/^yuan$/\"em\"/",
   "xform/^yuan$/\"yr\"/",
   "derive/^yue$/\"et\"/",
   "xform/^yue$/\"yt\"/",
   "derive/^yun$/\"ep\"/",
   "xform/^yun$/\"yc\"/",
   "xform/^za$/\"av\"/",
   "xform/^zai$/\"zh\"/",
   "xform/^zan$/\"zn\"/",
   "xform/^zang$/\"zg\"/",
   "xform/^zao$/\"zj\"/",
   "xform/^ze$/\"zy\"/",
   "xform/^zei$/\"zt\"/",
   "xform/^zen$/\"zk\"/",
   "xform/^zeng$/\"zk\"/",
   "xform/^zha$/\"oa\"/",
   "derive/^zhai$/\"vh\"/",
   "xform/^zhai$/\"ox\"/",
   "derive/^zhan$/\"vw\"/",
   "derive/^zhan$/\"vn\"/",
   "xform/^zhan$/\"ow\"/",
   "derive/^zhang$/\"vz\"/",
   "xform/^zhang$/\"oz\"/",
   "xform/^zhao$/\"vj\"/",
   "derive/^zhe$/\"ve\"/",
   "xform/^zhe$/\"oe\"/",
   "xform/^zhen$/\"vk\"/",
   "xform/^zheng$/\"vk\"/",
   "xform/^zhi$/\"vi\"/",
   "derive/^zhong$/\"vs\"/",
   "xform/^zhong$/\"os\"/",
   "derive/^zhou$/\"vq\"/",
   "derive/^zhou$/\"vb\"/",
   "xform/^zhou$/\"oq\"/",
   "derive/^zhu$/\"vu\"/",
   "xform/^zhu$/\"og\"/",
   "derive/^zhua$/\"va\"/",
   "xform/^zhua$/\"ot\"/",
   "derive/^zhuai$/\"vx\"/",
   "xform/^zhuai$/\"oy\"/",
   "derive/^zhuan$/\"vr\"/",
   "xform/^zhuan$/\"or\"/",
   "derive/^zhuang$/\"vd\"/",
   "xform/^zhuang$/\"od\"/",
   "xform/^zhui$/\"ov\"/",
   "derive/^zhun$/\"vp\"/",
   "xform/^zhun$/\"oc\"/",
   "derive/^zhuo$/\"vo\"/",
   "xform/^zhuo$/\"of\"/",
   "xform/^zi$/\"zi\"/",
   "xform/^zong$/\"zl\"/",
   "xform/^zou$/\"zb\"/",
   "xform/^zu$/\"zu\"/",
   "xform/^zuan$/\"zm\"/",
   "xform/^zui$/\"zv\"/",
   "xform/^zun$/\"zp\"/",
   "xform/^zuo$/\"zo\"/",
   "xform/^chua$/\"uu\"/",
   "xform/^eng$/\"en\"/",
   "xform/^fiao$/\"ff\"/",
   "xform/^kei$/\"kk\"/",
   "xform/^nia$/\"nn\"/",
   "xform/^nun$/\"np\"/",
   "xform/^tei$/\"tt\"/",
   "xform/^zhei$/\"vy\"/",
   "xform/\"//",
  },
 },
}
M.module_fnua_cn={
 comment_format=(function()
  local algebra=M.speller.algebra
  local map={
   ["^"]=[[\<]],
   ["$"]=[[\>]],
  }
  local new={}
  for _,formula in ipairs(algebra) do
   local type,from,to=formula:match("^(.-)/(.-)/(.-)/?$")
   from=from:gsub("[$^]",map)
   table.insert(new,type.."/"..from.."/"..to.."/")
  end
  return new
 end)(),
}
return M
