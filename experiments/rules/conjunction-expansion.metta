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
! (import! &self conj-exp)

 ; The starting point for the conjunction expansion. It passes
 ; the Alpha Converted pattern (if necessary) to the expand_conjunction functions.
 ; if it passes the minimum variable check

(= (expand_conjunction $cnjtion $pattern $db $ms $mv $es)
     ; (let* (
     ;         ($alpha_vars (alpha_convert (get_variables_for_tree $pattern) (get_variables_for_tree $cnjtion)))
     ;         ($extract (substitute $pattern $alpha_vars))
     ;         ($apat (car-atom $extract))
     ;     )

     ; ($apat (let $alpha_vars
     ;         (alpha_convert (get_variables_for_tree $pattern) (get_variables_for_tree $cnjtion))
     ;         (let $extract (substitute $pattern $alpha_vars) (car-atom $extract)))))
     ; (if (> (let* (
     ;                 ($temp (get_variables_for_tree $pattern))
     ;                 ($temp2 (get_variables_for_tree $cnjtion)))
     ;             (+ (count-atom-element  $temp) (count-atom-element  $temp2))) $mv)
    (if $es
        (expand_conjunctin_es_rec $cnjtion $pattern $db $ms)
        (expand_conjunction_rec $cnjtion $pattern $db $ms))
     ; )
     ; )
)
(= (count-atom-element $atom) (if (== $atom ()) 0 (+ 1 (count-atom-element (cdr-atom $atom)))))
 ; (= (get_variables_for_tree ()) ())
 ; (= (get_variables_for_tree $pattern)
 ;     (let* (
 ;             ($head (car-atom $pattern))
 ;             ($tail (cdr-atom $pattern)))

 ;         (if (== (get-metatype $head) Expression)
 ;             (concatTuple (get_variables_for_tree $head)
 ;                 (get_variables_for_tree $tail))
 ;             (if (== (get-metatype $head) Variable)
 ;                 (concatTuple
 ;                     ($head)
 ;                     (get_variables_for_tree $tail))

 ;                 (get_variables_for_tree $tail))))

 ; )


(= (get_variables_for_tree $pattern)
    (if (== $pattern ())
        ()
        (let* (
                ($head (car-atom $pattern))
                ($tail (cdr-atom $pattern)))

            (if (== (get-metatype $head) Expression)
                (concatTuple (get_variables_for_tree $head)
                    (get_variables_for_tree $tail))
                (if (== (get-metatype $head) Variable)
                    (concatTuple
                        ($head)
                        (get_variables_for_tree $tail))

                    (get_variables_for_tree $tail))))
    )
)

 ; ! (get_variables_for_tree  (LIST_LINK (INHERITANCE_LINK A $D) (LIST_LINK G $G)))
;; inprogress
(= (get_variable_for_pattern $pattern)
    (case ($pattern) (
            ( (()) ())
             ; ( ( ($pattern) () ) $pattern)
            (  (($x))
                (if (== (get-metatype $x) Variable)
                    ($x)
                () ;; Not actually a variable
            ))
    ( (  ($link $x $y))
        (let* (
                ( $subx (if ( == ( get-metatype $x ) Expression) (get_variable_for_pattern $x) (get_variable_for_pattern ($x))))

                ( $suby (if (== (get-metatype $y) Expression) (get_variable_for_pattern $y) (get_variable_for_pattern ($y))))
            )
        ($subx $suby)
         ; ( ($subx $remaining))
    )
)
; ( ( ($link $x) $variables)
;     (let* (
;             ( ($subx $remaining) (if ( == ( get-metatype $x ) Expression) (substitute $x $variables) (substitute ($x) $variables)))
;         )
;     ( ($link $subx) $remaining)
; )
; )
)
)
)
;  ! (get_variable_for_pattern  (LIST_LINK (INHERITANCE_LINK A $D) (LIST_LINK G $G)))
(= (substitute $pattern $variables)
    (case ($pattern $variables) (
            ( ( () $variables) ())
             ; ( ( ($pattern) () ) $pattern)
            ( ( ($x) $variables)
                (if (== (get-metatype $x) Variable)
                    (if (== $variables ())
                        ($x $variables)
                        ( (car-atom $variables) (cdr-atom $variables)) ;; Substitute
                    )
                ($x $variables) ;; Not actually a variable
            ))
    ( (  ($link $x $y) $variables)
        (let* (
                ( ($subx $remaining) (if ( == ( get-metatype $x ) Expression) (substitute $x $variables) (substitute ($x) $variables)))

                ( ($suby $final) (if (== (get-metatype $y) Expression) (substitute $y $remaining) (substitute ($y) $remaining)))
            )
        ( ($link $subx $suby) $final)
    )
)
( ( ($link $x) $variables)
    (let* (
            ( ($subx $remaining) (if ( == ( get-metatype $x ) Expression) (substitute $x $variables) (substitute ($x) $variables)))
        )
    ( ($link $subx) $remaining)
)
)
)
)
)



 ;############################################################
 ;###############   alpha convert  ###########################
 ;############################################################
 ; (= (var $x)

 ;     $x

 ; )
 ; ! (var ($link $x))
