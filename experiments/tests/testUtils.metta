
 ;;Support: number of data trees matching a given pattern.
(= (sup $pattern $db)
    (tuple-count (collapse (match $db $pattern $pattern))))
