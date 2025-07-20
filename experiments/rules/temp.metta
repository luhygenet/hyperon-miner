
; ! (import! &db hyperon-miner:experiments:data:small-ugly)
! (import! &self build-specialization)
! (import! &self candidate-patterns)
! (import! &self conjunction-expansion)
! (import! &self freq-pat)
! (import! &self conj-exp)

! (bind! &specspace (new-space))
! (bind! &cndpspace (new-space))
! (bind! &aptrnspace (new-space))
! (bind! &conjspace (new-space))

; ! (import! &self hyperon-miner:experiments:utils:variable-combinations)


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

(= (abstract-pattern $dbspace $minsup $aptrnspace)
            (let* (  
                    ($linkunique (unique (match $dbspace ($link $x $y) $link)))
                    ($result (sup-eval $dbspace ($linkunique $z $t) $minsup))
                )
            (if  $result 
                (superpose (
                        (remove-atom $aptrnspace (AbstractPattern ($linkunique Z (S Z))))

                        (add-reduct $aptrnspace (AbstractPattern ($linkunique Z (S Z))))
                    ))
            empty
        )
)

)

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



(= (do-conjunct $db $cndb $conjunct $ms Z)
    (let* (
        (() (println! here))
        ($matches (match $cndb (CandidatePattern $pattern) (replacev $pattern)))
        ($listconj (expand_conjunction $conjunct $matches $db $ms 2 False))
        ($debconj (replace $listconj))
        ($fitlered (remove_conjuncts_with_redundant_clauses $debconj))
        (() (println! ("Conjuncts: " $fitlered)))
    )
    $fitlered
    )
)

(= (do-conjunct $db $cndb $conjunct $ms (S $K))
    (let* (
        ($matches (match $cndb (CandidatePattern $pattern) (replacev $pattern)))
        ($listconj (expand_conjunction $conjunct $matches $db $ms 2 False))
        ; (() (println! ("Conjuncts: " $listconj)))
        ($debconj (replace $listconj))
        ($fitlered (remove_conjuncts_with_redundant_clauses $debconj))
        ($varconj (replacev $fitlered))
        (() (println! ("Conjuncts: " $varconj)))
        ($conj (do-conjunct $db $cndb $varconj $ms $K))
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

(= (formatter $kb $conjspace $dbspace) 
    (let* (
        ($sorted (unique (match $conjspace $pattern (sort_conj $pattern))))
        ($res (cons-atom , $sorted))
        
    )
    (add-atom $kb (supportOf $res (sup-num $dbspace (replacev $res))))
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


(= (frequency-pattern-miner $kb $dbspace  $minsup $depth)
    (superpose (
            (abstract-pattern $dbspace $minsup &aptrnspace) ; prevent patterns that dont have a support from being speciallized
            (println! (here in superopose))
            (match &aptrnspace (AbstractPattern $pattern) (build-specialization $pattern $dbspace &specspace)) ; specializa abstract patterns
            (candidatePattern $dbspace &specspace $minsup &cndpspace); get candidate patterns
            (match &cndpspace (CandidatePattern $pattern) (let $conj (do-conjunct $dbspace &cndpspace (replacev $pattern) $minsup (fromNumber $depth)) (if (== $conj ()) () (add-atom &conjspace $conj)))) ; store candidate patterns
            ; (match &conjspace $pattern (superpose ((add-atom &conjspace (supportOf $pattern (sup-num $dbspace (replacev $pattern)))) (remove-atom &conjspace $pattern))))
            (formatter $kb &conjspace $dbspace)
        )) 
)



;  ! (abstract-pattern &dbspace 2 &aptrnspace)
;  ! (match &aptrnspace (AbstractPattern $pattern) $pattern)


; ! (frequency-pattern-miner &kb &dbspace &specspace &cndpspace &aptrnspace &conjspace 5 0)
; ! (match &conjspace $pattern $pattern)
; ! (match &db (, (, (Inheritance $x man) (Inheritance $x ugly)) (Inheritance $x sodaDrinker)) (, (, (Inheritance $x man) (Inheritance $x ugly)) (Inheritance $x sodaDrinker)))
; !(checker &db (, (, (Inheritance $x man) (Inheritance $x ugly)) (Inheritance $x sodaDrinker)) 2)
; !(match &cndpspace (CandidatePattern $pattern) (do-conjunct &dbspace &cndpspace (replacev $pattern) 2 (fromNumber 0)))