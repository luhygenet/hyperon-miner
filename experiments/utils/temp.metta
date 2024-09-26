! (register-module! ../../experiments)
! (import! &self experiments:rules:emp-tv)
! (import! &self experiments:rules:est-tv)
! (register-module! ../../../hyperon-miner)
! (import! &database hyperon-miner:experiments:data:sample-data)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (import! &self hyperon-miner:experiments:utils:TruthValue)




! (add-reduct &self (= (get-space) (new-space)))
! (add-atom (get-space) (Inheritance Abe human))
! (add-atom (get-space) (Inheritance Rio human))
! (add-atom (get-space) (Inheritance Bob human))
! (add-atom (get-space) (Inheritance Mike human))
! (add-atom (get-space) (Inheritance Zac human))
! (add-atom (get-space) (Inheritance Zac human))
! (add-atom (get-space) (Parent Abe Nil ))

;! (emp-tv (Inheritance $x human) (get-space))





                
;;!(confidence->count 1.02)

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

;!(get_tv_conf (STV 12 34))


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

;;!(beta_mean 2 5)

(=(_beta_distribution $alpha $beta)(
     let*(
        ($beta_mean (beta_mean $alpha $beta))
        ($beta_variance (beta_var $alpha $beta))
     )

     (Beta $beta_mean $beta_variance)
))


;;!(_beta_distribution 2 5)

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

;;!(confidence->count 1.2)


;!(mk_distribution ((Inheritance Abe human)(ETV 1.0 0.05)))

;; accept pattern and $db return list of patterns with  thier empirical truth value
 ;! (get-subpatterns (,(Inheritance Abe human) (Inheritance Rio human) (Inheritance Bob human)))

 (=(eq_prob $pattern_list $db) (
    if (== $pattern_list ()) () (
        let* (
              
              ($head (car-atom $pattern_list))
              ($tail (cdr-atom $pattern_list))
             ; ($emp_value (emp-tv $head $db))
              ($set_emp ($head (EMPTV 1.0 0.05)))
              ($dummy (eq_prob $tail $db))
        )
            
            (cons-atom $set_emp $dummy)
    )
 ))

;;!(eq_prob ((Inheritance Abe human) (Inheritance Rio human) (Inheritance Bob human)) (get-space))

;!((py-atom absolute) -4)
;;!(mk_beta 1.2 1.0)
