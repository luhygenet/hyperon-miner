
;;! (register-module! ../../../hyperon-miner)
;;! (register-module! ../../experiments)
;;! (import! &self experiments:rules:est-tv)
;;! (import! &self experiments:rules:emp-tv)

;;! (import! &database hyperon-miner:experiments:data:sample-data)
;;! (import! &self hyperon-miner:experiments:utils:common-utils)
;;! (import! &self hyperon-miner:experiments:utils:TruthValue)
;;! (import! &self hyperon-miner:experiments:utils:gen_partition)



(=(pro-prob-wout-joint $subpatterns $db $db_ratio $p) (
  if (== $subpatterns ()) $p (
    let* ((($subpattern $tail) (decons-atom $subpatterns))
           ($empr (emp_prob_pbs_mem $subpattern $db  $db_ratio))
           ($new_prob (* $p $empr)))
       (pro-prob-wout-joint $tail $db $db_ratio $new_prob)
  )
))


(=(ji-prob-est  $partition $pattern $db $db_ratio) (
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


(=(ji_prob_est_interval $pattern $db $db_ratio) (
   let ($emin $emax) (min-max(do-ji-prob (generet-partition-without-pattern $pattern) $pattern $db $db_ratio))
        ($emin $emax)
))


(=(isurp $pattern $db $normalize $db_ratio) (
    let* ((($emin $emax) (ji_prob_est_interval $pattern $db $db_ratio))
           ($emp (emp_prob_pbs_mem $subpattern $db  $db_ratio))
            ($dst (dst_from_interval $emin $emax $emp))
             ($maxprb (max ($emp $emax))))
               (min ((if $normalize (/ $dst $maxprb) $dst) 1.0))
))
