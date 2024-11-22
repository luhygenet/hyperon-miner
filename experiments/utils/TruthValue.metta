;; Simple Truth Value.  A Second order probability TV constructor,
;; i.e. probability and confidence.  The probability is in fact the
;; mode of the corresponding beta distribution.
(: STV (-> Number Number TruthValue))


;;;;;;;;;;;;;;;
;; Constants ;;
;;;;;;;;;;;;;;;

;; For now the underlying beta distributions have a Jeffreys prior,
(: prior-alpha (-> Number))
(= (prior-alpha) 1.0)

(: prior-beta (-> Number))
(= (prior-beta) 1.0)

;; Default K value , as sated on "openCog/atomps/simpleTruthValue.h"
(: default_k (-> Number))
(= (default_k) 800.0)

;; Lookahead
(: lookahead (-> Number))
(= (lookahead) 1.0)


;; Maximum supported count (till +inf is supported, possibly).
(: max-count (-> Number))
(= (max-count) 1e9)


;;;;;;;;;;;;;
;; Methods ;;
;;;;;;;;;;;;;

;; Convert count to confidence using the formula
;;
;; confidence = count / (count + lookahead)
(: count->confidence (-> Number Number))
(= (count->confidence $cnt) (/ $cnt (+ $cnt (lookahead))))

;; Convert confidence to count using the formula
;;
;; count = (confidence * default_k) / (1 - confidence)
(: confidence->count (-> Number Number))
;;(= (confidence->count $conf) (if (approxEq 1.0 $conf 1e-9)(max-count)(/ (* $conf (lookahead)) (- 1.0 $conf))))

(=(confidence->count $conf) (
    let* (
       ( $cf (min $conf 0.9999998))
       ( $count (/ (* (default_k) $cf) (- 1.0 $cf)))

    )
      $count
))




;;;;;;;;;;;;;;;;;;
;; Common Utils ;;
;;;;;;;;;;;;;;;;;;

(= (decons-atom $exp)
    ((car-atom $exp) (cdr-atom $tail))
)

(= (concatTuple $xs $ys)
    (if (== $xs ())
        $ys
        (let* ( (($head $tail) (decons-atom $xs))
                ($tailNew (concatTuple $tail $ys)))
                 (cons-atom $head $tailNew))  ))

(=(remove-parenthesis $x) (
    let ($head $tail) (decons-atom $x) (if (== $tail ()) (remove-parenthesis $head) $x)
))


(= (get-variables $pattern)
    (if (== $pattern ())
        ()
        (let* (
                ($head (car-atom $pattern))
                ($tail (cdr-atom $pattern)))

            (if (== (get-metatype $head) Expression)
                (concatTuple (get-variables $head)
                    (get-variables $tail))
                (if (== (get-metatype $head) Variable)
                    (concatTuple
                        ($head)
                        (get-variables $tail))

                    (get-variables $tail))))
    )
)


(=(is-symbol $var) 
   (== (get-metatype $var) Symbol)
)

(=(is-variable $var) 
   (== (get-metatype $var) Variable)
)

(=(is-expression $var) 
  (== (get-metatype $var) Expression)
)

(=(reverse-list ()) ())
(=(reverse-list $subparts)(
      let ($head $tail) (decons-atom $subparts) (push-back $head (reverse-list $tail))
))


(=(remove-element $element ())())
(=(remove-element $element $list) (
    let ($head $tail) (decons-atom $list) (
        if (== $element $head) (remove-element $element $tail) (
            let $dummy (remove-element $element $tail) (cons-atom $head $dummy)))))



(=(append-list $atom ()) ($atom))
(=(append-list $atom $list) (
    let* (
        (($head $tail) (decons-atom $list))
        ($dummy (append-list $head $tail))
    ) 
     (cons-atom $atom $dummy)))