(= (alpha_convert  $pattern_vars $cnjtion_vars)
    (extract_values (consolidate_keys (address_conflict $pattern_vars $cnjtion_vars)))
)

 ; ! (get_variables_for_tree (INHERITANCE_LINK $X $Y))
 ; ! (get_variables_for_tree (LIST_LINK $A $B))
(= (address_conflict $pattern_vars $cnjtion_vars)
    (if (== $pattern_vars ())
        ()
        (let* (
                ($head (car-atom $pattern_vars))
                ($tail (cdr-atom $pattern_vars)))
            (if (does_exist $head $cnjtion_vars)
                (concatTuple ( ($head (generateRandomVar))) (address_conflict $tail $cnjtion_vars ))
                (concatTuple ( ($head $head)) (address_conflict $tail $cnjtion_vars))))
    )
)

(= (does_exist $var $list_vars)
    (if (== $list_vars ())
        False
        (if (== $var (car-atom $list_vars))
            True
            (does_exist $var (cdr-atom $list_vars)))
    )
)

 ; ! (address_conflict ($A $B $F $A $F) ($A $C $D $F))

(= (consolidate_keys $input_list)
    (let* (
            ($result ())
            ($seen_keys ()))
        (consolidate_helper $input_list $result $seen_keys)
    )
)

(= (consolidate_helper $input_list $result $seen_keys)
    (if (== $input_list ())
        $result
        (let* (
                ($pair (car-atom $input_list))
                ($key (car-atom $pair))
                ($value (cdr-atom $pair)))
            (if (does_exist $key $seen_keys)
                (consolidate_helper (cdr-atom $input_list)
                    (concatTuple ( ($key (let $temp (get_value $key $result) (car-atom $temp)))) $result)
                    $seen_keys)
                (let* (
                        ($new_result (let $temp (cons-atom $key $value) (cons-atom $temp $result)))
                        ($new_seen_keys (cons-atom $key $seen_keys)))
                    (consolidate_helper (cdr-atom $input_list) $new_result $new_seen_keys))))
    )
)

(= (get_value $key $list)
    (if (== $list ())
        ()
        (if (== $key (let $temp (car-atom $list) (car-atom $temp)))
            (let $temp2 (car-atom $list) (cdr-atom $temp2))
            (get_value $key (cdr-atom $list)))
    )
)

 ; (get_value $key (cdr-atom $list))

 ; ! (get_value A ( (B D) (A C) (A B)))
(= (extract_values $input_list)
    (extract_helper $input_list ())
)

(= (extract_helper $input_list $values)
    (if (== $input_list ())
        $values
        (let* (
                ($pair (car-atom $input_list))
                ($value (cdr-atom $pair))
                ($tail (cdr-atom $input_list)))
            (extract_helper $tail (cons-atom (car-atom $value) $values)))
    )
)

 ; ! (alpha_convert (get_variables_for_tree (LIST_LINK $X $A)) (get_variables_for_tree (, (INHERITANCE_LINK $X $Y) (LIST_LINK $X $B))))
 ; ! (substitute (LIST_LINK $X $A) ($R-D1737102179 $A))
 ;! (alpha_convert ($A $B $F $A $F) ($A $C $D $F))
 ; ! (alpha_convert ($A $B $C ) ($X $Y $Z))

 ;#############################################################
 ;############   alpha convert end  ###########################
 ;#############################################################

