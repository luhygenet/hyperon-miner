! (register-module! ../../experiments)
; ! (import! &dbspace hyperon-miner:experiments:data:sample-data)
! (import! &db experiments:data:ugly_man_sodaDrinker)
! (import! &self experiments:utils:common-utils)
!(import! &self temp)
; ! (import! &dbspace hyperon-miner:experiments:data:sample-data)
! (bind! &kb (new-space))
! (bind! &dbspace (new-space))



 !(let ($link $x $y) (get-atoms &db) (add-atom &dbspace ($link $x $y)))

! (frequency-pattern-miner &kb &dbspace 5 1)
! (match &specspace $pattern $pattern)


