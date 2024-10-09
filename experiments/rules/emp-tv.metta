
 ;; Rule to calculate the empirical truth value of a pattern.

 ;;;;;;;;;;
 ;; Type ;;
 ;;;;;;;;;;

(: TruthValue Type)

 ;;;;;;;;;;;;;;;;;;
 ;; Constructor ;;
 ;;;;;;;;;;;;;;;;;;

 ;; Takes pattern and db_ratio to form an
 ;; empirical truth value.
(: EMPTV (-> $a $b TruthValue))

(= (Default_k) 1)

 ;;Support: number of data trees matching a given pattern.
(= (sup $pattern $db)
    (tuple-count (collapse (match $db $pattern $pattern))))

(= (count_to_confidence $x) (/ $x (+ $x (Default_k))))

 ;; calculate the empirical truth value of a pattern.
(= (emp-tv $pattern $db)
    (let*
        ( ( ($ucount ) ( (universe-count $pattern $db)))
            ( ($ms) ($ucount))
            ( ($sup) ( (sup $pattern $db)))
            ( ($conf) ( (count_to_confidence $ucount)) )
            ($mean (/ $sup $ucount))
            ($confidence   (* 1e-1 $conf))
        )
    (EMPTV $mean  $confidence)))
