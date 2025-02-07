
! (register-module! ../../experiments)
! (import! &self experiments:rules:emp-tv)
! (import! &self experiments:utils:common-utils)
! (import! &self experiments:utils:emp-tv-bs)
! (import! &self experiments:utils:bs-utils)



! (add-reduct &self (= (get-space) (new-space)))
! (add-atom (get-space) (Inheritance Abe human))
! (add-atom (get-space) (Inheritance Rio human))
! (add-atom (get-space) (Inheritance Bob human))
! (add-atom (get-space) (Inheritance Mike human))
! (add-atom (get-space) (Inheritance Mike Nil))
! (add-atom (get-space) (Inheritance Zac human))
! (add-atom (get-space) (Inheritance Zac human))
! (add-atom (get-space) (Parent Abe Nil ))



!(assertEqual (sup (Inheritance $x $y) (get-space)) 7)

!(assertEqual (universe-count (Inheritance $x ) (get-space)) 8)

!(assertEqual (emp-tv (Inheritance Zac $x) (get-space)) (EMPTV 0.25 0.08888888888888889))

!(assertEqual (db_size (duplicate-and-expand-space (get-space) 1)) (+ 1 (db_size (get-space))))

; !(add_n_atoms_to_db (get-space) 4)
!(assertEqual (db_size (get-space)) 12)

;; if the max size is 10, the size of the new db should be 8 because the size of the old db is 8 and it is less than 10
!(assertEqual (db_size (copy-db-by-size (new-space) (collapse (get-atoms (get-space)) ) 0 10)) 8)

;; if the max size is 6, the size of the new db should be 6 because the size of the old db is 8 and it is greater than 6 so
;; we can only copy 6 atoms
!(assertEqual (db_size (copy-db-by-size (new-space) (collapse (get-atoms (get-space)) ) 0 6)) 6)

; ! (sup (Inheritance $x $y) (get-space))

;  ! (prob_to_support (Inheritance $x) (collapse (get-atoms (get-space)) ) 1 )
;  ! (universe-count $pattern $d; !(universe-count ( (Parent $x Nil) (Parent $x Nil)) (get-space))

;  ! (prob_to_support A (get-space) 1 )
; ! (db_size (get-space))
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

!(do_emp_tv (Inheritance Zac Eyob) (get-space) 0.8)

