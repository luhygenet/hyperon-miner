;;! (register-module! ../../../hyperon-miner)
;;! (import! &self hyperon-miner:experiments:utils:common-utils)
;;! (import! &self hyperon-miner:experiments:utils:TruthValue)








;;Calculate the product of the probability over subpatterns
;;without considering joint variables
(=(pro_prob_without_joint $db $subpatterns )(
    let* (
        ($tv (emp_tv_mem $subpatterns $db))  
       ($prod_etv (avrg_tv $tv))
    )
     $prod_etv    
))


;;A function that calculates the set of values that Xi can take when its corresponding component is matched against the database alone,
;; without any interaction with the other components. The formula used to calculate this is the approximation formula: |V(Xi)| ~= Nth-root(S)

(=(estimate_v_xi $db $pattern_i) (
    let $result (sup-num $db $pattern_i) ((py-atom pow) $result 0.5)
))


;function to check if component A is more abstract to component B.
;;A function that determines if there is syntactic specialization between two components



;;A function to set the value of |V(Xi)| of the component_J with regard to components_i where i < j. 
;;It sets -1 if there is no abstraction or sets the value to estimate_v_xi.
(=(inner_temp $db $original $compJ $i $var) (
    if (== $i 0) () (
        let* (
             ( ($head $tail) (decons-atom $original))
             ($bool_value  (is_more_abstract_init $head $compJ)) ;; removed the is_equivalent function , it is not clear how it works
             ($v_xi  (if $bool_value (estimate_v_xi $db $head) -1))
             ($dummy (inner_temp $db $tail $compJ (- $i 1) $var))
        ) (
            cons-atom  $v_xi $dummy
        )
    )
))


;;A function that calculates the probability product for each pattern recursively, the General formula used here is :P(X1=...=Xn) = Prod_{j=2}^n 1/M(Xj)

(=(eq-prob $db $db_size $original $copy $i $count $var $prob) (
    if (> $count 1) (
          let* (($tail (cdr-atom $copy))
        ($compJ (car-atom $tail))
        ($most_spec  (let $result (inner_temp $db $original $compJ $i $var) (find_max $result -1) ))
       ($M_xj (if (<= $most_spec 0) $db_size $most_spec))
        ($prob_j (* $prob (// 1 $M_xj)))  ;; from general formula
        ($dummy (eq-prob $db $db_size $original $tail (+ $i 1) (- $count 1) $var $prob_j)))
         $dummy)
           $prob
           ))





(=(prob-with-joint $db $db_size $partion $joint_vars $p)(
    if (== $joint_vars ()) $p
 (let* ((($head $tail) (decons-atom $joint_vars))
       ($patterns (connected-subpatterns-with-var $partion $head))
       ($prob (eq-prob $db $db_size $patterns $patterns 1 (tuple-count $patterns)  $head $p))
        )
       (prob-with-joint $db $db_size $partion  $tail $prob)
        )   
))





;:TODO: suspect for change to non-deterministic 
 (= (ji-est-tv $db $db_size $pattern $partitions)
 (   if (== $partitions ()) () (
         let* (
             (($head $tail) (decons-atom $partitions))
                ($prod_etv (pro_prob_without_joint $db $head))
                (($rp $rc) (decons-atom $prod_etv))
               ($rp_est (prob-with-joint $db $db_size (remove-parenthesis $head) (joint-variables-init $pattern (remove-parenthesis $head)) 1))
              (($strength $confidence) ((* $rp $rp_est) (* 1e-1 (car-atom $rc))))
               ($dummy (ji-est-tv $db $db_size $pattern $tail))
               ) 

              (cons-atom (STV $strength $confidence)  $dummy) 
            
          ))
 )




;; This module implements a two-step estimation approach for computing TV estimates
;; based on joint probability assessments.
;;
;; The primary helper function, ji-est-tv-hlper, performs the following:
;; 1. Computes an initial production probability without considering joint dependencies
;;    using the pro_prob_without_joint function.
;; 2. Deconstructs the result into a primary probability component (rp) and additional details (rc).
;; 3. Calculates an adjusted probability (rp_est) that incorporates joint effects via the
;;    prob-with-joint function. This step modifies the partition and initializes joint variables
;;    based on a provided pattern.
;; 4. Combines the initial and adjusted probabilities to derive two metrics:
;;    - Strength: obtained by multiplying the primary probabilities (rp and rp_est).
;;    - Confidence: derived from scaling a component extracted from the additional details (rc),
;;      specifically, multiplying the first element by a factor of 1e-1.
;; 5. Packages these two metrics using the STV constructor.
;;
;; The wrapper function, ji-est-tv, aggregates multiple partitions using the superpose function
;; and then delegates to ji-est-tv-hlper to perform the TV estimation on the combined partition.
;;
;; This approach ensures that both individual and joint probability effects are considered
;; when estimating the TV values.
(= (ji-est-tv-hlper $db $db_size $pattern $partition) (let* (
        ($prod_etv (pro_prob_without_joint $db $partition))
        (($rp $rc) (decons-atom $prod_etv))
        ($rp_est (prob-with-joint $db $db_size (remove-parenthesis $partition) (joint-variables-init $pattern (remove-parenthesis $partition)) 1))
        (($strength $confidence) ((* $rp $rp_est) (* 1e-1 (car-atom $rc))))
)
(STV $strength $confidence)
))


;;(= (ji-est-tv-new $db $db_size $pattern $partitions) (collapse (ji-est-tv-hlper $db $db_size $pattern (superpose $partitions))))




;; Calculate the truth value estimate of each partition based on
;; independent assumption of between each partition block, taking
;; into account the linkage probability.

(=(do-ji-tv-est-dd $db $pattern) (
    let $prtns (generet-partition-without-pattern $pattern)  
          ( let ($strength $confidence) (avrg_tv (ji-est-tv $db (db_size $db) $pattern $prtns) )
          ($pattern  (STV $strength $confidence)))            
))

(=(do-ji-tv-est $db $pattern) (
    let $prtns (generet-partition-without-pattern $pattern)  
          (;; let ($strength $confidence) (avrg_tv (ji-est-tv $db (db_size $db) $pattern $prtns) )
          ;($pattern  (STV $strength $confidence))
          (ji-est-tv $db (db_size $db) $pattern $prtns)
          )            
))

























((AND (AND (Boy $y) (Or Bob $x)) (Human $x (Or Bob $x))))





;;(Beta (mean 54) (variance 57))
;!(get_beta_mean_var (Beta (mean 54) (variance 57)) var)
;!(+ (square 3.0) 3)
;!(var_accumulater ((Beta (mean 4) (variance 57)) (Beta (mean 6) (variance 57))) 0 5)
;!(avrg_tv ((Beta (mean 4) (variance 57)) (Beta (mean 6) (variance 57)) (Beta (mean 4) (variance 57))) )
