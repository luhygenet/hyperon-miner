 !(register-module! ../../../hyperon-miner)
! (import! &database hyperon-miner:experiments:data:sample-data)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (import! &self hyperon-miner:utils:MinerUtils)
 ! (import! &self hyperon-miner:utils:DeBruijnIndex)
! (import! &self hyperon-miner:match:MinerMatch)

 ;; Rule to calculate the empirical truth value of a pattern.

 ;; TODO: implement universe-count and support.

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
! (emp-tv (Inheritance Abe human) &database)