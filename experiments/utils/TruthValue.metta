



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