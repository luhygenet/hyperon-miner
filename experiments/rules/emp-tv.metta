! (register-module! ../../../hyperon-miner)
! (import! &database hyperon-miner:experiments:data:sample-data)
! (import! &self hyperon-miner:experiments:utils:common-utils)
 ;;! (import! &self hyperon-miner:utils:MinerUtils)
 ;;! (import! &self hyperon-miner:utils:DeBruijnIndex)
! (import! &self hyperon-miner:match:MinerMatch)
 ;!(import! &self hyperon-miner:utils:MinerUtils)

 ; joint-independence estimate with memoization
(= (ji_tv_est_mem $pattern $db) 1

)

(= (get_mean $pattern) 1)

(= (emp_tv_pbs_mem $pattern $db $jte_mean $db_ratio) 1)

 ;Calculate its estimate first to optimize empirical calculation
(= (do-emp-tv $pattern $db $db_ratio)
    (let* (
            ($jte (ji_tv_est_mem $pattern $db))
            ($emp_tv_pbs (emp_tv_pbs_mem  $pattern $db  $jte_mean  $db_ratio))
            ($jte_mean (get_mean $jte)))
        $emp_tv_pbs
    )
)

 ;; Rule to calculate the empirical truth value of a pattern.

(= (Default_k) 1)
(= (count_to_confidence $x) (/ $x (+ $x (Default_k))))

(= (emp-tv $pattern $db)
    (let*
        (
            (
                ($ucount )
                ( (universe-count $pattern $db))
            )
        (
            ($ms)
            ($ucount)
        )
    (
        ($sup)
        ( (support  $pattern   $ms)
        )
)

(
    ($conf)
    ( (count_to_confidence $ucount))
)

($mean (/ $sup $ucount))
($confidence   (* 1e-1 $conf))
)

($mean  $confidence)

)
)

(= (candidate $pattern $count )
    (get-candidate Z $pattern $count))

! (do-emp-tv  (Inheritance Nil Nil) a 1)