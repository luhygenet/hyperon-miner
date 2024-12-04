;;! (register-module! ../../../hyperon-miner)

;;! (register-module! ../../experiments)
;;! (import! &self experiments:rules:est-tv)
;;! (import! &self experiments:rules:emp-tv)

;! (import! &self hyperon-miner:experiments:utils:common-utils)
;;! (import! &self hyperon-miner:experiments:utils:TruthValue)
;;! (import! &self hyperon-miner:experiments:utils:gen_partition)





(=(total_counts $pattern $db) (pow (db_size $db) (n_conjuncts_new $pattern)))

;; return the product of list of numbers
(=(accumulator-x $num_list) (accumulator-x $num_list 1))
(=(accumulator-x $num_list $prev_value)  (
   if (== $num_list ()) $prev_value (let ($head $tail) (decons-atom $num_list) (accumulator-x $tail (* $head $prev_value)))
))


(=(n_conjuncts_new $pattern) (
   let ($head $tail) (decons-atom $pattern) (
    if (== $head ,) (tuple-count $tail) 1)
))


(=(compute-component-support $cps $db)(
  if (== $cps ()) () (
    let* (  (($head $tail) (decons-atom $cps)) 
            ($sup_num (sup-num $db $head) )
            ($dummy (compute-component-support $tail $db))
    )
       (cons-atom $sup_num $dummy)
    )
  )
) 

;; Calculate the support for each component of the conjunctive 
;; pattern and return the product of their results.
(=(ptrn-support $pattern $db)(
    let $cps (get-cnj-clouses $pattern) 
        (if (== $cps ()) 1 (accumulator-x (compute-component-support $cps $db)))
))

;; Function calculating the probability of a pattern
(=(prob $pattern $db) (/ (ptrn-support  $pattern $db) (total_counts $pattern $db)))

;; convert list of patterns of the blk to conjuct pattern 
;; by adding "," in front of tuples of the blk
(=(add-pattern $blks $db) (
let* ( ($pattern (cons-atom , $blks)) ($dummy (add-atom $db $pattern))) $pattern
))
`

;; Calculate the probability of each block of the partition
(=(blk-prob $partition $db) (prob (add-pattern $partition $db) $db))

;; Calculate the probability of each partition 
(=(p-blk-prob $partition $db) (
    if (== $partition ()) () (let* ((($blk $tail) (decons-atom $partition))
                                    ( $res (blk-prob $blk $db) )
                                    ($dummy (p-blk-prob $tail $db))) 
                                    (cons-atom $res $dummy))))


;;Calculate the probability estimate of each partition based on
;;independent assumption of between each partition block.
(=(iprob $prtns $db) (
   if (== $prtns ()) ()  (let* ((($partition $tail) (decons-atom $prtns)) 
                                 ($temp (accumulator-x (p-blk-prob $partition $db)))
                                ($dummy (iprob $tail $db))) (cons-atom $temp $dummy))
))


;; calculate  I-surprisingness of the pattern without takes 
;; into account the joint variables.
(: isurp_old (-> Pattern db Number))
(=(isurp_old $pattern $db $normalize) (
    let* (
        ($pattern_prob (prob $pattern $db ))
         (($emin $emax) (min-max (iprob (generet-partition-without-pattern $pattern) $db)))
         ($dst (dst_from_interval $emin $emax $pattern_prob))
    ) 
         (min ((if $normalize (/ $dst $pattern_prob) $dst) 1.0))
        
) )










