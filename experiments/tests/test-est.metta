! (register-module! ../../../hyperon-miner/experiments)
! (import! &self experiments:utils:common-utils)
! (import! &self experiments:utils:beta-dist)
! (import! &self experiments:utils:constants)
! (import! &self experiments:utils:TruthValue)
! (import! &self experiments:utils:surp-utils)
! (import! &self experiments:utils:miner-utils)
! (import! &self experiments:utils:gen_partition)
! (import! &self experiments:rules:est-tv)
! (import! &self experiments:rules:emp-tv)
! (import! &kb experiments:data:ugly_man_sodaDrinker)







! (bind! square (py-atom numpy.square (-> Number Number)))




! (add-reduct &self (= (get-space) (new-space)))
! (add-atom (get-space) (Inheritance Abe human))
! (add-atom (get-space) (Inheritance Abe human))
! (add-atom (get-space) (Inheritance Abe human))

! (add-atom (get-space) (Inheritance Rio human))
! (add-atom (get-space) (Inheritance Bob human))
! (add-atom (get-space) (Inheritance Mike human))
! (add-atom (get-space) (Inheritance Zac human))
! (add-atom (get-space) (Inheritance Zac human))
! (add-atom (get-space) (Parent Abe Nil ))
! (add-atom (get-space)  (Inheritance Bob (And human (Or zac))) ) 


;!(do-ji-tv-est  &kb (, (Inheritance $x man)  (Inheritance $x ugly) (Inheritance $x sodaDrinker)))
; !(do-ji-tv-est (get-space) (,(Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)))
;(((Inheritance $x man) (Inheritance $x sodaDrinker)) ((Inheritance $x ugly)))
;[((((Inheritance $x man)) ((Inheritance $x sodaDrinker) (Inheritance $x ugly))) ((EMPTV 0.16129032258064516 0.09841269841269841) (EMPTV 0.0 0.09841269841269841)))]

;!(emp-tv  (remove-parenthesis (, (Inheritance $x sodaDrinker) (Inheritance $x ugly))) &kb)
!(size-atom (collapse (match &kb (, (Inheritance $x $y) (Inheritance $x $z)) ($x $y $z)) ))
; !(match &kb (, (Inheritance $x $y) (Inheritance $x $z)) ($x $y))  
