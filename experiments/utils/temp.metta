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




(= (decons-atom $exp)
    ((car-atom $exp) (cdr-atom $tail))
)

(= (concatTuple $xs $ys)
    (if (== $xs ())
        $ys
        (let* ( (($head $tail) (decons-atom $xs))
                ($tailNew (concatTuple $tail $ys)))
                 (cons-atom $head $tailNew))  ))
(=(is-symbol $var) 
   (== (get-metatype $var) Symbol)
)

(=(is-variable $var) 
   (== (get-metatype $var) Variable)
)

(=(is-expression $var) 
  (== (get-metatype $var) Expression)
  ;; (if (== $var ()) False (== (get-metatype $var) Expression))
)

(=(push-back $atom ()) ($atom))
(=(push-back $atom $list) (
    let* (
        (($head $tail) (decons-atom $list))
        ($dummy (push-back $atom $tail))
    ) 
     (cons-atom $head $dummy)
))

(=(reverse-list ()) ())
(=(reverse-list $subparts)(
      let ($head $tail) (decons-atom $subparts) (push-back $head (reverse-list $tail))
))


(=(remove-element $element ())())
(=(remove-element $element $list) (
    let ($head $tail) (decons-atom $list) (
        if (== $element $head) (remove-element $element $tail) (
            let $dummy (remove-element $element $tail) (cons-atom $head $dummy)
        )
    )
))


(=(append-list $atom ()) ($atom))
(=(append-list $atom $list) (
    let* (
        (($head $tail) (decons-atom $list))
        ($dummy (append-list $head $tail))
    ) 
     (cons-atom $atom $dummy)
))

(=(append-list-v2 $atom ()) ($atom))
(=(append-list-v2 $atom $list) (
    let* (
        (($head $tail) (decons-atom $list))
        ($dummy ((append-list $head $tail)))
    ) 
     (cons-atom $atom $dummy)
))

(=(insert () $res) $res)
(=(insert $subparts $res)(
      let ($head $tail) (decons-atom $subparts) (let $temp (push-back $head $res) (insert $tail $temp))
))

(=(is-present $atom ()) False)
(=(is-present $atom $list) (
    if (is-expression $list) (
    let ($head $tail) (decons-atom $list) (
        if (== $atom $head) True  (or (is-present $atom $head) (is-present $atom $tail))
    )) (if (== $atom $head) True False)
))

(=(is-valid () $partion) True)
(=(is-valid $clous $partion)(
    let ($head $tail) (decons-atom $clous)  (and (is-present $head $partion) (is-valid $tail $partion)) 
)
)

;;!(is-valid ((A) (B)) (((A) (C))))
;;!(is-valid ((Parent $x) (Human $y)) ((Parent $x) (Human $y)))

(=(is-pattern $expr) (
    collapse(
 or (unify $expr ($link $x $y) (
       and (is-symbol $link) (
        or (or (is-variable $x) (is-expression $x))
             (or (is-variable $y) (is-expression $y)))) False)
    (unify $expr ($link $x) 
       (and (is-symbol $link) 
        (or (is-variable $x) 
            (is-expression $x))) False )  ))
)

(=(comp $main_head ()) ())
(=(comp $main_head $list)(
    let* (
        (($x $tail) (decons-atom $list))
        ($rst (append-list (append-list $main_head $x) (comp $main_head $tail)))   
    ) $rst
))

;; !(get-clouses  (Inheritance (Human $X (And $x $y)) (Inheritance $Y (Human $Z))))
;;(Inheritance Bob (And human (Or zac Mike)))
;!(apend-list a (b c)) 
;;!(insert  (4 5 6) (1 2 3) )
;;!(push-back 4 (1 2 3))


(=(combinatorial_insert $h ())((($h))))
(=(combinatorial_insert $h $seq)(
    let*(
        (($head $tail) (decons-atom $seq))
        ($reslut (combinatorial_insert $h $tail))
        ($comp_result (comp $head $reslut))    
    )
       (append-list (append-list (append-list $h $head) $tail) $comp_result)
 
))


;!(combinatorial_insert (Bob $x) ((Human $x) (Parent $x)))
;!(combinatorial_insert D ((A) (B) (C)))



(=(mk-combinatorial_insert $main_head ())(combinatorial_insert $main_head ()))
(=(mk-combinatorial_insert $main_head $parts)(
    let* (
        (($part $tail) (decons-atom $parts))
        ($subparts (combinatorial_insert $main_head $part))
    ) 
       (insert  $subparts (mk-combinatorial_insert $main_head $tail))
))



;;!(is-present A ((A) (B C)))


(=(partitions ()) ())
(=(partitions $hs)(
    let* (
        (($head $tail) (decons-atom $hs))
        ($res (mk-combinatorial_insert $head (partitions $tail)))
         )
          $res
))

;;!(partitions ((Human $x)  (Parent $x)))
((((Human $x))) (((Human $x) (Parent $x))) (((Parent $x)) ((Human $x))))

(=(valid-partitions $hs ())())
(=(valid-partitions $hs $partitions) (
    let ($head $tail) (decons-atom $partitions) (
        if (not (let $res (collapse (is-valid $hs $head)) (car-atom $res))) (valid-partitions $hs $tail) (
            let $dummy (valid-partitions $hs $tail) (cons-atom $head $dummy)
        )
    )
))

;; !(valid-partitions ((Human $x) (Parent $x)) ((((Human $x))) (((Human $x) (Parent $x))) ((Parent $x) (Human $x))))



(=(partitions_without_pattern $clouses) (
    let  $prts (partitions $clouses) (valid-partitions $clouses $prts))
)




(=(mk-body ()) ())
(=(mk-body $block) (
    let ($head $tail) (decons-atom $block) (
        if (let $res (is-pattern $head) (car-atom $res)) 
           (if (== $tail ()) $head 
               (let $temp (mk-body $tail) (if (== $temp ()) $head (AND $head $temp)))) 
           (if (and (not (== $head ()))  (== $tail ())) (mk-body $head) 
               (let $res2 (mk-body $head) (mk-body ($res2 $tail)) ))
    ) 
))



(=(add-subpatterns () $space) ())
(=(add-subpatterns $partition $space)(
    let* ((($head $tail) (decons-atom $partition))
           ($subpattern (mk-body $head))
           ($dummy (add-subpatterns $tail $space))
            )
            (let () (add-atom $space (pattern $subpattern)) (cons-atom $subpattern $dummy))
))



;; base case
(=(get-clouses () ) ())
(= (get-clouses $pattern)
        (let* (
                (($head $tail) (decons-atom $pattern)))
            (if (== (get-metatype $head) Expression)
                (   let $result  (concatTuple ($head)
                    (get-clouses $tail)) (concatTuple $result (get-clouses $head)))
                    (get-clouses $tail))) )

;!(get-clouses (AND (Human $x) (Inheritance (Parent $x) Bob)))
;;!(partitions_without_pattern ((Human $x)  (Parent $x)))


! (add-reduct &self (= (temp-space) (new-space)))

(=(get-subpatterns $pattern $space) (
    let $parts (partitions_without_pattern (get-clouses $pattern))
         (add-subpatterns $parts $space )) )
    
 ;!(get-subpatterns (AND (Human $x) (Inheritance (Parent $x) Bob)) (temp-space))      














