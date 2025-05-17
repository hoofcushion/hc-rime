local layouts={
 qwerty={},
 rstlne={A="A",B="B",C="C",D="E",E="D",F="R",G="L",H="H",I="K",J="N",K="I",L="O",M="M",N="J",O="Y",P="P",Q="Q",R="F",S="S",T="Z",U="U",V="V",W="W",X="X",Y="T",Z="G",a="a",b="b",c="c",d="e",e="d",f="r",g="l",h="h",i="k",j="n",k="i",l="o",m="m",n="j",o="y",p="p",q="q",r="f",s="s",t="z",u="u",v="v",w="w",x="x",y="t",z="g"},
 devorak={["'"]="-",[","]="w",["-"]="[",["."]="v",["/"]="z",["0"]="0",["1"]="1",["2"]="2",["3"]="3",["4"]="4",["5"]="5",["6"]="6",["7"]="7",["8"]="8",["9"]="9",[";"]="s",["="]="]",["A"]="A",["B"]="X",["C"]="J",["D"]="E",["E"]=".",["F"]="U",["G"]="I",["H"]="D",["I"]="C",["J"]="H",["K"]="T",["L"]="N",["M"]="M",["N"]="B",["O"]="R",["P"]="L",["Q"]="'",["R"]="P",["S"]="O",["T"]="Y",["U"]="G",["V"]="K",["W"]=",",["X"]="Q",["Y"]="F",["Z"]=";",["["]="/",["\\"]="\\",["]"]="=",["`"]="`",["a"]="a",["b"]="x",["c"]="j",["d"]="e",["e"]=".",["f"]="u",["g"]="i",["h"]="d",["i"]="c",["j"]="h",["k"]="t",["l"]="n",["m"]="m",["n"]="b",["o"]="r",["p"]="l",["q"]="'",["r"]="p",["s"]="o",["t"]="y",["u"]="g",["v"]="k",["w"]=",",["x"]="q",["y"]="f",["z"]=";"},
}
local layout=layouts.rstlne
---@type engine
local M={}
M.processor={
 func=function(key,env)
  if env.engine.context:get_option("ascii_mode")==false
  or env.engine.context:is_composing()
  or key:ctrl()
  or key:alt()
  or key:caps()
  or key:super()
  or key:release()
  then
   return kNoop
  end
  local char=layout[string.char(key.keycode)]
  if char==nil then
   return kNoop
  end
  env.engine:commit_text(char)
  return kAccepted
 end,
}
return M