(=(append-list-v2 $atom ()) ($atom))
(=(append-list-v2 $atom $list) (
    let* (
        (($head $tail) (decons-atom $list))
        ($dummy ((append-list $head $tail)))
    ) 
     (cons-atom $atom $dummy)))


(=(push-back $atom ()) ($atom))
(=(push-back $atom $list) (
    let* ((($head $tail) (decons-atom $list))
        ($dummy (push-back $atom $tail))) 
     (cons-atom $head $dummy)))


(=(insert () $res) $res)
(=(insert $subparts $res)(
      let ($head $tail) (decons-atom $subparts) (let $temp (push-back $head $res) (insert $tail $temp))))

(=(is-present $atom ()) False)
(=(is-present $atom $list) (
    if (is-expression $list) (
    let ($head $tail) (decons-atom $list) (
        if (== $atom $head) True  (or (is-present $atom $head) (is-present $atom $tail))
    )) (if (== $atom $head) True False)))


(=(is-pattern $expr) (
    collapse(
 or (unify $expr ($link $x $y) (
       and (is-symbol $link) (
        or (or (is-variable $x) (is-expression $x))
             (or (is-variable $y) (is-expression $y)))) False)
    (unify $expr ($link $x) 
       (and (is-symbol $link) 
        (or (is-variable $x) 
            (is-expression $x))) False )  )))

(=(is-valid () $partion) True)
(=(is-valid $clous $partion)(
    let ($head $tail) (decons-atom $clous)  (and (is-present $head $partion) (is-valid $tail $partion)) ))            

(=(comp $main_head ()) ())
(=(comp $main_head $list)(
    let* (
        (($x $tail) (decons-atom $list))
        ($rst (append-list (append-list $main_head  $x) (comp  $main_head $tail)))   
    ) $rst))


(=(get-clouses () ) ())
(= (get-clouses $pattern)
        (let* (
                (($head $tail) (decons-atom $pattern)))
            (if (== (get-metatype $head) Expression)
                (   let $result  (concatTuple ($head)
                    (get-clouses $tail)) (concatTuple $result (get-clouses $head)))
                    (get-clouses $tail))) )


(=(list-patterns $x) (  
    if (== $x ()) () (  
      let* (
            ($head (car-atom $x))
            ($tail (cdr-atom $x))
            ($tail_new (superpose(list-patterns $tail))))   
        (cons-atom $head $tail_new ) )))


(=(find_max $num_list $max) (
    if (== $num_list ()) $max (
        let* ((($head $tail)(decons-atom $num_list))
            ($dummy (find_max $tail (if (> $head $max) $head $max)))) 
            $dummy  )))

(=(max $list) (find_max $list (car-atom $list)))

(=(find_min $num_list $min) (
    if (== $num_list ()) $min (
        let* ((($head $tail)(decons-atom $num_list))
            ($dummy (find_min $tail (if (< $head $min) $head $min)))) 
            $dummy  )))


(=(min $list) (find_min $list (car-atom $list)))

(=(get-cnj-clouses $pattern) (
  let ($head $tail) (decons-atom $pattern)  (if (== $head ,) $tail ())
))


(=(min-max $list) ((min $list) (max $list)))



;;;;;;;;;;;;;;;;;
;; Miner Utils ;;
;;;;;;;;;;;;;;;;;


(=(combinatorial_insert $h ())((($h))))
(=(combinatorial_insert $h $seq)(
    let*((($head $tail) (decons-atom $seq))
        ($reslut (combinatorial_insert $h $tail))
        ($comp_result (comp $head $reslut))  )
       (append-list (append-list (append-list $h $head) $tail) $comp_result)))


;!(combinatorial_insert (Bob $x) ((Human $x) (Parent $x)))
;!(combinatorial_insert D ((A) (B) (C)))


(=(mk-combinatorial_insert $main_head ())(combinatorial_insert $main_head ()))
(=(mk-combinatorial_insert $main_head $parts)(
    let* (
        (($part $tail) (decons-atom $parts))
        ($subparts (combinatorial_insert $main_head $part))) 
       (insert  $subparts (mk-combinatorial_insert $main_head $tail))))


