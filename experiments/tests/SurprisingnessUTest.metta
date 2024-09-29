
 ;;;;;;;;;;
 ;; Imports ;;
 ;;;;;;;;;;
! (register-module! ../../experiments)
 ; ! (import! &self experiments:tests:List)
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

 ; > Python imports
 ; --------------

! (import str as ::str)

 ;database setup
! (add-reduct &self (= (get-space) (new-space)))
(= (db) (get-space))
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

 ;;test

! (add_link_and_populate_uniform_inheritance_link 3 1 4 (py-list ( (''))))
! (populate_uniform_inheritance_links 1 2)
! (biased_randbool 100)
! (populate_uniform_inheritance_link 1 0 0)
! (out_of_index 3 4)
! (add_link_and_populate_uniform_inheritance_link 0 0 0 (py-list ( ( ''))))
 ; ! (get-atoms (db))