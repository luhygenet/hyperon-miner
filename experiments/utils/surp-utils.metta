

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




