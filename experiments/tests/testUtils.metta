
 ;;Support: number of data trees matching a given pattern.
(= (sup $pattern $db)
    (count-atom-element (collapse (match $db $pattern $pattern))))
