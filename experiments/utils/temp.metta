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

;; base case
(=(get-clouses () ) ())

(= (get-clouses $pattern)
        (let* (
                (($head $tail) (decons-atom $pattern)))
            (if (== (get-metatype $head) Expression)
                (   let $result  (concatTuple ($head)
                    (get-clouses $tail)) (concatTuple $result (get-clouses $head)))
                    (get-clouses $tail))) )


 ;; !(get-clouses  (Inheritance (Human $X (And $x $y)) (Inheritance $Y (Human $Z))))





;;(Inheritance Bob (And human (Or zac Mike)))

(=(push-back $atom ()) ($atom))
(=(push-back $atom $list) (
    let* (
        (($head $tail) (decons-atom $list))
        ($dummy (push-back $atom $tail))
    ) 
     (cons-atom $head $dummy)
))

(=(comp $main_head ()) ())
(=(comp $main_head $list)(
    let* (
        (($x $tail) (decons-atom $list))
        ($rst (push-back (push-back $main_head $x) (comp $main_head $tail)))   
    ) $rst
))

(=(combinatorial_insert $h ())((($h))))
(=(combinatorial_insert $h $seq)(
    let*(
        (($head $tail) (decons-atom $seq))
        ($reslut (combinatorial_insert $h $tail))
        ($comp_result (comp $head $reslut))    
    )
        (push-back (push-back (push-back $h $head) $tail) $comp_result)
))

(=(insert () $res) ($res))
(=(insert $subparts $res)(
      let ($head $tail) (decons-atom $subparts) (push-back $head (insert $tail $res))
))

(=(mk-combinatorial_insert $main_head ())(combinatorial_insert $main_head ()))
(=(mk-combinatorial_insert $main_head $parts)(
    let* (
        (($part $tail) (decons-atom $parts))
        ($subparts (combinatorial_insert $main_head $part))
    ) 
       (insert $subparts (mk-combinatorial_insert $main_head $tail))
))


(=(partitions ())())
(=(partitions $hs)(
    let* (
        (($head $tail) (decons-atom $hs))
        ($final_res (mk-combinatorial_insert $head (partitions $tail)))
         )
          $final_res 
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


(=(partitions_without_pattern $pattern) (
    let  $prts (partitions $pattern) (remove-element ((reverse-list $pattern)) $prts))
)


(=(is-symbol $var) 
   (== (get-metatype $link) Symbol)
)

(=(is-variable $var) 
   (== (get-metatype $link) Variable)
)

(=(is-expression $var) 
   (== (get-metatype $link) Expression)
)

(=(is-pattern $expr) (
 or (unify $expr ($link $x $y) (
       and (is-symbol $link) (
        and (or (is-variable $x) (is-expression $x))
             (or (is-variable $y) (is-expression $y)))) False)
    (unify $expr ($link $x) 
       (and (is-symbol $link) 
        (or (is-variable $x) 
            (is-expression $x))) False )  )
)


(=(mk-body ()) ())
(=(mk-body $block) (
    let ($head $tail) (decons-atom $block) (
        if (is-pattern $head) (
            AND $head (mk-body $tail)) 
            (mk-body $tail)
    ) 
))


!(mk-body ((C) (B A)))


;!(is-pattern (human (OR N D)))


;!(partitions_without_pattern (A B))
;!(partitions (A B))

!!(if (is-pattern (a $x)) yes no)

((((((A))) 
((C) (B A))     ..... (AND C (AND B A))
((A) (C) (B))
 ((C A) (B))) 
 ((C B A)) 
 ((A) (C B))) 

 (((B) A)) ((A) ((B))))

((((A))) ((B A)) ((A) (B)))



