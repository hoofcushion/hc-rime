local shift={
 "exclam","at","numbersign","dollar","percent","asciicircum","ampersand","asterisk","parenleft",[0]="parenright",
}
return {
 make_toggler         =function(keys,option)
  return {accept=keys,toggle=option,when="composing"}
 end,
 ascii_punct          ={accept="Control+comma",toggle="ascii_punct",when="always"},
 full_shape           ={accept="Control+period",toggle="full_shape",when="always"},
 filter_simplification={accept="Shift+Control+"..shift[1],toggle="simplification",when="always"},
 filter_emoji         ={accept="Shift+Control+"..shift[2],toggle="filter_emoji",when="always"},
 filter_symbol        ={accept="Shift+Control+"..shift[3],toggle="filter_symbol",when="always"},
 filter_zhuyin        ={accept="Shift+Control+"..shift[4],toggle="filter_zhuyin",when="always"},
 filter_decensor      ={accept="Shift+Control+"..shift[5],toggle="filter_decensor",when="always"},
 filter_trans         ={accept="Shift+Control+"..shift[6],toggle="filter_trans",when="always"},
 filter_Unicode       ={accept="Shift+Control+"..shift[7],toggle="filter_Unicode",when="always"},
 filter_Reverse       ={accept="Shift+Control+"..shift[8],toggle="filter_Reverse",when="always"},
}
