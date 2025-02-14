
! (register-module! ../../experiments)

! (import! &self experiments:utils:emp-tv-bs)
! (import! &self experiments:utils:bs-utils)
! (import! &self experiments:utils:common-utils)
! (import! &self experiments:utils:beta-dist)
! (import! &self experiments:utils:constants)
! (import! &self experiments:utils:TruthValue)
! (import! &self experiments:utils:surp-utils)
! (import! &self experiments:utils:miner-utils)
! (import! &self experiments:utils:gen_partition)
! (import! &self experiments:rules:est-tv)
! (import! &self experiments:rules:emp-tv)
! (import! &kb experiments:data:ugly_man_sodaDrinker)



! (add-reduct &self (= (get-space) (new-space)))
! (add-atom (get-space) (Inheritance Abe human))
! (add-atom (get-space) (Inheritance Rio human))
! (add-atom (get-space) (Inheritance Bob human))
! (add-atom (get-space) (Inheritance Mike human))
! (add-atom (get-space) (Inheritance Mike Nil))
! (add-atom (get-space) (Inheritance Zac human))
! (add-atom (get-space) (Inheritance Zac human))
! (add-atom (get-space) (Parent Abe Nil ))



;; Documentation:
;; This code snippet is responsible for initializing the execution space.
;; It does so by retrieving the current space via the get-space function and then passing it
;; to the intilize function. The "!" operator appears to denote an immediate execution of the
;; initialization process.
;; Note: Check for potential typos in "intilize" if the intended function name was "initialize".

!(assertEqual (sup (Inheritance $x $y) (get-space)) 7)

!(assertEqual (universe-count (Inheritance $x ) (get-space)) 8)

!(assertEqual (emp-tv (Inheritance Zac $x) (get-space)) (EMPTV 0.125 0.08888888888888889))

!(assertEqual (db_size (duplicate-and-expand-space (get-space) 1)) (+ 1 (db_size (get-space))))

!(add_n_atoms_to_db (get-space) 4)
!(assertEqual (db_size (get-space)) 12)

;; if the max size is 10, the size of the new db should be 8 because the size of the old db is 8 and it is less than 10
!(assertEqual (db_size (copy-db-by-size (new-space) (collapse (get-atoms (get-space)) ) 0 10)) 10)

;; if the max size is 6, the size of the new db should be 6 because the size of the old db is 8 and it is greater than 6 so
;; we can only copy 6 atoms
!(assertEqual (db_size (copy-db-by-size (new-space) (collapse (get-atoms (get-space)) ) 0 6)) 6)


!(assertEqual (do_emp_tv (Inheritance $x Nil) (get-space) 1 ) (EMPTV 0.08333333333333333 0.09230769230769231))


!(assertEqual (get-element 2 ((Inheritance Abe human) (Inheritance Rio human) (Inheritance Bob human) (Inheritance Mike human) (Inheritance Mike Nil) (Inheritance Zac human) (Inheritance Zac human) (Parent Abe Nil ))) (Inheritance Bob human))

!(assertEqual (subsmp-size (Inheritance Abe human) 20 0.9) ((py-atom numpy.power) 44.44444444444445 1))


!(assertEqual (emp-tv-bs (Inheritance Zac $x) (get-space) 8 0.6 0.9) (EMPTV 0.2428095704426711 0.04109232092138521))

!(assertEqual (mk-stv 1.7689693569125715 1.0178393379503528 ) (EMPTV 0 0.0001249843769528809))








 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ; ! (sup (Inheritance $x $y) (get-space))

;  ! (prob_to_support (Inheritance $x) (collapse (get-atoms (get-space)) ) 1 )
;  ! (universe-count $pattern $d; !(universe-count ( (Parent $x Nil) (Parent $x Nil)) (get-space))

;  ! (prob_to_support A (get-space) 1 )



; ! (support_estimate_calculator (Inheritance $x Nil) (get-space) 1 1)
; ! (categorize_subsize 1 32)
; ! (emp_tv_pbs (Parent $x Nil) (get-space) 1 1 2 3)

; ! (do_emp_tv (Inheritance $x Nil) (get-space) 1 )

; ! (==== test=== copy-db-by-size=== )
; ! (copy-db-by-size (new-space) (collapse (get-atoms (get-space)) ) 0 10)

; (= (duplicate-and-expand-space $space $n)
;     (let $new-db (copy-db  (get-space) (collapse (get-atoms (get-space)) ) )
;         (add_n_atoms_to_db $new-db $n)

;     )
; )
; ! (collapse  (get-atoms (duplicate-and-expand-space (get-space)1)))

; ! (get-atoms (subsample-py (get-space) 3))
; ! (emp-tv-subsmp (Inheritance Rio $Y) (get-space) 3)
; ! (subsmp-size (Inheritance Abe human) 20 0.9)



; !(get-atoms (subsample-py (get-space) 3))

; !(emp-tv-subsmp (Inheritance Zac $x) (get-space) 5)

; !(subsmp-size (Inheritance Zac $x) 8 0.5)

; !(emp-tv-bs (Inheritance Zac $x) (get-space) 8 0.6 0.9) 

; !(BetaDistribution (EMPTV 0.9773269689737469 0.0009825445253591023) )

; !(mk-stv 1.7689693569125715 1.0178393379503528 )
; !(ji_tv_est (Patern Ryo Ri) &self)

; !(do_emp_tv (Inheritance Zac Eyob) (get-space) 0.8)
