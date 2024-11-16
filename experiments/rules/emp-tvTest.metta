
! (register-module! ../../experiments)
! (import! &self experiments:rules:emp-tv)
! (register-module! ../../../hyperon-miner)
! (import! &database hyperon-miner:experiments:data:sample-data)
! (import! &self hyperon-miner:experiments:utils:common-utils)

! (add-reduct &self (= (get-space) (new-space)))
! (add-atom (get-space) (Inheritance Abe human))
! (add-atom (get-space) (Inheritance Rio human))
! (add-atom (get-space) (Inheritance Bob human))
! (add-atom (get-space) (Inheritance Mike human))
! (add-atom (get-space) (Inheritance Mike Nil))
! (add-atom (get-space) (Inheritance Zac human))
! (add-atom (get-space) (Inheritance Zac human))
! (add-atom (get-space) (Parent Abe Nil ))

! (emp-tv (Parent $x Nil) (get-space))

! (sup (Inheritance $x $y) (get-space))

 ;! (prob_to_support (Inheritance $x) (collapse (get-atoms (get-space)) ) 1 )
 ; ! (universe-count $pattern $db)
(universe-count ( (Parent $x Nil) (Parent $x Nil)) (get-space))
(universe-count (Inheritance $x ) (get-space))

 ; ! (prob_to_support A (get-space) 1 )
! (db_size (get-space))
! (support_estimate_calculator (Inheritance $x Nil) (get-space) 1 1)
! (categorize_subsize 1 32)
! (emp_tv_pbs (Parent $x Nil) (get-space) 1 1 2 3)
! (do_emp_tv (Inheritance $x Nil) (get-space) 1 )

! (==== test=== copy-db-by-size=== )
! (copy-db-by-size (new-space) (collapse (get-atoms (get-space)) ) 0 10)

(= (duplicate-and-expand-space $space $n)
    (let $new-db (copy-db  (get-space) (collapse (get-atoms (get-space)) ) )
        (add_n_atoms_to_db $new-db $n)

    )
)
! (collapse  (get-atoms (duplicate-and-expand-space (get-space)1)))

! (subsample-py (get-space) 3)
! (emp-tv-subsmp (Inheritance Rio $Y) (get-space) 3)
! (subsmp-size (Inheritance Abe human) 20 0.9)