(= (expand_conjunction_rec $cnjtion $apat $db $ms)
    (let $npat (expand_conjunction_connect $cnjtion $apat (get_variables_for_tree $cnjtion) (get_variables_for_tree $apat))
         (checker $db (let $single (collapse $npat) (car-atom $single)) $ms)
        ; $npat

    )
)

(= (expand_conjunction_connect $cnjtion $pattern $cv $pv)
    (let $list (replace_pattern $cnjtion $pattern (combine_lists $cv $pv))
        ;  (let $list  (combine_lists $cv $pv)
        ;  (remove_alpha_similar $list)
        $list
         ; (get-metatype $list)
    )
;      (let* (
;              ($list (combine_lists $cv $pv))
;              ($list2 (replace_pattern $cnjtion $pattern $list))
;              ($list3 (remove_alpha_similar $list2))
;          )
;      $list3
;  )
)
(= (replace_pattern $cnjtion $pattern ())
    ()
)
(= (replace_pattern $cnjtion $pattern $pv2cv)
    (let* (
            ($head (car-atom $pv2cv))
            ($tail (cdr-atom $pv2cv))
            ($exp (substitute $pattern $head))
            ($new_cnjtion (, $cnjtion (car-atom $exp)))
        )
    (
         $new_cnjtion
         (replace_pattern $cnjtion $pattern $tail)

    )
)
)

(= (checker $db () $ms) ())

(= (checker $db ($x $xs) $ms)
   (let $sup (support_evaluation $db $x $ms)
    (if (> $sup 0)
        (($x $sup)(checker $db $xs $ms))
        (checker $db $xs $ms)
    ))
)



(= (support_evaluation $db $pattern $ms)
    (let $sup (counter $db $pattern)
        (if (>= $sup $ms)
            $sup
            0)
    )
)

(= (remove_alpha_similar $list)
    (remove_alpha_similar_helper $list ())
)

(= (remove_alpha_similar_helper ($listHead $listTail) $seen_list)
    (if (== $listTail ())
        ()
        (let* (
                ($matched (collapse (match &self $listHead $listHead)))
                ($seen_list_new (concatTuple ($matched) $seen_list)))
            (if (or (== $matched ()) (does_exist $matched $seen_list)) ;(or (== $matched ()) )but supp evaluation will check this
                (remove_alpha_similar_helper $listTail $seen_list)
                ( $listHead (remove_alpha_similar_helper $listTail $seen_list_new))))
    )
)

(= (expand_conjunction_es_rec $cnjtion $apat $db $ms)
    (pass)
)

(= ( expand_conjunction_disconnect $cnjtion $pattern ) (
        let* (
            ($cnjtion_vars (get_variables_for_tree $cnjtion))
            ($pat_vars  (get_variables_for_tree $pattern))
            ($acvar (alpha_convert $pat_vars $cnjtion_vars))
            ($acpat (let $pat (substitute $pattern $acvar) (car-atom $pat)))
            ($npat (append_pat $cnjtion $acpat))
            ($nclause (remove_redundant_subclauses $npat))
        ) $acvar
))

(= ( append_pat $pat $conj) ( , $pat $conj))

 ; ! (expand_conjunction_disconnect (INHERITANCE_LINK A $X) (LIST_LINK $X B))

 ;##############
 ;# Test cases #
 ;##############

 ;Populate the Atomspace with some data

(INHERITANCE_LINK A B)
(LIST_LINK A B)
(LIST_LINK A C)
(LIST_LINK B C)
(INHERITANCE_LINK A D)
(INHERITANCE_LINK X Y)
(LIST_LINK Y C)
(INHERITANCE_LINK X D)

 ;(expand_conjunction_inputs cnjtion pattern db ms mv es)
! (expand_conjunction (,(INHERITANCE_LINK $X $Y) (LIST_LINK A $D)) (LIST_LINK $G $F) &self 5 2 False)
; !(match &self (, (, (INHERITANCE_LINK $X $Y) (LIST_LINK A $D)) (LIST_LINK $X $G)) (, (, (INHERITANCE_LINK $X $Y) (LIST_LINK A $D)) (LIST_LINK $X $G)))