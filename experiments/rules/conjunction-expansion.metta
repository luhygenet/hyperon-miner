! (register-module! ../../experiments)
! (import! &self experiments:utils:common-utils)

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
 ;TODO2
 ;Make the replacement a variable not string
(= (find-replacement $var $variables)
    (if (== $variables ())
        $var
        (if (== $var (car-atom $variables))
            (let $temp (replacement-map $var ( (py-dot np random.choice) (np-array (py-atom "['$J' ,'$M' ,'$N' ,'$O']")))) ( (py-dot np random.choice) (np-array (py-atom "['$J' ,'$M' ,'$N' ,'$O']"))))
             ; $rand
            (find-replacement $var (let* (
                        ($temp (cdr-atom $variables))
                        ($tail (car-atom $temp))
                    ) $tail)))
)
)

(= (fromat $pattern)
    ()
)

 ;Test cases
! (get_variables (Inheritance $Y $X ConceptNode Test $Z))
! (collapse (replace (Inheritance $Y $Y ConceptNode Test $Z $Z $A)  ($X ($Y ($A ())))))
! (alpha_convert (Inheritance $Y $X ConceptNode Test $Z) ($W ($U ($V ()))))

 ;#########################################################
 ;######################Not Complete#######################
 ;#########################################################

(= (expand_conjunction_rec $cnjtion $apat $db $ms $mv $pattern)
    (let* (
            ($cvars (get_variables $cnjtion))
            ($pvars (get_variables $cnjtion)))
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
        (let ($npat (expand_conjunction_connect $cnjtion $pattern (map (car-atom $pvars) (car-atom $cvar) )))
            (if (and (<= (count-atom-element (get_variables $npat)) mv) (< (n_conjuncts $cnjtion) (n_conjuncts $npat)))
                (if (< (count $npat) $ms)
                    (inner_loop (+ 1 $cvi) $cvars $pvi $pvars $cnjtion $pattern $mv $ms)
                    (let $place_holder (add-atom &self $npat) (inner_loop (+ 1 $cvi) $cvars $pvi $pvars $cnjtion $pattern $mv $ms))) ; change self to patterns space
                (expand_conjunction_rec $cnjtion $apat $db $ms $mv $pattern)))
        (outer_loop (+1 $pvi) $pvars $cnjtion $pattern $mv $ms))
)

(= (expand_conjunction_es_rec $cnjtion $apat $db $ms $mv)
    pass
)
