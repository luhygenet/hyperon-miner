! (register-module! ../../../hyperon-miner)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (import! &self hyperon-miner:experiments:utils:beta-dist)
! (import! &self hyperon-miner:experiments:utils:surp-utils)
! (import! &self hyperon-miner:experiments:utils:miner-utils)
! (import! &self hyperon-miner:experiments:utils:gen_partition)
! (import! &self hyperon-miner:experiments:rules:est-tv)
! (import! &self hyperon-miner:experiments:rules:isurp)




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


;!(ji_prob_est_interval (,(Inheritance $x $y)  (Inheritance Abe $y)) (get-space) 2)
;!(isurp (,(Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)) (get-space) True 2)
;[0.6455555555555555]

!(min-max (1 2 3 4 5))
;!(generet-partition-without-pattern (,(Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)))




(Inheritance A D)

(Inheritance A D)