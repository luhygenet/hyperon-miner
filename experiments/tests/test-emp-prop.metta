


! (register-module! ../../experiments)

! (import! &kb experiments:data:ugly_man_sodaDrinker)8
! (import! &self experiments:rules:emp-prob)
! (import! &self experiments:rules:emp-tv)
! (import! &self experiments:rules:est-tv)
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
! (import! &self experiments:utils:eq_prop)




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

;  !(emp-prob-pbs (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker) ) &kb 0.5 0.2)
;  !(ji_prob_est_interval (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker) ) &kb  0.2)
; !(emp_prob_bs (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker) ) &kb 5 5)

; !(subsmp-size (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker) ) 64 0.5)

; !(do-ji-prob ((((Inheritance $x man) (Inheritance $x sodaDrinker)) ((Inheritance $x ugly))) (((Inheritance $x man) (Inheritance $x ugly)) ((Inheritance $x sodaDrinker))) (((Inheritance $x man)) ((Inheritance $x sodaDrinker)) ((Inheritance $x ugly))) (((Inheritance $x man)) ((Inheritance $x sodaDrinker) (Inheritance $x ugly)))) (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker)) &Kb 0.5)

; !(ji-prob-est (((Inheritance $x man) (Inheritance $x sodaDrinker)) ((Inheritance $x ugly)))  (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker))  &kb 0.5)
; !(pro-prob-wout-joint (((Inheritance $x man) (Inheritance $x sodaDrinker)) ((Inheritance $x ugly))) &kb 0.5 1)
; !(prob-with-joint &kb (db_size &kb) (remove-parenthesis (((Inheritance $x man) (Inheritance $x sodaDrinker)) ((Inheritance $x ugly)))) (joint-variables-init  (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker)) (remove-parenthesis (((Inheritance $x man) (Inheritance $x sodaDrinker)) ((Inheritance $x ugly))))) 1)
!(let $database_size (db_size &kb) (eq-prob-py (((Inheritance $x man) (Inheritance $x sodaDrinker)) ((Inheritance $x ugly))) (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker)) $database_size))
; !(remove-parenthesis (((Inheritance $x man) (Inheritance $x sodaDrinker)) ((Inheritance $x ugly))))
; !(joint-variables-init  (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker)) (remove-parenthesis (((Inheritance $x man) (Inheritance $x sodaDrinker)) ((Inheritance $x ugly)))))
; !(get-unique-vars  (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker)) )
; !(get-variables (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker)) )
; !(concatTuple (A B) (C D))

'(
(((Inheritance $x man) (Inheritance $x sodaDrinker)) ((Inheritance $x ugly))) 
(((Inheritance $x man) (Inheritance $x ugly)) ((Inheritance $x sodaDrinker))) 
(((Inheritance $x man)) ((Inheritance $x sodaDrinker)) ((Inheritance $x ugly))) 
(((Inheritance $x man)) ((Inheritance $x sodaDrinker) (Inheritance $x ugly)))

)
'

; ((((Inheritance $x man) (Inheritance $x sodaDrinker)) ((Inheritance $x ugly))) (((Inheritance $x man) (Inheritance $x ugly)) ((Inheritance $x sodaDrinker))) (((Inheritance $x man)) ((Inheritance $x sodaDrinker)) ((Inheritance $x ugly))) (((Inheritance $x man)) ((Inheritance $x sodaDrinker) (Inheritance $x ugly))))
; ((((Inheritance $x man) (Inheritance $x ugly)) ((Inheritance $x sodaDrinker))) (((Inheritance $x man)) ((Inheritance $x sodaDrinker)) ((Inheritance $x ugly))) (((Inheritance $x man)) ((Inheritance $x sodaDrinker) (Inheritance $x ugly))))
; ((((Inheritance $x man)) ((Inheritance $x sodaDrinker)) ((Inheritance $x ugly))) (((Inheritance $x man)) ((Inheritance $x sodaDrinker) (Inheritance $x ugly))))
; ((((Inheritance $x man)) ((Inheritance $x sodaDrinker) (Inheritance $x ugly))))