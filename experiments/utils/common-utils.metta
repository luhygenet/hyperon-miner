 ;; Declaration of List data type and constructors
(: List (-> $a Type))
(: Nil (List $a))
(: Cons (-> $a (List $a) (List $a)))

;; Define Nat
(: Nat Type)
(: Z Nat)
(: S (-> Nat Nat))

;; Define cast functions between Nat and Number
(: fromNumber (-> Number Nat))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))
(: fromNat (-> Nat Number))
(= (fromNat Z) 0)
(= (fromNat (S $k)) (+ 1 (fromNat $k)))

 ;; Count the number elements in an expression
(: tuple-count (-> %Undefined% Number))
(= (tuple-count $atom) (if (== $atom ()) 0 (+ 1 (tuple-count (cdr-atom $atom)))))

 ;; Count the number of instances of a given pattern
(: counter (-> hyperon::space::DynSpace Atom Number))
(= (counter $db ($link $x $y))
    (let $result (collapse (match $db ($link $x $y) ($link $x $y)))
        (tuple-count $result)
    )
)

; Count the number of instances of a given pattern
(= (count $pattern $db)
    (let* (($dptrn (Debruijn2var $pattern (Cons $Xvar (Cons $Yvar Nil))))
           ($result (collapse (match $db $dptrn $dptrn))))
        (tuple-count $result)))

;; Evaluate if the pattern has enough support
;; Evaluate if the pattern has enough support
(: sup-eval (-> hyperon::space::DynSpace Atom Number Boolean))
(= (sup-eval $db ($link $x $y) $ms)
    (let $sup (counter $db ($link $x $y))
        (if (>= $sup $ms) (CandidatePattern (Var2Debruijn ($link $x $y))) (superpose ()))
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

 ;;abs accepts a number and returns an absolute value of a number
(: abs (-> Number Number))
(= (abs $x)
    (if (>= $x 0)
        $x
        (* $x -1)
    )
)

 ;; equals-to-zero  accepts a Number and compares it with zero if it is equals to zero it returns a boolean value True else False
(: equals-to-zero (-> Number Boolean))
(= (equals-to-zero $x) (== $x 0))

 ;; classify_integer_position function accepts a Number and returns a strings that tells if a number is Greater than zero equal to zero or less than zero
(: classify_integer_position (-> Number String))
(= (classify_integer_position $x)
    (if (> $x 0)
        ("Greater than zero")
        (case (equals-to-zero $x)
            (
                (False "Less than zero")
                (True "Equal to zero")))))
 ;; pow is a function that calculates a to the power of b where a and b are numbers
(: pow (-> Number Number Number))
(= (pow $a $b)
    (case (classify_integer_position $b)
        (
            ("Equal to zero" 1)
            ("Less than zero" (/ 1 (pow $a (abs $b))))
            ($_ (* $a (pow $a (- $b 1))))
        )
)
)

 ;; universe count
(= (universe-count $pattern $db)
    (pow (db_size $db) (n_conjuncts $pattern))

)

 ;Check if atom is member of list or not
(= (is-member $y ()) False)
(= (is-member $y ($x $xs))
    (if (== $y $x)
        True
        (is-member $y $xs)
    )
)

 ;check if atom is variable or not
(= (is-variable $x)
    (if (== (get-metatype $x) Variable)
        True
        False
    )
)