(=(partitions ()) ())
(=(partitions $hs)(
    let* (
        (($head $tail) (decons-atom $hs))
        ($res (mk-combinatorial_insert $head (partitions $tail))))
          $res))

(=(is-partions-clouse $part $clauses) (
    let $res (collapse (is-present $part $clauses)) (or (car-atom $res) (== $part $clauses))
))

(=(valid-partitions $hs ())())
(=(valid-partitions $hs $partitions) (
    let ($head $tail) (decons-atom $partitions) (
        if (and (let $res (collapse (is-valid $hs $head)) (car-atom $res)) (not  (is-partions-clouse (remove-parenthesis $head) $hs) ))  
        (let $dummy (valid-partitions $hs $tail) (cons-atom (remove-parenthesis $head) $dummy))
            (valid-partitions $hs $tail))))




(=(partitions_without_pattern $clouses) (
    let  $prts (partitions $clouses) (valid-partitions $clouses $prts)))


(=(mk-body ()) ())
(=(mk-body $block) (
    let ($head $tail) (decons-atom $block) (
        if (let $res (is-pattern $head) (car-atom $res)) 
           (if (== $tail ()) $head 
               (let $temp (mk-body $tail) (if (== $temp ()) $head (, $head $temp)))) 
           (if (and (not (== $head ()))  (== $tail ())) (mk-body $head) 
               (let $res2 (mk-body $head) (mk-body ($res2 $tail)) ))
    ) 
))


(=(connected-subpatterns-with-var () $var) ())
(=(connected-subpatterns-with-var $partion $var)(
    let* (
        (($head $tail) (decons-atom $partion) )
       ($is_pattern (let $pat_temp  (is-pattern $head) (car-atom $pat_temp)))
        ($is_connected (let $temp (collapse (is-present $var $head)) (car-atom $temp))))

        (  if  (and $is_pattern $is_connected)
               (let $dummy (connected-subpatterns-with-var $tail $var ) (cons-atom $head $dummy)) 
                (if $is_pattern (connected-subpatterns-with-var $tail $var) (concatTuple  (connected-subpatterns-with-var $head $var) (connected-subpatterns-with-var $tail $var)) ))))



(= (is_more_abstract_est ($link1 $x1 $y1) ($link2 $x2 $y2))
    (if (== $link1 $link2)
        (if
            (and
                (or
                     ; Check if x1 and x2 are equal, or x1 is more abstract (a variable)
                    (== $x1 $x2)
                    (and
                        (is-variable $x1) (or (is-expression $x2) (is-symbol $x2))))
                (or
                     ; Check if y1 and y2 are equal, or y1 is more abstract (a variable)
                    (== $y1 $y2)
                    (and
                        (is-variable $y1) (or (is-expression $y2) (is-symbol $y2)))))
            True
            False )
        False
    )
)


(=(is_more_abstract_init $x $y) (
   if (and ( let $res (unify $x ($link $z $w) True False) $res) (let $res2 (unify $y ($link $a $b) True False) $res2) )
       (is_more_abstract_est $x $y)
       False
))



;;;;;;;;;;;;;;;;;;;;
;; Surprisingness ;;
;;;;;;;;;;;;;;;;;;;;


(=(add-subpatterns () $space) ())
(=(add-subpatterns $partition $space)(
    let* ((($head $tail) (decons-atom $partition))
           ($subpattern (mk-body $head))
           ($dummy (add-subpatterns $tail $space))
            )
            (cons-atom $subpattern $dummy)
))


(=(get-subpatterns $pattern $space) (
    let $parts (partitions_without_pattern (get-clouses $pattern))
         (add-subpatterns $parts $space )) )


