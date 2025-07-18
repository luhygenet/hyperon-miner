
! (register-module! ../../experiments)

! (import! &self frequent-pattern-miner-new)
! (import! &self experiments:utils:common-utils)
! (import! &db  experiments:data:small-ugly)
; ! (import! &db  experiments:data:ugly_man_sodaDrinker)
! (bind! &kb (new-space))
! (bind! &dbspace (new-space))
! (bind! &specspace (new-space))
! (bind! &cndpspace (new-space))
! (bind! &aptrnspace (new-space))
! (bind! &conjspace (new-space))
! (import! &self freq-pat)
! (import! &self conj-exp)

!(let ($link $x $y) (get-atoms &db) (add-atom &dbspace ($link $x $y)))


! (frequency-pattern-miner &kb &dbspace &specspace &cndpspace &aptrnspace &conjspace 3 0)
! (match &kb $pattern $pattern )