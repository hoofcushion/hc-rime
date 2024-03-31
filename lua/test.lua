local a=1
::label::
print("--- 跳转到标签 label ---")
a=a+1
if a<3 then
 goto label    -- 当 a 小于 3 的时候跳转到标签 label
end