(=(var-appers $var ()) ())
(=(var-appers $var $blk) (
     let* ((($head $tail) (decons-atom $blk))
           ($is_present (let $temp (collapse (is-present $var $head)) (car-atom $temp))))
           (if $is_present  (let $dummy (var-appers $var $tail) (cons-atom $var $dummy)) (var-appers $var $tail))))


(=(joint-variables () $partion) ())
(=(joint-variables $vars  $partion )(
    let ($head $tail)    (decons-atom $vars)
       (if   (>= (tuple-count (var-appers $head $partion)) 2) 
             (let $dummy (joint-variables $tail $partion) (cons-atom $head $dummy)) 
             (joint-variables $tail $partion))         
))

(=(mk-unique ()) ())
(=(mk-unique $vars) (
    let ($head $tail) (decons-atom $vars) (let $dummy (mk-unique (remove-element $head $vars)) (cons-atom $head $dummy))))

(=(get-unique-vars $pattern)(
    let $vars (get-variables $pattern) (mk-unique $vars) 
))


(=(joint-variables-init $pattern $partion)(
      let $vars (get-unique-vars $pattern) (
        joint-variables $vars $partion   
      )
))


 (=(emp_tv_mem $pattern_list $db) (
    if (== $pattern_list ()) () (
        let* (  
              (($head $tail) (decons-atom $pattern_list))
             ;($emp_value (emp-tv $head $db))
              ($set_emp ($head (EMPTV 0.8 0.45)))
              ($dummy (emp_tv_mem $tail $db))
        )  
            (cons-atom $set_emp $dummy)
    )
 ))



(=(avrg_tv $tv)(
    let* (
        ($tv_list (mk_distribution_list $tv))
        ($size (tuple-count $tv_list))
        ($mean (let $sum (mean_accumulater $tv_list 0) (/ $sum $size)))
        ($re_variance (let $var_sum  (var_accumulater $tv_list 0 $mean) (/ $var_sum $size)))
        ($mk_stv_val (mk_stv $mean $re_variance))
        (($mode $confidence)  (decons-atom $mk_stv_val))
    )
     ($mode (car-atom $confidence) ) 
       
))



(=(is_equivalent ($link1 $x1 $y1) ($link2 $x2 $y2) $var) (
    if (== $link1 $link2) (or (and (== $x1 $x2) (== $x2 $var)) (and (== $y1 $y2) (== $y2 $var))) False ) 
)

(=(is_equivalent ($link1 $x1) ($link2 $x2) $var) (
  if (== $link1 $link2) (and (== $x1 $x2) (== $x2 $var)) False
))

(=(dst_from_interval $emin $emax $emp) (
  if (< $emax $emp) (- $emp $emax) (if (< $emp $emin ) (- $emin $emp) 0.0)
))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Beta distributions from URE ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(=(beta_mean $alpha $beta) (
   let $result  (/ $alpha (+ $alpha $beta)) (mean $result)
))

(:min (-> Number Number Number))
(=(min $num1 $num2)(
    if (< $num1 $num2) $num1 $num2
))



;;The variance of a Beta distribution is given by the formula:
;;Variance = α * β / ((α + β)^2 * (α + β + 1))
;; where α and β are the shape parameters of the Beta distribution.

(=(beta_var $alpha $beta) (
    let* (
        ($a (* $alpha $beta))
        ($b (* (+ $alpha $beta) (+ $alpha $beta)))
        ($c (+ $alpha (+ $beta 1) ))
        ($var (/ $a (* $b $c)))

    )
        (variance $var)
))


(=(mean_accumulater $tv_list $pre_value)(
   if (== $tv_list ()) $pre_value (
       let* (
           ($head (car-atom $tv_list));;(Beta (mean 54) (variance 57))
           ($tail (cdr-atom $tv_list))
           ($mean_value (get_beta_mean_var $head mean)) ;; 54
           ($accumulate (+ $mean_value $pre_value))
           ($dummy (mean_accumulater $tail $accumulate))
       )
            $dummy
   )
))


