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





;;(Inheritance Bob (And human (Or zac Mike)))

(=(push-back $atom ()) ($atom))
(=(push-back $atom $list) (
    let* (
        ($head (car-atom $list))
        ($tail (cdr-atom $list))
        ($dummy (push-back $atom $tail))
    ) 
     (cons-atom $head $dummy)
))

(=(comp $main_head ()) ())
(=(comp $main_head $list)(
    let* (
        ($x (car-atom $list))
        ($tail (cdr-atom $list))
        ($rst (push-back (push-back $main_head $x) (comp $main_head $tail)))
        
    ) 
       $rst
))
;;!(push-back c (a b))

;;!(comp a ((b) (c)))


(=(combinatorial_insert $h ())((($h))))
(=(combinatorial_insert $h $seq)(
    let*(
        ($head (car-atom $seq))
        ($tail (cdr-atom $seq))
        ($reslut (combinatorial_insert $h $tail))
        ($comp_result (comp $head $reslut))
        
    )
        (push-back (push-back (push-back $h $head) $tail) $comp_result)
))

!(combinatorial_insert D ((A) (B C)))



(((E) (B C D) (A)), ((D) (E) (B C) (A)) ,((E D) (B C) (A)) ,((B C) (E) (A D)))

(((B C D) (A)) ((D) (B C) (A)) ((B C) (A D)))