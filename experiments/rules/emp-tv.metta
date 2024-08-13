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
                        ((support  $pattern $db $ms)
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

