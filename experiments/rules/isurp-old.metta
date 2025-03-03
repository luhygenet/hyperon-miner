;;! (register-module! ../../../hyperon-miner)

;;! (register-module! ../../experiments)
;;! (import! &self experiments:rules:est-tv)
;;! (import! &self experiments:rules:emp-tv)

;! (import! &self hyperon-miner:experiments:utils:common-utils)
;;! (import! &self hyperon-miner:experiments:utils:TruthValue)
;;! (import! &self hyperon-miner:experiments:utils:gen_partition)


;;;;;;;;;;;;;;;;;;;;
;;High-Level Steps;;
;;;;;;;;;;;;;;;;;;;;
;; - Compute the probability of the pattern (pattern_prob).
;; - Generate all partitions excluding the pattern.
;; - Calculate the probabilities of all partitions (iprob).
;; - Identify the minimum and maximum probabilities (emin, emax) of the partitions.
;; - Compute the distance of pattern_prob from the interval [emin,emax]
;; - Normalize the distance if required.
;; - Bound the final surprisingness value to a maximum of 1.0



;;Calculates the total possible counts for a pattern based on database size 
;;and the number of conjunctive clauses in the pattern.
(=(total_counts $pattern $db) (pow (db_size $db) (n_conjuncts_new $pattern)))

;; Computes the product of a list of numbers recursively
(=(accumulator-x $num_list) (accumulator-x $num_list 1))
(=(accumulator-x $num_list $prev_value)  (
   if (== $num_list ()) $prev_value (let ($head $tail) (decons-atom $num_list) (accumulator-x $tail (* $head $prev_value)))
))

;;Determines the number of conjunctive clauses in a pattern.
(=(n_conjuncts_new $pattern) (
   let ($head $tail) (decons-atom $pattern) (
    if (== $head ,) (tuple-count $tail) 1)
))


;;Recursively calculates the support for each component of a 
;;conjunctive pattern by retrieving their support numbers (`sup-num`) from the database.

; (=(compute-component-support $cps $db)(
;   if (== $cps ()) () (
;     let* (  (($head $tail) (decons-atom $cps)) 
;             ($sup_num (sup-num $db $head) )
;             ($dummy (compute-component-support $tail $db))
;     )
;        (cons-atom $sup_num $dummy)
;     )
;   )
; ) 


;;; compute-component-support:
;;;   Calculates the support for components by first applying a superposition on the provided
;;;   component support list (cps) and then computing the numeric support value using the database (db).
;;;   The computation leverages the 'superpose' function to combine or aggregate component data,
;;;   and subsequently, the 'sup-num' function extracts the resulting numerical support from the database.

(=(compute-component-support $cps $db)
(collapse (sup-num $db (superpose $cps)) )
)



;; Calculate the support for each component of the conjunctive 
;; pattern and return the product of their results.
(=(ptrn-support $pattern $db)(
    let $cps (get-cnj-clouses $pattern) 
        (if (== $cps ()) 1 (accumulator-x (compute-component-support $cps $db)))
))

;; Function calculating the probability of a pattern
(=(prob $pattern $db) (/ (ptrn-support  $pattern $db) (total_counts $pattern $db)))

;;Converts a list of blocks into a conjunctive pattern
(=(add-pattern $blks $db) (
let* ( ($pattern (cons-atom , $blks)) ($dummy (add-atom $db $pattern))) $pattern
))
`

;;Calculates the probability of a block within a partition by first converting 
;;it into a pattern and then computing its probability.
(=(blk-prob $partition $db) (prob (add-pattern $partition $db) $db))


; ;; Recursively computes the probabilities of all blocks in a partition. 
; (=(p-blk-prob $partition $db) (
;     if (== $partition ()) () (let* ((($blk $tail) (decons-atom $partition))
;                                     ( $res (blk-prob $blk $db) )
;                                     ($dummy (p-blk-prob $tail $db))) 
;                                     (cons-atom $res $dummy))))


;; p-blk-prob computes the block probability for a given partition and database.
;;
;; It achieves this by applying the superpose function to the partition before
;; calculating the block probability using the blk-prob predicate.
;;
;; In other words, the relation p-blk-prob is defined to be equivalent to blk-prob
;; where the partition is first transformed by the superpose function.

(=(p-blk-prob $partition $db) 
   (collapse (blk-prob (superpose $partition) $db) )
)
                                


;;Estimates the probability of each partition under the assumption that blocks 
;;within a partition are independent. It multiplies the probabilities of individual blocks
; (=(iprob $prtns $db) (
;    if (== $prtns ()) ()  (let* ((($partition $tail) (decons-atom $prtns)) 
;                                  ($temp (accumulator-x (p-blk-prob $partition $db)))
;                                 ($dummy (iprob $tail $db))) 
;                                 (cons-atom $temp $dummy))
; ))


;; This rule computes the probability (iprob) for a given set of patterns ($prtns) within a specified database ($db).
;; 
;; It defines iprob by evaluating an accumulator (accumulator-x), which is set by calling the probability block function (p-blk-prob).
;; 
;; The probability block function takes as its input a composite structure (a superposition of patterns, $parns) and the database ($db).
;; 
;; In summary, the rule aggregates probabilistic outcomes by superposing patterns and then applying a probability block function.
(=(iprob $prtns $db) (
    
      (collapse accumulator-x (p-blk-prob (superpose $parns) $db))
                                
))



;; Computes the I-surprisingness of a pattern based on its probability, the 
;; minimum and maximum probabilities derived from independent partitions, and the 
;; distance of the pattern probability from this interval. Optionally, the surprisingness 
;; value can be normalized.
;(: isurp_old (-> Pattern db boolean Number))
(=(isurp_old $pattern $db $normalize) (
    let* (
        ($pattern_prob (prob $pattern $db ))
         (($emin $emax) (min-max (iprob (generet-partition-without-pattern $pattern) $db)))
         ($dst (dst_from_interval $emin $emax $pattern_prob))
    ) 
         (min ((if $normalize (/ $dst $pattern_prob) $dst) 1.0))
        
) )










