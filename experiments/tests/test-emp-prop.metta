


! (register-module! ../../experiments)
! (import! &self experiments:rules:emp-tv)
! (import! &self experiments:rules:est-tv)
! (import! &self experiments:utils:common-utils)
! (import! &self experiments:utils:emp-tv-bs)
! (import! &self experiments:utils:bs-utils)
! (import! &self experiments:utils:)
! (import! &self experiments:rules:emp-prob)
! (import! &kb experiments:data:ugly_man_sodaDrinker)
! (import! &self experiments:rules:isurp)
! (import! &self experiments:utils:gen_partition)







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


;!(emp-prob-pbs (, (Inheritance $x $z) (Inheritance $x human)) (get-space) 0.5)

; !(emp-prob-pbs (Inheritance $x human) (get-space) 0.9 0.5)

 ;!(emp-prob-pbs (Inheritance $x human) (get-space) 3)

 ;;!(emp-prob-pbs (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker) ) &kb  0.2)
 ;!(ji_prob_est_interval (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker) ) &kb  0.2)