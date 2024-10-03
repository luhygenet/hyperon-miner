 ; /**
 ;  * Given cnjtion and pattern, consider all possible connections
 ;  * (a.k.a linkages) and expand cnjtion accordingly. For instance if
 ;  *
 ;  * cnjtion = (Inheritance X Y)
 ;  * pattern = (Inheritance Z W)
 ;  *
 ;  * return
 ;  *
 ;  *   (, (Inheritance X Y) (Inheritance X W))
 ;  *   (, (Inheritance X Y) (Inheritance Z X))
 ;  *   (, (Inheritance X Y) (Inheritance Y W))
 ;  *   (, (Inheritance X Y) (Inheritance X Y))
 ;  *
 ;  * It will also only include patterns with minimum support ms
 ;  * according to db, and perform alpha-conversion when necessary.
 ;  *
 ;  * mv is the maximum number of variables allowed in the resulting
 ;  *    patterns.
 ;  *
 ;  */

! (register-module! ../../experiments)
! (import! &self experiments:utils:common-utils)
 ; ! (import! &self conj-exp)

 ; The starting point for the conjunction expansion. It passes
 ; the Alpha Converted pattern (if necessary) to the expand_conjunction functions.
 ; if it passes the minimum variable check

(= (expand_conjunction $cnjtion $pattern $db $ms $mv $es)
    (let* (
            ($apat (alpha_convert $cnjtion $pattern)))
        (if (> (let* (
                        ($temp (get_variables $pattern))
                        ($temp2 (get_variables $cnjtion)))
                    (+ (length $temp) (length $temp2))) $mv)
            (if $es
                (expand_conjunctin_es_rec $cnjtion $apat $db $ms $pattern)
                (expand_conjunction_rec $cnjtion $apat $db $ms $pattern))
            ())
    )
)

 ; Alpha convert pattern so that none of its variables collide with
 ; the variables in other_vars.

(= (alpha_convert ($link1 $x1 $y1) ($link2 $x2 $y2))
    (if (and (== $x1 $x2) (== $y1 $y2))
        ($link2 $X-78235323 $y2)
        ($link2 $x2 $y2)
    )
)
(= (alpha_convert ($link1 $x1 $y1) ($link2 $x2 $y2))
    (if (and (== $x1 $x2) (== $y1 $y2))
        ($link2 $x2 $Y-78235323)
        ($link2 $x2 $y2)
    )
)

(:reverse (-> List List))

(= (reverse ()) ())
(= (append () $ele) ( $ele ()))

(= (append ( $x $xs) $ele)
    ( $x (append $xs $ele)))
(= (reverse ( $x $xs))
    (append (reverse $xs) $x))

(= (handle $x ($xs)) (cons-atom $xs $x))
(= (handle $val ($x $y))
    (let $z (cons-atom $x $val) (handle $z $y) )
)

(= (get_elements  () ()) ())
(= (get_elements $val ($elm ()))  ( (cons-atom $elm $val)))
( = (get_elements $val ($x ($xs $xss)))
    (
        if (== $x End)
        (get_elements () ($xs $xss))
        (
            if ( == $xs End)
            ( (cons-atom $x $val) (get_elements () $xss))
            (let $f (cons-atom $x $val ) (get_elements $f  ($xs $xss)) )
        )
))

 ; Parse a list that is like:- (Inheritance ($X ($Y (End (Inheritance ($X ($Y (End  ...))))))))
 ; into ((Inheritance $X $Y) (Inheritance $X $Y) ...) FOR later combination with cnjtion and
 ; pattern matching against the db

(= (parse_list ($x ($xs $xss)))
    (handle () (get_elements  () (reverse ($x ($xs $xss)))))

)

(= (expand_conjunction_rec $cnjtion $apat $db $ms $pattern)
    (let $npat (let $temp (expand_conjunction_connect $cnjtion $apat) (parse_list $temp))
        (checker $db (reconstruct $cnjtion $npat) $ms))
)

 ; Simulate support evaluation since the support implementation currently takes
 ; lots of minutes to check just one support and I have to check more than 20 pattern's support

