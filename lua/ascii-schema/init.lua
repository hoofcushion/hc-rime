local function layout_map(tbl)
 return setmetatable(tbl,{__index=function(t,k) return rawget(t,k) or k end})
end
local layouts={
 qwerty=layout_map({}),
 rstlne=layout_map({A="A",B="?",C="C",D="E",E="D",F="R",G="L",H="H",I="K",J="N",K="I",L="O",M="J",N="B",O="Y",P="P",Q="Q",R="F",S="S",T="Z",U="U",V="V",W="W",X="X",Y=":",Z="G",[","]="m",["."]=",",["/"]=".",[":"]="T",[";"]="t",["<"]="M",[">"]="<",["?"]=">",a="a",b="?",c="c",d="e",e="d",f="r",g="l",h="h",i="k",j="n",k="i",l="o",m="j",n="b",o="y",p="p",q="q",r="f",s="s",t="z",u="u",v="v",w="w",x="x",y=";",z="g"}),
 devorak=layout_map({["'"]="-",[","]="w",["-"]="[",["."]="v",["/"]="z",["0"]="0",["1"]="1",["2"]="2",["3"]="3",["4"]="4",["5"]="5",["6"]="6",["7"]="7",["8"]="8",["9"]="9",[";"]="s",["="]="]",["A"]="A",["B"]="X",["C"]="J",["D"]="E",["E"]=".",["F"]="U",["G"]="I",["H"]="D",["I"]="C",["J"]="H",["K"]="T",["L"]="N",["M"]="M",["N"]="B",["O"]="R",["P"]="L",["Q"]="'",["R"]="P",["S"]="O",["T"]="Y",["U"]="G",["V"]="K",["W"]=",",["X"]="Q",["Y"]="F",["Z"]=";",["["]="/",["\\"]="\\",["]"]="=",["`"]="`",["a"]="a",["b"]="x",["c"]="j",["d"]="e",["e"]=".",["f"]="u",["g"]="i",["h"]="d",["i"]="c",["j"]="h",["k"]="t",["l"]="n",["m"]="m",["n"]="b",["o"]="r",["p"]="l",["q"]="'",["r"]="p",["s"]="o",["t"]="y",["u"]="g",["v"]="k",["w"]=",",["x"]="q",["y"]="f",["z"]=";"}),
}
local layout=layouts.rstlne
local new_key
---@type engine
local M={}
M.processor={
 func=function(key,env)
  if  not new_key
  and env.engine.context:get_option("ascii_mode")
  and not env.engine.context:is_composing()
  and key.keycode>0 and key.keycode<=255
  and not key:ctrl()
  and not key:alt()
  and not key:caps()
  and not key:super()
  then
   local char=string.char(key.keycode)
   local new_char=layout[char]
   local new_code=string.byte(new_char)
   new_key=KeyEvent(new_code,key.modifier)
   local s=env.engine:process_key(new_key)
   if s then
    return kAccepted
   elseif not key:release() then
    env.engine:commit_text(new_char)
    return kAccepted
   end
   return kNoop
  end
  new_key=nil
  return kNoop
 end,
}
return M
