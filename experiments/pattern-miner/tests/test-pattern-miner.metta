! (register-module! ../../../../hyperon-miner)

! (import! &self hyperon-miner:experiments:frequent-pattern-miner:frequent-pattern-miner)
! (import! &self hyperon-miner:experiments:pattern-miner:pattern-miner)
! (import! &self hyperon-miner:experiments:utils:common-utils)

! (import! &self hyperon-miner:experiments:pattern-miner:pattern-miner)

! (import! &self hyperon-miner:experiments:utils:binomialMetta)
! (import! &self hyperon-miner:experiments:utils:beta-dist)
! (import! &self hyperon-miner:experiments:utils:constants)
! (import! &self hyperon-miner:experiments:utils:TruthValue)
! (import! &self hyperon-miner:experiments:utils:surp-utils)
! (import! &self hyperon-miner:experiments:utils:miner-utils)
! (import! &self hyperon-miner:experiments:utils:gen_partition)
! (import! &self hyperon-miner:experiments:truth-values:est-tv)

! (import! &db hyperon-miner:experiments:data:small-ugly)


;; create the database 
!(bind! &dbb (new-space))




;; space to hold the miner result
!(bind! &res1 (new-space))


;(: space hyperon::space::DynSpace)


---------------------------------------------------
;; mine frequent patterns without surprissingness 
---------------------------------------------------
;; number of conjucts 2 , so the depth will be 0
;; surprissingness mode none
;; minimum support 3

 !(pattern-miner &res1 &db 3 0 none)
; ! (collapse (match &res1 $pattern $pattern )
;; Expected result 
          ; ((supportOf (, (Inheritance $y human) (Inheritance $y man)) 3) 
          ; (supportOf (, (Inheritance $j human) (Inheritance $j ugly)) 3) 
          ; (supportOf (, (Inheritance $p human) (Inheritance $p sodaDrinker)) 3) 
          ; (supportOf (, (Inheritance $r man) (Inheritance $r ugly)) 3) 
          ; (supportOf (, (Inheritance $x man) (Inheritance $x sodaDrinker)) 3) 
          ; (supportOf (, (Inheritance $x sodaDrinker) (Inheritance $x ugly)) 3) 
          ; (supportOf (, (Inheritance Abe $r) (Inheritance Cason $r)) 4) (
          ;   supportOf (, (Inheritance Abe $l) (Inheritance Allen $l)) 4) 
          ;   (supportOf (, (Inheritance Allen $g) (Inheritance Cason $g)) 4)))


