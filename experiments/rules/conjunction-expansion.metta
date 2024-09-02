! (register-module! ../../experiments)
! (import! &self experiments:utils:common-utils)
! (import! &self conj-exp)

! (bind! np (py-atom numpy))
! (bind! np-array (py-atom numpy.array))

(= (expand_conjunction $cnjtion $pattern $db $ms $mv $es)
    (let* (
            ($apat (alpha_convert ($pattern get_variables ($cnjtion)))))
        (if $es
            (expand_conjunction_es_rec $cnjtion $apat $db $ms $mv $pattern) ;pattern is mine
            (expand_conjunction_rec $cnjtion $apat $db $ms $mv $pattern) ;pattern is mine
        )
))

(= (get_variables $pattern)
    (if (== $pattern ())
        ()
        (if (== (let* (
                        ($var (car-atom $pattern)))
                    (get-metatype $var)) Variable)
            ( (car-atom $pattern) (get_variables (cdr-atom $pattern)))
            (get_variables (cdr-atom $pattern))
        ))
)

(= (alpha_convert $pattern $cnjtion_vars)
    (if (== $cnjtion_vars ())
        $pattern
        (let* (
                ($pattern_vars (get_variables $pattern))
            )
        (if (is-member (car-atom $cnjtion_vars) $pattern_vars)
            (alpha_convert (collapse (replace $pattern $cnjtion_vars)) (cdr-atom $cnjtion_vars))
            (alpha_convert $pattern (cdr-atom $cnjtion_vars))
        )))
)

(= (replace $pattern $variables)
    (if (== $pattern ())
        (empty)
        (let* (
                ($head (car-atom $pattern))
                ($tail (cdr-atom $pattern))
                ($rh (find-replacement $head $variables))
            )
        (superpose ($rh (replace $tail $variables)))
    )
))

 ;TODO1
 ;Check if the same variable with is used for replacement
 ;if that is the case replace it with the replacement variabele
 ;used for replacing that variable
(= (find-replacement $var $variables)
    (if (== $variables ())
        $var
        (if (== $var (car-atom $variables))
            (generateRandomVar $var $variables)
             ; $rand
            (find-replacement $var (let* (
                        ($temp (cdr-atom $variables))
                        ($tail (car-atom $temp)))
                    $tail)))
    )
)

 ;Test cases
 ; ! (get_variables (Inheritance $Y $X ConceptNode Test $Z))
 ; ! (collapse (replace (Inheritance $Y $Y ConceptNode Test $Z $Z $A)  ($X ($Y ($A ())))))
 ; ! (alpha_convert (Inheritance $Y $X ConceptNode Test $Z) ($W ($U ($V ()))))

(= (expand_conjunction_rec $cnjtion $apat $db $ms $mv $pattern)
    (let* (
            ($cvars (get_variables $cnjtion))
            ($pvars (get_variables $pattern)))
        (outer_loop 0 $pvars $cnjtion $pattern $mv $ms)
    )
)

(= (outer_loop $pvi $pvars $cnjtion $pattern $mv $ms)
    (if (< $pvi (count-atom-element $pvars))
        (inner_loop $cvi $cvars $pvi $pvars $cnjtion $pattern)
        (empty) ;since the patterns are added to the &pattern space
    )
)

(= (inner_loop $cvi $cvars $pvi $pvars $cnjtion $pattern $mv $ms)
    (if (< $cvi (count-atom-element $cvars))
        (let ($npat (pat_format (expand_conjunction_connect $cnjtion $pattern (get_variables $pattern) (get_variables $cnjtion))))
            (if (and (<= (count-atom-element (get_variables $npat)) mv) (< (n_conjuncts $cnjtion) (n_conjuncts $npat)))
                (if (< (count $npat) $ms)
                    (inner_loop (+ 1 $cvi) $cvars $pvi $pvars $cnjtion $pattern $mv $ms)
                    (let $place_holder (add-atom &self $npat) (inner_loop (+ 1 $cvi) $cvars $pvi $pvars $cnjtion $pattern $mv $ms))) ; change self to patterns space
                (expand_conjunction_rec $cnjtion $apat $db $ms $mv $pattern)))
        (outer_loop (+1 $pvi) $pvars $cnjtion $pattern $mv $ms))
)

 ; Test mapping
 ; ! (combine_lists ($Y ($X ())) ($a  ($b ($c ()))))

(= (expand_conjunction_connect $cnjtion $pattern $cnjtion_var $pattern_var)
    (expand_conjunction_connect $cnjtion $pattern (combine_lists $cnjtion_var $pattern_var))
)

(= (expand_conjunction_connect $cnjtion $pattern $pv2cv)
    (if (== $pv2cv ())
        ()
        (pattern_var_replacer $pattern $pattern (car-atom $pv2cv) $cnjtion $pv2cv)
    )
)

(= (pattern_var_replacer $ori_pattern $pattern $var $cnjtion $pv2cv)
    (if (== $pattern ())
        (Nil (expand_conjunction_connect $cnjtion $ori_pattern (cdr-atom $pv2cv)))
        (if (is-variable (car-atom $pattern))
            ( (car-atom $var) (pattern_var_replacer $ori_pattern (cdr-atom $pattern) (cdr-atom $var) $cnjtion $pv2cv))
            ( (car-atom $pattern) (pattern_var_replacer $ori_pattern (cdr-atom $pattern) $var $cnjtion $pv2cv)))
    )
)

(= (expand_conjunction_es_rec $cnjtion $apat $db $ms $mv)
    pass
)

 ;Test expand_conjunction_connect
! (expand_conjunction_connect (Inheritance $X $Y) (Inheritance $Z $W $A) (get_variables (Inheritance $X $Y)) (get_variables (Inheritance $Z $W $A)))
