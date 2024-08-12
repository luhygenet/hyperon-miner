;; Count the number elements in an expression
(= (count-atom-element $tuple) (if (== $tuple ()) 0 (+ 1 (tuple-count (cdr-atom $tuple)))))

;; Count the number of instances of a given pattern
(= (count $pattern)
    (let $result (collapse (match &self ($pattern) $pattern))
    (count-atom-element $result)
    )
)