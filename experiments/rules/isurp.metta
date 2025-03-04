;;! (register-module! ../../experiments)
;;! (import! &self experiments:utils:common-utils)
;;! (import! &self experiments:utils:beta-dist)
;;! (import! &self experiments:utils:constants)
;;! (import! &self experiments:utils:TruthValue)
;;! (import! &self experiments:utils:surp-utils)
;;! (import! &self experiments:utils:miner-utils)
;;! (import! &self experiments:utils:gen_partition)
;;! (import! &self experiments:rules:est-tv)
;;! (import! &self experiments:rules:emp-tv)
;;! (import! &self experiments:rules:emp-prob-pbs)



;; Calculate the empirical probability of pattern, using
;; boostrapping if necessary
(=(emp_prob_pbs_mem $subpattern $db  $db_ratio) )


;; Calculate the product of the probability over subpatterns
;; without considering joint variables
(=(pro-prob-wout-joint $subpatterns $db $db_ratio $p) (
  if (== $subpatterns ()) $p (
    let* ((($subpattern $tail) (decons-atom $subpatterns))
           ($empr (emp-prob-pbs  (remove-parenthesis $subpattern) $db  $db_ratio))
           ($new_prob (* $p $empr)))
       (pro-prob-wout-joint $tail $db $db_ratio $new_prob)
  )
))


;; Calculate probability estimate of a pattern given a partition,
;; assuming all blocks are independent, but takes into account the
;; joint variables (ji_prob_est stands for joint-independent
;; probability estimate).
(=(ji-prob-est $partition $pattern $db $db_ratio) (
     let $p (pro-prob-wout-joint $partition $db $db_ratio 1)
             (let $eq_prob (prob-with-joint $db (db_size $db) (remove-parenthesis $partition) (joint-variables-init $pattern (remove-parenthesis $partition)) 1)  
             (* $p $eq_prob)))
             )




; (=(do-ji-prob $partitions $pattern $db $db_ratio) (
;   if (== $partitions ()) () (
;      let* ((($partition $tail) (decons-atom $partitions))
;             ($jip (ji-prob-est $partition $pattern $db $db_ratio))
;              ($dummy (do-ji-prob $tail $pattern $db $db_ratio)))
;              (cons-atom $jip $dummy) ))
; )


;; Previous Implementation: ^
;; - Utilizes explicit recursion to operate over the list of partitions.
;; - Decomposes the partitions list using a deconstructing approach (decons-atom).
;; - For each partition, it computes the probability estimate using ji-prob-est.
;; - Recursively processes the remaining partitions until an empty list is reached.
;; - This method leverages conditional checks and explicit recursion, which can lead to deeper call stacks.
;;
;; New Implementation: v
;; - Avoids explicit recursion by exploiting metta's non-deterministic properties.
;; - Uses the 'superpose' function to combine results directly from all partitions.
;; - Applies 'collapse' to aggregate the result of ji-prob-est computed on the combined partitions.
;; - This approach is more concise and potentially more efficient as it abstracts the iteration over partitions.
;;
;; Overall Comparison:
;; - Both versions aim to calculate the ji-prob-est over partitions with a given pattern and database ratio.
;; - The older recursive approach handles each partition individually, while the new version collectively processes
;;   the partitions via superposition and collapse.
;; - The new implementation simplifies the code and leverages metta's capabilities to avoid deep recursion.

(=(do-ji-prob $partitions $pattern $db $db_ratio) (
   collapse (ji-prob-est (superpose $partitions) $pattern $db $db_ratio)
))


;; Calculate the probability estimate of each partition based on
;; independent assumption of between each partition block, taking
;; into account the linkage probability.
(=(ji_prob_est_interval $pattern $db $db_ratio) (
   let ($emin $emax) (min-max  (do-ji-prob (generet-partition-without-pattern $pattern) $pattern $db $db_ratio))
        ($emin $emax)
))



(=(isurp $pattern $db $normalize $db_ratio) (
    let* (
      (($emin $emax) (ji_prob_est_interval $pattern $db $db_ratio))
           ($emp (emp-prob-pbs  $pattern $db $emax $db_ratio))
            ($dst (dst_from_interval $emin $emax $emp))
             ($maxprb (max ($emp $emax))))
               (min ((if $normalize (// $dst $maxprb) $dst) 1.0))
))





