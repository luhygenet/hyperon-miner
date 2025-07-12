; ! (register-module! ../../../hyperon-miner)
; ; ! (import! &dbspace hyperon-miner:experiments:data:sample-data)
; ! (import! &db hyperon-miner:experiments:data:ugly_man_sodaDrinker)
; ! (import! &self hyperon-miner:experiments:rules:build-specialization)
; ! (import! &self hyperon-miner:experiments:rules:candidate-patterns)
; ! (import! &self hyperon-miner:experiments:rules:conjunction-expansion)
; ! (import! &self hyperon-miner:experiments:utils:common-utils)
; ! (bind! &kb (new-space))
; ! (bind! &dbspace (new-space))
; ! (bind! &specspace (new-space))
; ! (bind! &cndpspace (new-space))
; ! (bind! &aptrnspace (new-space))
; ! (bind! &conjspace (new-space))
; ! (import! &self freq-pat)
; ! (import! &self conj-exp)

; !(let ($link $x $y) (get-atoms &db) (add-atom &dbspace ($link $x $y)))


=================Utils first =========================================
! (import! &self freq-pat)


; function name: depth-handler
                ; function to handle the depth of the pattern

                ; parameters:
                    ; $p: the pattern to be handled

                ;steps
                    ; 1. check if the pattern is an expression
                    ; 2. if it is not an expression, return the pattern
                    ; 3. if it is an expression, destructure the pattern and handle the depth of the pattern by recursively getting all combinations of the variables and symbols of the pattern
(= (depth-handler $p)
    (if (not (== (get-metatype $p) Expression))
        $p
        (let* (
                ( ($link $x $y) $p)
                ( $nx (depth-handler $x))
                ( $ny (depth-handler $y))
            )
        (superpose (
                ($link $nx $w)
                ($link $z $ny)
                ($link $x $u)
                ($link $k $y)
                $d
                ($link $g $o)
                ($link $nx $ny)
            )
    )
)

)
)

; !(depth-handler (And (And C D) E))

; function name: build-specialization
                ; function to build the specialization of a pattern and add it to the specialization space

                ; parameters:
                    ; $pattern: the abstract pattern to be specialized
                    ; $dbspace: the database space to get the valuation of the pattern
                    ; $specspace: the specialization space to add the specialization to

                ;steps
                    ; 1. get the pattern
                    ; 2. get the valuation of the pattern by destructuring the pattern
                    ; 3. abstract the pattern and handle patterns with depth
                    ; 4. build the specialization
                    ; 5. add the specialization to the specialization space

(= (build-specialization ($link $x $y) $dbspace $specspace) 
            (let*
                (
                    ( ($link $x1 $y1) (replacev ($link $x $y)))                            ; replacev is a function that replaces index with variables
                    ( ($subx $suby) (match $dbspace ($link $x1 $y1) ($x1 $y1)))            ; getting the substitution /valuation of the pattern
                    ($shabx (depth-handler $subx))                                    ;handle depth in the x node
                    ($shaby (depth-handler $suby))                                    ; handle depth in the y node
                    ;  (() (println! (shab-⍃ ($shabx $shaby))))                                   
                    ($spec1 (replace (SpecializationOf ($link $shabx $y1) ($link $x $y)))) ;build the specialization and change the variables to indexs 
                    ($spec2 (replace (SpecializationOf ($link $x1 $shaby) ($link $x $y)))) ;build the specialization and change the variables to indexs
                    ; (() (println! (shab-⍃ ($spec1 $spec2))))
                     ; ($spec3 (replace (SpecializationOf ($link $shabx $shaby) ($link $x $y)))) ;optional
                )
            (
                superpose (
                    (remove-atom $specspace $spec1) ; remove the old specialization to avoid redundancy
                    (add-atom $specspace $spec1) ; add the new specialization
                    (remove-atom $specspace $spec2)
                    (add-atom $specspace $spec2)
                    ; (remove-atom $specspace $spec3)
                    ; (add-atom $specspace $spec3)

                )

        )
)
 ; (let ($name $aptrn $spec) (redunpat) (add-atom $specspace (SpecializationOf $spec $aptrn)))
)


(= (candidatePattern $dbspace $spezspace $minsup $cndpspace)
    (match $spezspace (SpecializationOf $specialized $pattern)
        (let* (
                ( $specializedvar (replacev $specialized))
                ($result (sup-eval $dbspace $specializedvar $minsup))
            )
        (if $result
            (add-atom $cndpspace (CandidatePattern $specialized))
            $result
        ))))

! (import! &self conj-exp)

 ; The starting point for the conjunction expansion. It passes
 ; the Alpha Converted pattern (if necessary) to the expand_conjunction functions.
 ; if it passes the minimum variable check

