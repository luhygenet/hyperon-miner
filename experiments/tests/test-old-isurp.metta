! (register-module! ../../../hyperon-miner/experiments)
! (import! &self experiments:utils:common-utils)
! (import! &self experiments:utils:beta-dist)
! (import! &self experiments:utils:constants)
! (import! &self experiments:utils:TruthValue)
! (import! &self experiments:utils:surp-utils)
! (import! &self experiments:utils:miner-utils)
! (import! &self experiments:utils:gen_partition)
! (import! &self experiments:rules:est-tv)
! (import! &self experiments:rules:isurp-old)




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



;;;;;;;;;;;
;; Tests ;;
;;;;;;;;;;;

;!(total_counts  (, (Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)) (get-space))

;!(n_conjuncts_new (, (Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)))
;!(sup-num (get-space) (Inheritance Abe $y) )

;!(prob (Inheritance Abe $y) (get-space))
;!(ptrn-support  (, (Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y) (Human Abe Kebe)) (get-space))

;!(prob  (, (Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)) (get-space))

;!(sup-num  (get-space) (Inheritance Zac $y))

;!(accumulator-x (1 2 3 4))

;!(add-pattern ((Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)) (get-space))

!(isurp_old (,(Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)) (get-space) True)

