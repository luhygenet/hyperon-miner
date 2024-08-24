;! (register-module! ../../../hyperon-miner)
;! (import! &database hyperon-miner:experiments:data:sample-data)
;! (import! &self hyperon-miner:experiments:utils:common-utils)
;! (import! &self hyperon-miner:utils:DeBruijnIndex)
;; Rule to calculate the empirical truth value of a pattern.

;; TODO: implement universe-count and support.


(=(Default_k) 1)
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
                        ((support  $pattern  $db $ms)
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



(= (support $pattern $db $minsup)
    (let $cnt (count $pattern $db)
      (if (> (+ $cnt 1) $minsup) (candidate $pattern $cnt) (superpose ()))))

;;TODO candidate

;!(emp-tv (lambda (Parent $x Nil) (Parent $x Nil)) (new-space))


