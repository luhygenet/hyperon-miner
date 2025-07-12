! (register-module! ../../../hyperon-miner)
; ! (import! &dbspace hyperon-miner:experiments:data:sample-data)
! (import! &db hyperon-miner:experiments:data:ugly_man_sodaDrinker)
! (import! &self hyperon-miner:experiments:rules:frequent-pattern-miner)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (bind! &kb (new-space))
! (bind! &dbspace (new-space))
! (bind! &specspace (new-space))
! (bind! &cndpspace (new-space))
! (bind! &aptrnspace (new-space))
! (bind! &conjspace (new-space))
; ! (import! &self freq-pat)
; ! (import! &self conj-exp)

!(let ($link $x $y) (get-atoms &db) (add-atom &dbspace ($link $x $y)))


! (frequency-pattern-miner &kb &dbspace &specspace &cndpspace &aptrnspace &conjspace 5 0)
! (match  &conjspace $pattern $pattern)