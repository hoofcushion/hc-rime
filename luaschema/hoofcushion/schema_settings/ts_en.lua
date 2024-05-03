return {
 key_binder={
  bindings={
   {accept="Control+6",toggle="fil_trans",     when="always"},
   {accept="Control+7",toggle="fil_Unicode",   when="always"},
   {accept="Control+8",toggle="fil_KijinSeija",when="always"},
  },
 },
 switches={
  {name="ascii_mode",reset=0,states={"汉","英"}},
  {name="ascii_punct",states={"中","　"}},
  {name="full_shape",states={"　","全"}},
  {name="fil_trans",reset=0,states={"　","译"}},
  {name="fil_Unicode",reset=0,states={"字","码"}},
  {name="fil_KijinSeija",reset=0,states={"正","倒"}},
 },
}
