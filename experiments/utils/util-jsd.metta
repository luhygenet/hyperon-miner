(= (gt-zero-confidence-eval $num)
    (if (> $num 0)
        True
        False
    )
)

(= (exist $value)
    (if (== $value ())
        False
        True
    )
)

(: Pattern Type)
(: Db Type)

 ;;Simulation for the emp-eval
(: emp-eval (-> Pattern Db Number))
(= (emp-eval $pattern $db)
    (case $pattern
        (
            ( (Parent abel henok) (0.6 1))
            ( (Parent abel mary) (0.7 1))
            ($_ (0.5 1))
        )
))

 ;;Simulation for the est-eval
(: est-eval (-> Pattern Db Number))
(= (est-eval $pattern $db)
    (case $pattern
        (
            ( (Parent abel henok) (0.55 1))
            ( (Parent abel mary) (0.65 1))
            ($_ (0.5 1))
        )
))

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 ;Creates truth value to be use on cog-set-tv stv is just an alias
(: cog-new-stv (-> Number Number Tuple))
(= (cog-new-stv $mean $confidence)
    ($mean $confidence))

 ;  ; Returns truth value of an atom
 ; (: cog-tv (-> Atom Boolean))
 ; (= (cog-tv $atom)
 ;     (match &self (ConceptNode $atom $stv) $stv)
 ; )

 ;Assuming the database is something like this
 ;(Inheritance Allen human)
 ;(stv Allen 0.98 1)
 ;The tuple is like (0.9 0.8)
(: cog-set-tv (-> Atom Tuple Atom))
(= (cog-set-tv $atom $tv)
    (let* ( ($var (cdr-atom $atom))
            ($var2 (car-atom $var))
            ($mean (car-atom $tv))
            ($var3 (cdr-atom $tv))
            ($confidence (car-atom $var3))
        ) (add-atom &self (stv $var2 $mean $confidence)))
)

 ; asssuming the db is like this
 ; (Inheritance Allen human)
 ; (stv Allen 0.4 1)
 ; (Inheritance Abebe human)
 ; (stv Abebe 0.6 1)
 ; (Inheritance Allen human)
 ; (Inheritance Kebede human)
 ; (stv Kebede 0.9 1)
 ; (Inheritance Allen human)

(= (cog-tv $pattern)
    (let* ( ($var (cdr-atom $pattern))
            ($var2 (car-atom $var))
        ) (match &self (stv $var2 $mean $confidence) (stv $mean $confidence)))

)

(= (is-expression $var) (== Expression (get-metatype $var)))
(= (is-variable $var) (== Variable (get-metatype $var)))
(= (is-symbol $var) (== Symbol (get-metatype $var)))

 ; This function checks if a given expression is a pattern.
 ; It takes an expression ($expr) as input and evaluates whether it matches
 ; specific structures involving symbols, variables, and expressions.
 ; The function returns True if the expression is a pattern, otherwise False.
(= (is-pattern $expr) (

        or (unify $expr ($link $x $y) (
                and (is-symbol $link) (
                    or (or (is-variable $x) (is-expression $x))
                    (or (is-variable $y) (is-expression $y)))) False)
        (unify $expr ($link $x)
            (and (is-symbol $link)
                (or (is-variable $x)
                    (is-expression $x))) False )))