(= (expand_conjunction $cnjtion $pattern $db $ms $mv $es)
    (if $es
        (expand_conjunctin_es_rec $cnjtion $pattern $db $ms)
        (expand_conjunction_rec $cnjtion $pattern $db $ms)
    )
)

(= (count-atom-element $atom) (if (== $atom ()) 0 (+ 1 (count-atom-element (cdr-atom $atom)))))

(= (get_variables_for_tree $pattern)
    (if (== $pattern ()) ()
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
                    (get_variables_for_tree $tail))))))


(= (get_variable_for_pattern $pattern)
    (case ($pattern) (
            ( (()) ())
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
        (concatTuple $subx $suby)))
( ( ($link $x))
    (let* (
            ( $subx (if ( == ( get-metatype $x ) Expression) (get_variable_for_pattern $x) (get_variable_for_pattern ($x)))))
    $subx)))))

(= (substitute $pattern $variables)
    (case ($pattern $variables) (
            ( ( () $variables) ())
            ( ( ($x) $variables)
                (if (== (get-metatype $x) Variable)
                    (if (== $variables ())
                        ($x $variables)
                        ( (car-atom $variables) (cdr-atom $variables)) 
                    )
                ($x $variables) ;; Not actually a variable
            ))
    ( (  ($link $x $y) $variables)
        (let* (
                ( ($sublink $remains) (if ( == ( get-metatype $link ) Expression) (substitute $link $variables) (substitute ($link) $variables)))
                ( ($subx $remaining) (if ( == ( get-metatype $x ) Expression) (substitute $x $remains) (substitute ($x) $remains)))
                ( ($suby $final) (if (== (get-metatype $y) Expression) (substitute $y $remaining) (substitute ($y) $remaining)))
            )
        ( ($sublink $subx $suby) $final)))

( ( ($link $x) $variables)
    (let* (
            ( ($sublink $remains) (if ( == ( get-metatype $link ) Expression) (substitute $link $variables) (substitute ($link) $variables)))
            ( ($subx $remaining) (if ( == ( get-metatype $x ) Expression) (substitute $x $remains) (substitute ($x) $remains))))
    ( ($sublink $subx) $remaining))))))


 ;############################################################
 ;###############   alpha convert  ###########################
 ;############################################################

(= (alpha_convert  $pattern_vars $cnjtion_vars)
    (extract_values (consolidate_keys (address_conflict $pattern_vars $cnjtion_vars))))

(= (address_conflict $pattern_vars $cnjtion_vars)
    (if (== $pattern_vars ())
        ()
        (let* (
                ($head (car-atom $pattern_vars))
                ($tail (cdr-atom $pattern_vars)))
            (if (does_exist $head $cnjtion_vars)
                (concatTuple ( ($head (generateRandomVar))) (address_conflict $tail $cnjtion_vars ))
                (concatTuple ( ($head $head)) (address_conflict $tail $cnjtion_vars))))))

(= (does_exist $var $list_vars)
    (if (== $list_vars ())
        False
        (if (== $var (car-atom $list_vars))
            True
            (does_exist $var (cdr-atom $list_vars)))
    )
)

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
            (extract_helper $tail (cons-atom (car-atom $value) $values)))))


 ;#############################################################
 ;############   alpha convert end  ###########################
 ;#############################################################

(= (expand_conjunction_rec $cnjtion $apat $db $ms)
    (let $npat (expand_conjunction_connect $cnjtion $apat (get_variable_for_pattern $cnjtion) (get_variable_for_pattern $apat))
         (checker $db $npat $ms)))

(= (expand_conjunction_connect $cnjtion $pattern $cv $pv)
    (let $list (replace_pattern $cnjtion $pattern (combine_lists $cv $pv))
        $list))

(= (replace_pattern $cnjtion $pattern ())
    ())

(= (replace_pattern $cnjtion $pattern $pv2cv)
    (let* (
            ($sup (superpose $pv2cv))
            ($exp (substitute $pattern $sup))
            ($new_cnjtion (, $cnjtion (car-atom $exp))))
        $new_cnjtion))

(= (checker $db $pattern $ms) 
    (if (sup-eval $db $pattern $ms)
        $pattern
        empty))

(= (remove_alpha_similar $list)
    (remove_alpha_similar_helper $list ()))

(= (remove_alpha_similar_helper ($listHead $listTail) $seen_list)
    (if (== $listTail ())
        ()
        (let* (
                ($matched (collapse (match &self $listHead $listHead)))
                ($seen_list_new (concatTuple ($matched) $seen_list)))
            (if (or (== $matched ()) (does_exist $matched $seen_list)) ;(or (== $matched ()) )but supp evaluation will check this
                (remove_alpha_similar_helper $listTail $seen_list)
                ( $listHead (remove_alpha_similar_helper $listTail $seen_list_new))))))

