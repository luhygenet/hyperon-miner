! (register-module! ../../../hyperon-miner/experiments)
! (import! &self experiments:utils:common-utils)
! (import! &self experiments:utils:binomialMetta)
! (import! &self experiments:utils:beta-dist)
! (import! &self experiments:utils:constants)
! (import! &self experiments:utils:TruthValue)
! (import! &self experiments:utils:surp-utils)
! (import! &self experiments:utils:miner-utils)
! (import! &self experiments:utils:gen_partition)
! (import! &self experiments:rules:est-tv)
! (import! &self experiments:rules:isurp-old)
! (import! &db experiments:data:ugly_man_sodaDrinker)







;;;;;;;;;;;
;; Tests ;;
;;;;;;;;;;;
;; Test old normalized I-Surprisingess for the ugly male soda drinker
;!(isurp-old (,(Inheritance $x man) (Inheritance $x sodaDrinker) (Inheritance $x ugly)) &db  True)
;!(isurp-old (,(Inheritance $x man) (Inheritance $x ugly)) &db  True)


;; test component frequecy product
;!(get-cnj-clouses (Inheritance $x man) )

;!(ptrn-support (, (Inheritance $x man) (Inheritance $x sodaDrinker) (Inheritance $x ugly)) &db)
;!(ptrn-support (Inheritance $x man) &db)
;!(prob (, (Inheritance $x man) (Inheritance $x sodaDrinker) (Inheritance $x ugly)) &db)
;!(iprob (generet-partition-without-pattern (, (Inheritance $x man) (Inheritance $x sodaDrinker) (Inheritance $x ugly))) &db)

;!(generet-partition-without-pattern (, (Inheritance $x man) (Inheritance $x sodaDrinker) (Inheritance $x ugly)))
[(
    (((Inheritance $x man) (Inheritance $x sodaDrinker)) ((Inheritance $x ugly))) 
(((Inheritance $x man)) ((Inheritance $x sodaDrinker)) ((Inheritance $x ugly))) 
(((Inheritance $x man)) ((Inheritance $x sodaDrinker) (Inheritance $x ugly)))
 (((Inheritance $x man) (Inheritance $x ugly)) ((Inheritance $x sodaDrinker))))]

 !(iprob (((Inheritance $x man) (Inheritance $x sodaDrinker)) ((Inheritance $x ugly))) &db)

 (let $res (collapse (blk-prob 
 (superpose (((Inheritance $x man) (Inheritance $x sodaDrinker)) 
 ((Inheritance $x ugly)))) &db))(foldl-atom $res 1 $a $b (* $a $b)))

 ;!(prob (, (Inheritance $x man) (Inheritance $x sodaDrinker)) &db)
 ;!(remove-parenthesis (superpose (((Inheritance $x man) (Inheritance $x sodaDrinker)) ((Inheritance $x ugly))) ))

 ;!(ptrn-support (Inheritance $x ugly) &db)

;!(get-cnj-clouses (, (Inheritance $x ugly))) 

 (* (sup-num ModuleSpace(GroundingSpace-top:experiments:data:ugly_man_sodaDrinker) get-cnj-clouses) 
 (* (sup-num ModuleSpace(GroundingSpace-top:experiments:data:ugly_man_sodaDrinker) (Inheritance $x ugly)) 1))