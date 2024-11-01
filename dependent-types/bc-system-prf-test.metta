!(register-module! ../../chaining)
!(import! &self chaining:dtl:backward:curried)
!(import! &self bc-system-prf)
; Test
!(syn &self Z (: CPU (⍃ 2 3)))
!(syn &self Z (: CPU (⍃ 4 3)))
!(syn &self Z (: CPUDiff (isDiff (hello world) (this world))))
!(syn &self Z (: CPUDiff (isDiff (test pattern) (test pattern))))
!(syn &self (S (S (S Z))) (: $prf (less $x $y)))
