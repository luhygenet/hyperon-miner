!(register-module! ../../experiments)
!(register-module!  ../../../chaining)
!(import! &self experiments:miner:miner)

;; import utils and rules files 
! (import! &self experiments:rules:isurp)
! (import! &self experiments:utils:common-utils)
! (import! &self experiments:utils:beta-dist)
! (import! &self experiments:utils:constants)
! (import! &self experiments:utils:TruthValue)
! (import! &self experiments:utils:surp-utils)
! (import! &self experiments:utils:miner-utils)
! (import! &self experiments:utils:gen_partition)
! (import! &self experiments:rules:est-tv)
! (import! &self experiments:rules:emp-tv)
! (import! &self experiments:rules:emp-prob)
! (import! &self experiments:utils:emp-tv-bs)
! (import! &self experiments:utils:bs-utils)
! (import! &db experiments:data:ugly_man_sodaDrinker)


;; config kbb : load the chainer , rules , system-proofs ....
!(import! &kb   experiments:miner:miner-rules)
!(import! &sp  experiments:miner:system-proofs)
!(import! &sy  chaining:dtl:backward:curried)

!(add-atom &kb (syPrf-ref &sp))
;;!(test &kb)
;;!(match &sp $x (if (== (get-type $x) hyperon::space::DynSpace) (remove-atom &kb $x) (Empty) )) 
!(get-atoms &sp)

;!(joint-variables-init  (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker)) (remove-parenthesis (((Inheritance $x man) (Inheritance $x sodaDrinker)) ((Inheritance $x ugly)))))


;;!(match &kb $x (if (== (get-type $x) hyperon::space::DynSpace) (remove-atom &kb $x) (Empty) )) 
