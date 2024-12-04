! (register-module! ../../../hyperon-miner)

! (register-module! ../../experiments)
! (import! &self experiments:rules:est-tv)
;;! (import! &self experiments:rules:emp-tv)

! (import! &database hyperon-miner:experiments:data:sample-data)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (import! &self hyperon-miner:experiments:utils:TruthValue)
! (import! &self hyperon-miner:experiments:utils:gen_partition)



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