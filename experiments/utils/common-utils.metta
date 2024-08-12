;; Count the number elements in an expression
(= (count-atom-element $atom) (if (== $atom ()) 0 (+ 1 (tuple-count (cdr-atom $atom)))))

;; Count the number of instances of a given pattern
(= (count $db $pattern)
    (let $result (collapse (match &$db ($pattern) $pattern))
    (count-atom-element $result)
    )
)

;; Evaluate if the pattern has enough support
(= (sup-eval $db $pattern $ms)
    (let $sup (count $db $pattern)
    (if (>= $sup $ms) True False) 
    )
)
