


! (register-module! ../../experiments)
! (import! &self experiments:rules:emp-tv)
! (import! &self experiments:utils:common-utils)
! (import! &self experiments:utils:emp-tv-bs)
! (import! &self experiments:utils:bs-utils)
! (import! &self experiments:rules:emp-prob)





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