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
(=(emp_prob_pbs_mem $subpattern $db  $db_ratio) 0.4)


;; Calculate the product of the probability over subpatterns
;; without considering joint variables
(=(pro-prob-wout-joint $subpatterns $db $db_ratio $p) (
  if (== $subpatterns ()) $p (
    let* ((($subpattern $tail) (decons-atom $subpatterns))
           ($empr (emp_prob_pbs_mem $subpattern $db  $db_ratio))
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



(=(do-ji-prob $partitions $pattern $db $db_ratio) (
  if (== $partitions ()) () (
     let* ((($partition $tail) (decons-atom $partitions))
            ($jip (ji-prob-est $partition $pattern $db $db_ratio))
             ($dummy (do-ji-prob $tail $pattern $db $db_ratio)))
             (cons-atom $jip $dummy) ))
)


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
           ($emp (emp_prob_pbs_mem $pattern $db $emax $db_ratio))
            ($dst (dst_from_interval $emin $emax $emp))
             ($maxprb (max ($emp $emax))))
               (min ((if $normalize (/ $dst $maxprb) $dst) 1.0))
))