(= (expand_conjunction_es_rec $cnjtion $apat $db $ms)
    (pass))

(= (remove_conjuncts_with_redundant_clauses $conjunction) 
    (let* (
        ($conjuncts (get-conjuncts $conjunction))
        ($unique_conjuncts (unique-atom $conjuncts)))
    (if (== (size-atom $conjuncts) (size-atom $unique_conjuncts))
        $conjunction
        ())))


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
===================================end utils =================================================
;;function name: abstract-pattern
        ; Gets Abstract Patterns with Minimum Support so that we can use them for the specialization.

        ; parameters:
            ; $dbspace: the database that is loaded and cleaned of the stdlib functions.
            ; $minsup: minimum support to check if the abstract pattern exceeds or equals this value
            ; $aptrnspace: a space to store abstract patterns
        
;         steps:
    ;         1:Query the database to retrieve all link nodes (nodes that connect other nodes)
    ;         2:Take only the unique links from the queried links
    ;         3:Create an Abstract pattern using the links and variables
    ;         4:Calculate the support for the Abstract patterns and store the ones satisfy the minimum support in a space

; (= (abstract-pattern $dbspace $minsup $aptrnspace)
;             (let* (
;                     ($linkunique (unique (match $dbspace ($link $x $y) $link)))
;                     ($result (sup-eval $dbspace ($linkunique $z $t) $minsup))
;                 )
;             (if (== $result True)
;                 (superpose (
;                         (remove-atom $aptrnspace (AbstractPattern ($linkunique Z (S Z))))
;                         (add-atom $aptrnspace (AbstractPattern ($linkunique Z (S Z))))
;                     ))
;             empty
;         )
; )

; )

(= (abstract-pattern $dbspace $minsup $aptrnspace)        
 (let $linkunique (unique (match $dbspace ($link $x $y) $link))
                       ( let True (sup-eval $dbspace ($linkunique $z $t) $minsup)
                         (add-atom $aptrnspace (AbstractPattern ($linkunique Z (S Z)))))))



; function name: do-conjunct
                    ; function to expand the conjunctions of the patterns and create conjunctions of any amount of clauses

                    ; parameters:
                        ; $db: the database that is loaded and cleaned of the stdlib functions.
                        ; $cndb: the candidate patterns space
                        ; $conjunct: the conjunctions part of the pattern
                        ; $ms: minimum support
                        ; (S $K)/ Z: a debruijin index to check if we are in the last iteration of the recursion.

                    ;steps:
                        ; 1: get the matches of the candidate patterns in the database
                        ; 2: expand the conjunctions with the matches and the database
                        ; 3: replace the variables with the debruijin index
                        ; 4: remove any redundant clauses from the conjunctions
                        ; 5: if we are in the last iteration of the recursion, return the conjunctions else call the function again with the new conjunctions and the debruijin index.
                    
                    ; returns:
                        ; a superpose of conjunctions that satisfy the minimum support and are not redundant.



(= (do-conjunct $db $cndb $coming_conj  $ms Z)
    (let* (
     
        ($conjunct (replacev $coming_conj))
        (() (println! (here  $conjunct)))
        ($matches (match $cndb (CandidatePattern $pattern) (replacev $pattern)))
        ($listconj (expand_conjunction $conjunct $matches $db $ms 2 False))
        ($debconj (replace $listconj))
        ($fitlered (remove_conjuncts_with_redundant_clauses $debconj))
         (() (println! (current conj2 $conj)))
    )
    $fitlered
    )
)

(= (do-conjunct $db $cndb $coming_conj $ms (S $K))
    (let* (
        ($conjunct (replacev $coming_conj))
        ($matches (match $cndb (CandidatePattern $pattern) (replacev $pattern)))
        ($listconj (expand_conjunction $conjunct $matches $db $ms 2 False))
        ($debconj (replace $listconj))
        ($fitlered (remove_conjuncts_with_redundant_clauses $debconj))
        ($varconj (replacev $fitlered))
        ($conj (do-conjunct $db $cndb $varconj $ms $K))
        (() (println! (current conj $conj)))
    )
    $conj
    )
)

; function name: formatter
                    ; function to format the patterns and add them to the knowledge base with their support.

                    ; parameters:
                        ; $kb: the knowledge base
                        ; $conjspace: the space that stores the conjunctions of the patterns
                        ; $dbspace: the database

                    ;steps:
                        ; 1: get the matches of the conjunctions in the database
                        ; 2: sort the conjunctions with a custom sorting function and get only the unique conjunctions from the sorte results
                        ; 3: create a flattened conjunction  using cons-atom with the sorted conjunctions and ,.
                        ; 4: add the results to the knowledge base with their support