(=(var_accumulater $tv_list $pre_value $mean)(
    if (== $tv_list ()) $pre_value (
        let* (
            ($head (car-atom $tv_list));;(Beta (mean 54) (variance 57))
           ($tail (cdr-atom $tv_list))
           ($mean_value_i (get_beta_mean_var $head mean))
           ($variance (get_beta_mean_var $head var))
           ($diff (- $mean_value_i $mean))
           ($relative_var (+ $variance (* $diff $diff)))
           ($rel_var_sum (+ $relative_var $pre_value))
           ($dummy (var_accumulater $tail $rel_var_sum $mean))
        )
           $dummy
    )
))


(=(get_tv_mean $tv) (
    let*(
        ($tail (cdr-atom $tv))
        ($mean (car-atom $tail))
    )
    $mean
))

(=(get_tv_conf $tv) (
    let*(
        ($tail (cdr-atom $tv))
        ($temp (cdr-atom $tail))
        ($conf (car-atom $temp))
    )
    $conf))


(= (find_alpha $mean $variance) (
    * $mean (- (/ (* $mean (- 1 $mean) ) $variance) 1)
))

(= (find_beta $mean $variance) (
    * (- 1 $mean) (- ( / (* $mean (- 1 $mean)) $variance) 1)
))


;;(: mk_stv (-> ))
(=(mk_stv $mean $variance) (
   let* (
     ($alpha (find_alpha $mean $variance))
     ($beta (find_beta $mean $variance))
     ($count (+ $alpha (- $beta (- (prior-alpha) (prior-beta)))))
     ($confidence (/ $count (+ $count (default_k))))
     ($mode  (
    if (and (> $alpha 1) (> $beta 1)) (
                / (- $alpha 1) (+ $alpha (- $beta 2))   ;; a-1 / a + b -2
    ) (
        if (and (<= $alpha 1) (> $beta 1)) 0 (

            if (and (< $alpha 1) (== $beta 1)) 1 
            (
                if (and (< $alpha 1) (< $beta 1)) $mean 1
            )
        )
    ))))

    ($mode $confidence)
   
))

(=(mk_distribution $Etv)(
    let*(
        ($tail (cdr-atom $Etv))
        ($tv (car-atom $tail))
        ($tv_mean (get_tv_mean $tv))
        ($tv_conf (get_tv_conf $tv))
        ($count (confidence->count $tv_conf))
        ($pos_count (* $tv_mean $count))
        ($alpha (+ (prior-alpha) $pos_count) )
        ($beta (+ (prior-beta) (- $count $pos_count ))) 
        ($_beta_dist (_beta_distribution $alpha $beta))

    )
        $_beta_dist
))


(=(_beta_distribution $alpha $beta)(
     let*(
        ($beta_mean (beta_mean $alpha $beta))
        ($beta_variance (beta_var $alpha $beta))
     )
     (Beta $beta_mean $beta_variance)
))


;;!(_beta_distribution 2 5)
(=(mk_distribution_list $patten_list)(
    if (== $patten_list ()) () (
        let*(( ($head $tail)(decons-atom $patten_list))
            ($beta_dist (mk_distribution $head))
            ($dummy (mk_distribution_list $tail))
        )
              (cons-atom $beta_dist $dummy))
))

(=(get_beta_mean_var $beta $key)(
    let* (
           ($temp (cdr-atom $beta));;((mean 54) (variance 57))
           ($mean_tuple (car-atom $temp));; (mean 54)
           ($mean_temp (cdr-atom $mean_tuple)) ;; (54)
           ($mean_value (car-atom $mean_temp)) ;; 54
           ($temp2  (cdr-atom $temp));;((variance 57))
           ($var_tuple (car-atom $temp2 ));; (variance 57)
           ($var_temp (cdr-atom $var_tuple));; (57)
           ($variance (car-atom $var_temp)) ;; 57    
    )
      (
        if (== $key mean) $mean_value $variance
      )
      
))