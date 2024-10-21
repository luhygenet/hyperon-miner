;;! (register-module! ../../../hyperon-miner)
;;! (import! &self hyperon-miner:experiments:utils:common-utils)
;;! (import! &self hyperon-miner:experiments:utils:TruthValue)







;;define function which lists the each pattern in the pattern list
(=(list-patterns $x) (  
    if (== $x ()) () (  
      let* (
            ($head (car-atom $x))
            ($tail (cdr-atom $x))
            ($tail_new (superpose(list-patterns $tail))))   
        (cons-atom $head $tail_new ) 
    ))
)

;define function which extract subpatterns or blocks from the given nested pattern
( = (get-subpatterns-old $pattern) 
    (if (== , (car-atom $pattern)) (
         let $result  (list-patterns (cdr-atom $pattern)) $result
    )  $pattern   
) )

;Return variables in the pattern, later used to check the joint variable.
(=(get-variable ($link $var1 $var2)) (
    if (== $var1 $var2) $var1 ($var1 $var2)
))


(=(find_max $num_list $max) (
    if (== $num_list ()) $max (
        let* (
            ($head (car-atom $num_list))
            ($tail (cdr-atom $num_list))
            ($max_i (if (> $head $max) $head $max))
            ($dummy (find_max $tail $max_i))
        ) 
            $dummy  
    )
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
        let* (
            ($head (car-atom $patten_list))
            ($tail (cdr-atom $patten_list))
            ($beta_dist (mk_distribution $head))
            ($dummy (mk_distribution_list $tail))
        )
              (cons-atom $beta_dist $dummy)
           
    )
))

;;!(confidence->count 1.2)


;!(mk_distribution ((Inheritance Abe human)(ETV 1.0 0.05)))

;; accept pattern and $db return list of patterns with  thier empirical truth value
 ;! (get-subpatterns (,(Inheritance Abe human) (Inheritance Rio human) (Inheritance Bob human)))

;;Calculate the product of the probability over subpatterns
;;without considering joint variables
 (=(emp_tv_mem $pattern_list $db) (
    if (== $pattern_list ()) () (
        let* (  
              ($head (car-atom $pattern_list))
              ($tail (cdr-atom $pattern_list))
             ; ($emp_value (emp-tv $head $db))
              ($set_emp ($head (EMPTV 1.0 0.05)))
              ($dummy (emp_tv_mem $tail $db))
        )  
            (cons-atom $set_emp $dummy)
    )
 ))


(Beta (mean 54) (variance 57))

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

;!(get_beta_mean_var (Beta (mean 54) (variance 57)) var)




;!(+ (square 3.0) 3)



;!(var_accumulater ((Beta (mean 4) (variance 57)) (Beta (mean 6) (variance 57))) 0 5)


(=(avrg_tv $tv)(
    let* (
        ($tv_list (mk_distribution_list $tv))
        ($size (count-atom-element $tv_list))
       ($mean (let $sum (mean_accumulater $tv_list 0) (/ $sum $size)))
       ($re_variance (let $var_sum  (var_accumulater $tv_list 0 $mean) (/ $var_sum $size)))
        ($mk_stv_val (mk_stv $mean $re_variance))
        ($mode (car-atom $mk_stv_val))
        ($temp (cdr-atom $mk_stv_val))
        ($confidence (car-atom $temp))
    )
        ($mode $confidence)     
))




;!(avrg_tv ((Beta (mean 4) (variance 57)) (Beta (mean 6) (variance 57)) (Beta (mean 4) (variance 57))) )


(=(prod-etv $db $patten_list )(
    let* (
        ($tv (emp_tv_mem $patten_list $db))  
        ($prod_etv (avrg_tv $tv))
    )
        $prod_etv
))


;;A function that calculates the set of values that Xi can take when its corresponding component is matched against the database alone,
;; without any interaction with the other components. The formula used to calculate this is the approximation formula: |V(Xi)| ~= Nth-root(S)

(=(estimate_v_xi $db $pattern_i) (
    let $result (sup-num $db $pattern) ((py-atom pow) $result 0.5)
))


;function to check if component A is more abstract to component B.
;;A function that determines if there is syntactic specialization between two components
(=(is_more_abstract ($link1 $x1 $y1) ($link2 $x2 $y2)) (
    if(== $link1 $link2)
     ( if (or (== $x1 $x2) (== $y1 $y2)) 
      True
      False) 
      False      
))

;;A function to set the value of |V(Xi)| of the component_J with regard to components_i where i < j. 
;;It sets -1 if there is no abstraction or sets the value to estimate_v_xi.
(=(inner_temp $db $original $compJ $i) (
    if (== $i 0) () (
        let* (
             ($head (car-atom $original))
             ($tail (cdr-atom $original))
             ($bool_value  (is_more_abstract $head $compJ)) 
             ($v_xi  (if $bool_value (estimate_v_xi $db $head) -1))
             ($dummy (inner_temp $db $tail $compJ (- $i 1)))
        ) (
            cons-atom $v_xi $dummy
        )
    )
))


;;A function that calculates the probability product for each pattern recursively, the General formula used here is :P(X1=...=Xn) = Prod_{j=2}^n 1/M(Xj)

(=(eq-prob $db $db_size $original $copy $i $count $prob) (
    if (> $count 1) (
          let* (
        ($tail (cdr-atom $copy))
        ($compJ (car-atom $tail))
        ($most_spec  (let $result (inner_temp $db $original $compJ $i) (find_max $result -1) ))
        ($M_xj (if (== $most_spec -1) $db_size $most_spec))
        ($prob_j (* $prob (/ 1 $M_xj)))  ;; from general formula
        ($dummy (eq-prob $db $db_size $original $tail (+ $i 1) (- $count 1) $prob_j))
    )
         $dummy
    )  $prob
   
))


;; Calculate the truth value estimate of each partition based on
;; independent assumption of between each partition block, taking
;; into account the linkage probability.
(= (ji-est-tv $db $pattern)
(
        let* (
            ($db_size  (db_size $db))
            ($pattern_list (get-subpatterns $pattern))
            ($list_length (count-atom-element $pattern_list))
            ($prob_value (prod-etv $db $pattern_list))
            ($rp (car-atom $prob_value))
            ($temp_rc (cdr-atom $prob_value))
            ($rc (car-atom $prob_value))
            ($rp_est (eq-prob $db $db_size $pattern_list $pattern_list 1 $list_length 1))
            ($strength (* $rp $rp_est))
            ($confidence (* 1e-1 $rc))
        ) 
          (STV $strength $confidence)
    )
)










