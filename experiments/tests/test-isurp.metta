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
! (import! &self experiments:rules:isurp)
! (import! &self experiments:rules:emp-prob)
! (import! &kb experiments:data:ugly_man_sodaDrinker)
! (import! &self experiments:utils:eq_prob_adaptor)








!(assertEqual (ji_prob_est_interval (, (Ixnheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)) (get-space) 2) 2)


!(assertEqual (ji-prob-est (((Inheritance $x man) (Inheritance $x sodaDrinker)) ((Inheritance $x ugly)))  (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker))  &kb 0.5) 0.009135566413047788)

!(assertEqual (do-ji-prob ((((Inheritance $x man) (Inheritance $x sodaDrinker)) ((Inheritance $x ugly))) (((Inheritance $x man) (Inheritance $x ugly)) ((Inheritance $x sodaDrinker))) (((Inheritance $x man)) ((Inheritance $x sodaDrinker)) ((Inheritance $x ugly))) (((Inheritance $x man)) ((Inheritance $x sodaDrinker) (Inheritance $x ugly)))) 
                            (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker))
                            &Kb 
                            0.5
                          )
               (0.1 0.1 0.01 0.1)
 )

 !(assertEqual (ji_prob_est_interval (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker) ) &kb  0.2) (0.009135566413047788 0.13155215634788814))






