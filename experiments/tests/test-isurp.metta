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


;!(ji_prob_est_interval (,(Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)) (get-space) 2)
;!(isurp (,(Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)) (get-space) True 2)
;!(isurp (,(Inheritance $x sodaDrinker) (Inheritance $x human) (Inheritance $x woman)) &kb True 0.5)

;!(match &kb (,(Inheritance $x sodaDrinker) (Inheritance $x human) (Inheritance $x woman)) $x)


;[0.6455555555555555]
;!(generet-partition-without-pattern (,(Inheritance $x $y)  (Inheritance Abe $y)))
!(generet-partition-without-pattern (,(Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)))

[((((Inheritance $x $y) (Inheritance Abe $y)) ((Inheritance Zac $y)))

  (((Inheritance $x $y)) ((Inheritance Abe $y)) ((Inheritance Zac $y))) 
  (((Inheritance $x $y)) ((Inheritance Abe $y) (Inheritance Zac $y))) 
  (((Inheritance $x $y) (Inheritance Zac $y)) ((Inheritance Abe $y))))]
