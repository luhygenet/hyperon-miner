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
;[0.6455555555555555]
;!(generet-partition-without-pattern (,(Inheritance $x $y)  (Inheritance Abe $y)))
!(generet-partition-without-pattern (,(Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)))



;!(get-variables (Inheritance $x $y))
;!(concatTuple ((A) (B)) ((C) (D)))

;!(joint-variables-init  (Inheritance Abe (Human $x (Or Bob $x)))  (remove-parenthesis (((Or Bob $x)) ((Human $x (Or Bob $x))))) )
;!(get-unique-vars (,(Inheritance $x $y)  (Inheritance Abe (And $z $w))))
;!(get-unique-vars (,(Inheritance $x $y)  (Inheritance Abe (And $z $w))))

 ;!(emp_tv_mem ((Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Abe $x))  (get-space)) 

 ;!(var-appers $x (((Or Bob $x)) ((Human $x (Or Bob $x)))))

 ;!(is-present $z (Inheritance $x $y))

;!(let $temp (collapse (is-present $y ((Or Bob $x))))  $temp)

;!(emp-prob-pbs (,(Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)) (get-space) 3)

;;!(joint-variables-init (, (Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Abe $x)) (remove-parenthesis(((Inheritance $x $y)) ((Inheritance Abe $y)) ( (Inheritance Abe $x)))))



