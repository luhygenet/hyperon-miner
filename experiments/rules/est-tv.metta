;;! (register-module! ../../../hyperon-miner)
;;! (import! &self hyperon-miner:experiments:utils:common-utils)







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
( = (get-subpatterns $pattern) 
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

(=(outer_temp $db $db_size $original $copy $i $count $prob) (
    if (> $count 1) (
          let* (
        ($tail (cdr-atom $copy))
        ($compJ (car-atom $tail))
        ($most_spec  (let $result (inner_temp $db $original $compJ $i) (find_max $result -1) ))
        ($M_xj (if (== $most_spec -1) $db_size $most_spec))
        ($prob_j (* $prob (/ 1 $M_xj)))  ;; from general formula
        ($dummy (outer_temp $db $db_size $original $tail (+ $i 1) (- $count 1) $prob_j))

    )
         $dummy
    )  $prob
   
))


;;A function that accepts space and pattern, and returns the estimated truth value between 0 and 1.
(= (est_tv $db $pattern)
(
        let* (
            ($db_size  (db_size $db))
            ($pattern_list (get-subpatterns $pattern))
            ($list_length (count-atom-element $pattern_list))
            ($est_tv (outer_temp $db $db_size $pattern_list $pattern_list 1 $list_length 1))
        ) 
         $est_tv
    )
)








