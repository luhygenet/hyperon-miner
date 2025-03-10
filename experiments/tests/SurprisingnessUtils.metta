
 ;;;;;;;;;;
 ;; Imports ;;
 ;;;;;;;;;;

! (register-module! ../../experiments)
! (import! &self experiments:rules:emp-tv)
! (import! &self experiments:utils:common-utils)
! (import! &self experiments:utils:emp-tv-bs)
! (import! &self experiments:utils:bs-utils)

! (import! &self  test-utils)

! (import str as ::str)
! (import json.loads)

! (import os.getenv as get_env)
! (import dotenv.load_dotenv as load_dotenv)
! (import requests.post as POST)

 ; JsonAtom means: wrapped python dictionary / list
(: ::JSON (-> Any JsonAtom))
(= (::JSON $x) (py-atom (json.loads $x)))

(: get (-> JsonAtom String JsonAtom))
(= (get $dict $key)
    ( (py-dot (py-atom $dict) get) $key))

(: get_index (-> JsonAtom Number JsonAtom))
(= (get_index $list $index)
    ( (py-dot (py-atom $list) __getitem__) $index))

(= (rget $x ()) (empty))
 ; ----------------------

 ; traverse as list
(= (rget $list (>> $index ()))
    (get_index $list $index))
(= (rget $list (>> $x $xs))
    (rget (get_index $list $x) $xs))

 ; traverse as dict
(= (rget $dict (:: $path ()))
    (get $dict $path))
(= (rget $dict (:: $x $xs))
    (rget (get $dict $x) $xs))

! (import getattr)

(= (inspect $x) (getattr $x "__dict__"))

(= (import $y as $x)
    (bind! $x (py-atom $y)))
(= (import $x)
    (import $x as $x))

 > Python imports
 --------------

! (import str as ::str)

 ;database setup
 ;;check if the index is out of range
(: out_of_index (-> Number Number Boolean))
(= (out_of_index $n_cpts $x) (>= $x $n_cpts))

 ;;add link and populate uniform inheritance link
(= (add_link_and_populate_uniform_inheritance_link $n_cpts $i $j $cpts)
    (let $_  (add-atom (db) (Inheritance_Link (get_index (py-list ( $cpts)) $i) (get_index (py-list ( $cpts)) $j)) )
        (populate_uniform_inheritance_link $n_cpts $i $j $cpts))
)

 ;;populate uniform inheritance link

(= (populate_uniform_inheritance_link  $n_cpts $i $j $cpts)
    (if (>= $i $n_cpts)
        ()
        (case (out_of_index $j $n_cpts)
            (
                ($x (add_link_and_populate_uniform_inheritance_link $n_cpts (+ $i 1) $j $cpts))
                ($y  (add_link_and_populate_uniform_inheritance_link $n_cpts $i (+ $j 1)$cpts))

            )

    ))

)

 ;;populate uniform inheritance links
(= (populate_uniform_inheritance_links $n_cpts $ip)
    (let $cpts ( populate_concept 2)
        (populate_uniform_inheritance_link $n_cpts 0 0  $cpts ))
)



 






(: sum (-> (List $a) Number))
(= (sum Nil) 0)
(= (sum (Cons $head $tail))  (+ $head (sum  $tail)))

(: avrg (-> (List Number) Number))
(= (avrg $lst)

    (case (tuple-count $lst)
        ( (0 0)
            ($_ (// (sum $lst) (tuple-count $lst))))
    )
)

(: len (-> (List $a) Number))
(= (len Nil) 1)
(= (len (Cons $head $tail))  (+ 1 (len  $tail)))



(: abs (-> Number Number))
(= (abs $x)
    (if (>= $x 0)
        $x
        (* $x -1)
    )
)

(: TS_ASSERT_DELTA (->  Number Number Number Bool))
(= (TS_ASSERT_DELTA $x $y $delta)
    (if (<= (abs (- $x $y)) $delta)
        (True)
        (False)
    )
)

(= (test_emp_prob_bs_1 $pattern $db)
    (let*
        ( ( ($_ ) ( populate_uniform_inheritance_links 1 0.01))
            ( ($pattern) (Nil))
            ( ($epr) ( (emp-prob $pattern $db)))
            ( ($epr_bs) ( (emp_prob_bs $pattern $db 10 1000)) )
        )
    (TS_ASSERT_DELTA $epr  $epr_bs 0.1)))
 ;categories subsize it categorizes into two categories
(= (categorize_subsize $subsize $ts)
    (if   (> $subsize (// $ts 2))
        2
        1)

)

 ;; The copyDatabase function is designed to create a copy of the given database and return the new database.
 ;;This function ensures that all the contents of the original database are duplicated into a new database instance
(: copyDatabase (-> %Undefined% %Undefined%))
(= (copyDatabase $db)
     ;;construct new databas  get atoms of the database and add it to the new database.
)



 ;;TODO: add n atoms to the database
(= (add_n_atoms_to_db $db $n)
    (if (<= $n 0) $db
        (let* ( ($_ (add-atom $db Pattern))

            )
        (add_n_atoms_to_db $db (- $n 1))
    )

)

)

(= (copy-and-add-atom $db $n)

    (if (<= $n 0) $db
        (let* ( ($new-db (copy-db (new-space) ( (collapse (get-atoms $db)) ))))

        )
    (add_n_atoms_to_db $db $n)
)

)

(= (duplicate-and-expand-space $space $n)
    (let $new-db (copy-db  (get-space) (collapse (get-atoms (get-space)) ) )
        (add_n_atoms_to_db $new-db $n)

    )
)
; ! (duplicate-and-expand-space (new-space))
 ;;TODO: remove n atoms from the database

(= (copy-db-by-size $db $old-db-content $n $size)
    (if (or (== $old-db-content ()) (>= $n $size)) $db
        (let* ( ($_ (add-atom $db (car-atom $old-db-content))))
            (copy-db-by-size $db (cdr-atom $old-db-content) (+ $n 1) $size)
        )

)
)



! (add-reduct &self (= (get-space) (new-space)))
! (add-atom (get-space) (Inheritance Abe human))
! (add-atom (get-space) (Inheritance Rio human))
! (add-atom (get-space) (Inheritance Bob human))
! (add-atom (get-space) (Inheritance Mike human))
! (add-atom (get-space) (Inheritance Mike Nil))
! (add-atom (get-space) (Inheritance Zac human))
! (add-atom (get-space) (Inheritance Zac human))
! (add-atom (get-space) (Parent Abe Nil ))

; !(emp-prob (Inheritance $x human) (get-space))
; !(subsample-py (get-space) 3)
; !(sup (Inheritance $x $y) (get-space))
; !(emp_prob_subsmp (Inheritance Abe human) (get-space) 4)
; ! (emp_prob_helper (Inheritance $x human) (get-space) 5 4)
!(emp_prob_bs (Inheritance $x human) (get-space) 5 4)
