 ;; Count the number elements in an expression
(: count-atom-element (-> %Undefined% Number))
(= (count-atom-element $atom) (if (== $atom ()) 0 (+ 1 (count-atom-element (cdr-atom $atom)))))

 ;; Count the number of instances of a given pattern
(: count (-> hyperon::space::DynSpace Atom Number))
(= (count $db $pattern)
    (let $result (collapse (match $db ($pattern) $pattern))
        (count-atom-element $result)
    )
)

 ;; Evaluate if the pattern has enough support
(: sup-eval (-> hyperon::space::DynSpace Atom Number Boolean))
(= (sup-eval $db $pattern $ms)
    (let $sup (count $db $pattern)
        (if (>= $sup $ms) True False)
    )
)

 ;Check if expression is truth value or not
(: cog-tv? (-> Atom Boolean))
(= (cog-tv? $EXP)
    (if (== (match &self (stv $value $mean $conf) True) True)
        True
        False
    )
)