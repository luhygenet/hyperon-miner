



;; Collection of functions operating on numbers

(: abs (-> $a $a))
(= (abs $x) (if (< $x 0) (* -1 $x) $x))

;; Define <=
(: <= (-> $a $a Bool))
(= (<= $x $y) (or (< $x $y) (== $x $y)))

;; Define >=
(: >= (-> $a $a Bool))
(= (>= $x $y) (or (> $x $y) (== $x $y)))
(: approxEq (-> $a $a $a Bool))
(= (approxEq $x $y $epsilon) (<= (abs (- $x $y)) $epsilon))



(=(beta_mean $alpha $beta) (
   let $result  (/ $alpha (+ $alpha $beta)) (mean $result)
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





;; Simple Truth Value.  A Second order probability TV constructor,
;; i.e. probability and confidence.  The probability is in fact the
;; mode of the corresponding beta distribution.
(: STV (-> Number Number TruthValue))

;;;;;;;;;;;;;;;
;; Constants ;;
;;;;;;;;;;;;;;;

;; For now the underlying beta distributions have a Jeffreys prior,
;; i.e. the prior alpha and beta are 0.5.
(: prior-alpha (-> Number))
(= (prior-alpha) 0.5)
(: prior-beta (-> Number))
(= (prior-beta) 0.5)

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
;; count = (confidence * lookahead) / (1 - confidence)
(: confidence->count (-> Number Number))
(= (confidence->count $conf) (if (approxEq 1.0 $conf 1e-9)
                                 (max-count)
                                 (/ (* $conf (lookahead)) (- 1.0 $conf))))




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
    $conf
))



(=(mk_distribution $Etv)(
    let*(
        ($tail (cdr-atom $Etv))
        ($tv (car-atom $tail))
        ($tv_mean (get_tv_mean $tv))
        ($tv_conf (get_tv_conf $tv))
        ($_count (collapse (confidence->count $tv_conf)))
        ($count (car-atom $_count))
        ($pos_count (* $tv_mean $count))
        ($alpha (+ (prior-alpha) $pos_count) )
        ($beta (+ (prior-beta) (- $count $pos_count ))) 
        ($_beta_dist (_beta_distribution $alpha $beta))

    )
        $_beta_dist
))