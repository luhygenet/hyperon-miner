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

;;! (emp-tv (Inheritance $x human) (get-space))

;!(estimate_v_xi (get-space) (Inheritance Abe $y))






(=(total_counts $pattern $db) (pow (db_size $db) (n_conjuncts_new $pattern)))


(=(accumulator-x $num_list) (accumulator-x $num_list 1))
(=(accumulator-x $num_list $prev_value)  (
   if (== $num_list ()) $prev_value (let ($head $tail) (decons-atom $num_list) (accumulator-x $tail (* $head $prev_value)))
))


(=(n_conjuncts_new $pattern) (
   let ($head $tail) (decons-atom $pattern) (
    if (== $head ,) (tuple-count $tail) 1)
))


(=(compute-component-support $cps $db)(
  if (== $cps ()) () (
    let* (  (($head $tail) (decons-atom $cps)) 
            ($sup_num (sup-num $db $head) )
            ($dummy (compute-component-support $tail $db))
    )
       (cons-atom $sup_num $dummy)
    )
  )
) 

(=(ptrn-support $pattern $db)(
    let $cps (get-cnj-clouses $pattern) 
        (if (== $cps ()) 1 (accumulator-x (compute-component-support $cps $db)))
))

(=(prob $pattern $db) (/ (ptrn-support  $pattern $db) (total_counts $pattern $db)))

(=(add-pattern $blks $db) (
let* ( ($pattern (cons-atom , $blks)) ($dummy (add-atom $db $pattern))) $pattern
))
`


(=(blk-prob $partition $db) (prob (add-pattern $partition $db) $db))

(=(p-blk-prob $partition $db) (
    if (== $partition ()) () (let* ((($blk $tail) (decons-atom $partition))
                                    ( $res (blk-prob $blk $db) )
                                    ($dummy (p-blk-prob $tail $db))) 
                                    (cons-atom $res $dummy))))


(=(iprob $prtns $db) (
   if (== $prtns ()) ()  (let* ((($partition $tail) (decons-atom $prtns)) 
                                 ($temp (accumulator-x (p-blk-prob $partition $db)))
                                ($dummy (iprob $tail $db))) (cons-atom $temp $dummy))
))




(((Inheritance $x $y) (Inheritance Zac $x)) ((Inheritance Abe $y))) 


(=(isurp_old $pattern $db $normalize) (
    let* (
        ($pattern_prob (prob $pattern $db ))
         (($emin $emax) (min-max (iprob (generet-partition-without-pattern $pattern) $db)))
         ($dst (dst_from_interval $emin $emax $pattern_prob))
    ) 
         (min ((if $normalize (/ $dst $pattern_prob) $dst) 1.0))
        
) )







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

!(isurp_old (, (Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)) (get-space) True)
