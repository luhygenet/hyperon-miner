


! (register-module! ../../experiments)

! (import! &kb experiments:data:ugly_man_sodaDrinker)
! (import! &self experiments:rules:emp-prob)
! (import! &self experiments:rules:emp-tv)
! (import! &self experiments:rules:est-tv)
; ! (import! &self experiments:utils:eq_prob)
! (import! &self experiments:rules:isurp)
! (import! &self experiments:utils:beta-dist)
! (import! &self experiments:utils:bs-utils)
! (import! &self experiments:utils:common-utils)
! (import! &self experiments:utils:constants)
! (import! &self experiments:utils:emp-tv-bs)
! (import! &self experiments:utils:gen_partition)
! (import! &self experiments:utils:surp-utils)
! (import! &self experiments:utils:TruthValue)
! (import! &self experiments:utils:miner-utils)
! (import! &self experiments:utils:eq_prob_adaptor)




! (add-reduct &self (= (get-space) (new-space)))
! (add-atom (get-space) (Inheritance Abe human))
! (add-atom (get-space) (Inheritance Rio human))
! (add-atom (get-space) (Inheritance Bob human))
! (add-atom (get-space) (Inheritance Mike human))
! (add-atom (get-space) (Inheritance Mike Nil))
! (add-atom (get-space) (Inheritance Zac human))
! (add-atom (get-space) (Inheritance Zac human))
! (add-atom (get-space) (Parent Abe Nil ))

;





!(assertEqual (n_conjuncts (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker) )) 3)

!(assertEqual (subsmp-size (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker) ) 64 0.5) 149.7097081964987)


!(assertEqual (pro-prob-wout-joint (((Inheritance $x man) (Inheritance $x sodaDrinker)) ((Inheritance $x ugly))) &kb 0.5 1)0.09135566413047788)



!(assertEqual (eq-prob-py (((Inheritance $x man) (Inheritance $x ugly)) ((Inheritance $x $y))) (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker)) 61) 0.01639344262295082)


!(assertEqual (remove-parenthesis (((Inheritance $x man)))) (Inheritance $x man))


!(assertEqual (get-unique-vars  (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker))) ($x))


!(assertEqual (joint-variables-init  (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker)) (remove-parenthesis (((Inheritance $x man) (Inheritance $x sodaDrinker)) ((Inheritance $x ugly))))) ($x))



!(assertEqual (ji-prob-est (((Inheritance $x man) (Inheritance $x sodaDrinker)) ((Inheritance $x ugly)))  (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker))  &kb 0.5) 0.009135566413047788)