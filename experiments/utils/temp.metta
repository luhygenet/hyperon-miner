! (register-module! ../../experiments)
! (import! &self experiments:rules:emp-tv)
! (import! &self experiments:rules:est-tv)
! (register-module! ../../../hyperon-miner)
! (import! &database hyperon-miner:experiments:data:sample-data)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (import! &self hyperon-miner:experiments:utils:TruthValue)
! (bind! square (py-atom numpy.square (-> Number Number)))




! (add-reduct &self (= (get-space) (new-space)))
! (add-atom (get-space) (Inheritance Abe human))
! (add-atom (get-space) (Inheritance Rio human))
! (add-atom (get-space) (Inheritance Bob human))
! (add-atom (get-space) (Inheritance Mike human))
! (add-atom (get-space) (Inheritance Zac human))
! (add-atom (get-space) (Inheritance Zac human))
! (add-atom (get-space) (Parent Abe Nil ))
! (add-atom (get-space)  (Inheritance Bob (And human (Or zac))) ) 

;! (emp-tv (Inheritance $x human) (get-space))





                
;;!(confidence->count 1.02)



;!(get_tv_conf (STV 12 34))








 ;;!(prod-etv (get-space)  ((Inheritance Abe human) (Inheritance Rio human) (Inheritance Bob human)) )
;; !(emp_tv_mem   ((Inheritance Abe human) (Inheritance Rio human) (Inheritance Bob human)) (get-space))




;; !(ji-est-tv (get-space)  ((Inheritance $x human) (Inheritance $y human) (Inheritance $x $y)) )
;; !(mk_distribution_list (((Inheritance $x human) (EMPTV 1.0 0.05)) ((Inheritance $y human) (EMPTV 1.0 0.05)) ((Inheritance $x human) (EMPTV 1.0 0.05))))




;;!(test_avrg_tv_1)

;;!(confidence->count 0.8)
;;!(default_k)


;; https://www.boost.org/doc/libs/1_86_0/libs/math/doc/html/math_toolkit/dist_ref/dists/beta_dist.html



;; (0.011002444987775062 0.00011841900934533786)




;;for test
;;!(find_beta 0.6 0.05) alpha 2.28 beta 1.52

;;!(mk_stv 0.6 0.05) (0.711111111111111 0.004727544165215228)

;;!(mk_stv 0.011002444987775062 0.00011841900934533786) 





(= (concatTuple $xs $ys)
    (if (== $xs ())
        $ys
        (let* ( ($head (car-atom $xs)) 
                ($tail (cdr-atom $xs)) 
                ($tailNew (concatTuple $tail $ys)))
            (cons-atom $head $tailNew))  
    )
)

;; base case
(=(get-clouses () ) ())

(= (get-clouses $pattern)
        (let* (
                ($head (car-atom $pattern)) 
                ($tail (cdr-atom $pattern)))
           
            (if (== (get-metatype $head) Expression)
                (
                   let $result  (concatTuple ($head)
                    (get-clouses $tail)) (concatTuple $result (get-clouses $head)))

                    (get-clouses $tail)))
    )


 ;; !(get-clouses  (Inheritance (Human $X (And $x $y)) (Inheritance $Y (Human $Z))))



(=(combinatorial_insert $handle ()) ($handle))

(=(combinatorial_insert $handle $seq_of_seq )(
    let* (
        ($head (car-atom $seq_of_seq))
        ($tail (cdr-atom $seq_of_seq))
        ($temp  (cons-atom $handle ($head)))
        ($temp2 (concatTuple ($temp) $tail))
        ($dummy (combinatorial_insert $handle $tail))

    )
          (cons-atom $temp2 $dummy)
))

 !(combinatorial_insert (AND $d $f) ((In $x $y)(In $x $z)(Hu $x)))

;;(Inheritance Bob (And human (Or zac Mike)))