; (= (formatter $kb $conjspace $dbspace) 
;     (let* (
;         (() (println! (inforamter)))
;         (() (println! (match $conjspace $pattern (sort_conj $pattern))))
;         ($sorted (unique (match $conjspace $pattern (sort_conj $pattern))))
;         ($res (cons-atom , $sorted)) 
;         ($dummy (collapse (add-atom $kb (supportOf $res (sup-num $dbspace (replacev $res)))))) 
;     )()
    
; )
; )
; (= (add-formatted-to-space $kb  $dbspace $atom  ) (
;    let $var  (cons-atom , $atom) (add-reduct $kb (supportOf  $var (sup-num $dbspace (replacev $var))))
; ))

; (= (formatter $kb $conjspace $dbspace) 
;     (let  $sorted (collapse (unique (match $conjspace $pattern (sort_conj $pattern))))
;                  (add-formatted-to-space $kb $dbspace (superpose $sorted) )             
; )
; )

(= (add-formatted-to-space $kb  $dbspace $atom  ) (
   let $var  (cons-atom , $atom) (add-reduct $kb (supportOf  $var (sup-num $dbspace (replacev $var))))
))

(= (formatter $kb $conjspace $dbspace) 
    (let  $sorted  (unique-atom (collapse (match $conjspace $pattern $sorted)))  $sorted
                              
)
)
; function name: frequency-pattern-miner
                    ; function to mine the frequent patterns from the database.

                    ; parameters:
                        ; $kb: the knowledge base
                        ; $dbspace: the database
                        ; $specspace: the space that stores the specialized patterns
                        ; $cndpspace: the space that stores the candidate patterns
                        ; $aptrnspace: the space that stores the abstract patterns
                        ; $conjspace: the space that stores the conjunctions of the patterns
                        ; $minsup: minimum support to check if the pattern exceeds or equals this value
                        ; $depth: a debruijin index to pass to do-conjunct function.

                    ;steps:
                        ; 1: get all abstract patterns with their support and store them in a space
                        ; 2: specialize the abstract patterns and store them in a space
                        ; 3: get all candidate patterns from the specialized patterns and store them in a space
                        ; 4: expand the conjunctions of the candidate patterns and store them in a space with their support
                        ; 5: format the patterns and add them to the knowledge base with their support


; (= (frequency-pattern-miner $kb $dbspace $specspace $cndpspace $aptrnspace $conjspace $minsup $depth)
;     (superpose (
;             (abstract-pattern $dbspace $minsup $aptrnspace) ; prevent patterns that dont have a support from being speciallized
;             (match $aptrnspace (AbstractPattern $pattern) (build-specialization $pattern $dbspace $specspace)) ; specializa abstract patterns
;             (candidatePattern $dbspace $specspace $minsup $cndpspace); get candidate patterns
;             (match $cndpspace (CandidatePattern $pattern) (let $conj (do-conjunct $dbspace $cndpspace (replacev $pattern) $minsup (fromNumber $depth)) (if (== $conj ()) () (add-atom $conjspace $conj)))) ; store candidate patterns
;             ; (match &conjspace $pattern (superpose ((add-atom &conjspace (supportOf $pattern (sup-num $dbspace (replacev $pattern)))) (remove-atom &conjspace $pattern))))
;             (formatter $kb $conjspace $dbspace)
;         ))
; )


(= (frequency-pattern-miner $kb $dbspace $specspace $cndpspace $aptrnspace $conjspace $minsup $depth)
    (let*(
            (() (abstract-pattern $dbspace $minsup $aptrnspace)) ; prevent patterns that dont have a support from being speciallized
            ($var (collapse (match $aptrnspace (AbstractPattern $pattern) (build-specialization $pattern $dbspace $specspace)))) ; specializa abstract patterns
            ($temp2 (collapse (candidatePattern $dbspace $specspace $minsup $cndpspace))); get candidate patterns
             ($temp3 (collapse (match $cndpspace (CandidatePattern $pattern)
                   (let $conj (do-conjunct $dbspace $cndpspace  $pattern $minsup (fromNumber $depth)) 
                             (if (== $conj ()) () (add-atom $conjspace $conj)))))) ; store candidate patterns
              ;($temp4 (collapse (formatter $kb $conjspace $dbspace)))
        ) 
        (var $temp4))
)

;  ! (abstract-pattern &dbspace 2 &aptrnspace)
;  ! (match &aptrnspace (AbstractPattern $pattern) $pattern)


; ! (frequency-pattern-miner &kb &dbspace &specspace &cndpspace &aptrnspace &conjspace 5 0)
; ! (match  &kb $pattern $pattern)
