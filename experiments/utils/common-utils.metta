 ;; Declaration of List data type and constructors
(: List (-> $a Type))
(: Nil (List $a))
(: Cons (-> $a (List $a) (List $a)))
 
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



(= (has-type $x Nil) False)
(= (has-type $x ($l $head $tail)) (if (== $x $l) True (has-type $x $tail)))

;;(: get-arity (-> $pattern) Number)
(= (get-arity Nil ) 0 )
(= (get-arity $pattern) 
    (- (count-atom-element $pattern) 1) )



(= (n_conjuncts Nil) (0))
(= (n_conjuncts $pattern)
   (if (not (has-type lambda $pattern))
       0
       (if (or (has-type and $pattern) (has-type Present $pattern))
           (get-arity (cdr-atom $pattern))
           1)))


;;db size
(: db_size (-> hyperon::space::DynSpace  Number))
(= (db_size $db)
    (count-atom-element (collapse (get-atoms $db)))
)