(= (support_evaluation $db $pattern $ms)
    (let $sup (counter $db $pattern)
        (if (>= $sup $ms)
            True
            False)
    )
)

(= (length ()) 0)
(= (length ($x $xs))
    (+ 1 (length $xs)))

 ; This function checks if the patterns generated pass support evaluation and the conjunction passes n_conjuncts check
 ; (The implementation for n_conjunction in the common-utils.metta seems incorrect. I don't know maybe I am wrong :)

(= (checker $db () $ms) ())
(= (checker $db ($x $xs) $ms)
    (if (support_evaluation $db $x $ms)
        ($x (checker $db $xs $ms))
        (checker $db $xs $ms)
    )
)

 ; Combine and reconstruct are functions to combine each patterns generated with
 ; the conjunction and then reconstruct them into a list.
 ; It will create something like this: ((, (Inheritance $X $Y) (Inheritance $X $W)) ...)

(= (combine $cnjtion $pattern)
    (if (== $patterns ())
        ()
        (cons-atom , ($cnjtion $pattern))
    )
)

(= (reconstruct $cnjtion $xs)
    (if (== $xs ())
        ()
        ( (combine $cnjtion (car-atom $xs)) (reconstruct $cnjtion (cdr-atom $xs)))
    )
)

 ; If the patterns are only two variables with the link
 ; If that is not the case I have written a python grounded function named combine_lists to find
 ; the combinations between every variable in the pattern and the conjunction

(= (generate-combinations ($link1 $x $y) ($link2 $a $b))
    (   ($x $a)
        ($x $b)
        ($y $a)
        ($y $b)
        ($a $x)
        ($a $y)
        ($b $x)
        ($b $y)
    )
)

(= (expand_conjunction_connect $cnjtion $pattern)
    (expand_conjunction_connect $cnjtion $pattern (generate-combinations  $cnjtion $pattern))
)

 ; This function create the patterns using the combined variables from the
 ; Pattern and the Conjunction. It will create a list of patterns that can be used for combination later with conjunction.
 ; It will create something like: (Inheritance ($X ($Y (End (Inheritance ($X ($Y (End  ...))))))))

(= (expand_conjunction_connect $cnjtion $pattern $pv2cv)
    (if (== $pv2cv ())
        ()
        (pattern_var_replacer $pattern $pattern (car-atom $pv2cv) $cnjtion $pv2cv)
    )
)

(= (pattern_var_replacer $ori_pattern $pattern $var $cnjtion $pv2cv)
    (if (== $pattern ())
        (End (expand_conjunction_connect $cnjtion $ori_pattern (cdr-atom $pv2cv)))
        (if (is-variable (car-atom $pattern))
            ( (car-atom $var) (pattern_var_replacer $ori_pattern (cdr-atom $pattern) (cdr-atom $var) $cnjtion $pv2cv))
            ( (car-atom $pattern) (pattern_var_replacer $ori_pattern (cdr-atom $pattern) $var $cnjtion $pv2cv)))
    )
)

 ; The implementation has no difference with the expand_conjunction_rec
 ; in the C++ code.
(= (expand_conjunction_es_rec $cnjtion $apat $db $ms)
    (pass)
)
 ;##############
 ;# Test cases #
 ;##############

 ;Populate the Atomspace with some data

(INHERITANCE_LINK A B)
(LIST_LINK B C)
(INHERITANCE_LINK A D)

 ;(expand_conjunction_inputs cnjtion pattern db ms mv es)
! (expand_conjunction (INHERITANCE_LINK $X $Y) (LIST_LINK $X $Y) &self 1 2 False)

 ; One CE output for (Inheritance $X $Y) (LIST_LINK $X $Y) with ms 2
! (match &self (, (INHERITANCE_LINK $X $Y) (LIST_LINK $Y $X-78235323)) ($X $Y $X-78235323))