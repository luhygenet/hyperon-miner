; ! (register-module! ../../../hyperon-miner)
; ; ! (import! &dbspace hyperon-miner:experiments:data:sample-data)
; ! (import! &db hyperon-miner:experiments:data:ugly_man_sodaDrinker)
! (import! &self build-specialization)
! (import! &self candidate-patterns)
! (import! &self conjunction-expansion)
;! (import! &self formatter)

; ! (import! &self hyperon-miner:experiments:utils:common-utils)
; ! (bind! &kb (new-space))
; ! (bind! &dbspace (new-space))
; ! (bind! &specspace (new-space))
; ! (bind! &cndpspace (new-space))
; ! (bind! &aptrnspace (new-space))
; ! (bind! &conjspace (new-space))
! (import! &self freq-pat)
! (import! &self conj-exp)

; !(let ($link $x $y) (get-atoms &db) (add-atom &dbspace ($link $x $y)))



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
;                      (() (println! (in abst)))
;                     ($linkunique (unique (match $dbspace ($link $x $y) $link)))
;                     ($result (sup-eval $dbspace ($linkunique $z $t) $minsup))
;                 )
;             (if  $result
;                 (superpose (
;                         (remove-atom $aptrnspace (AbstractPattern ($linkunique Z (S Z))))
;                         (add-reduct $aptrnspace (AbstractPattern ($linkunique Z (S Z))))
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
                        4: add the results to the knowledge base with their support

; (= (add-formatted-to-space $kb  $dbspace $atom  ) (
;    let $var  (cons-atom , $atom) (add-reduct $kb (supportOf  $var (sup-num $dbspace (replacev $var))))
; ))

; (= (formatter $kb $conjspace $dbspace) 
;     (let  $sorted (collapse (unique (match $conjspace $pattern (sort_conj $pattern))))
;                  (add-formatted-to-space $kb $dbspace (superpose $sorted) )             
; )
; )


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
;             (println! (in superopose))
;             (abstract-pattern $dbspace $minsup $aptrnspace) ; prevent patterns that dont have a support from being speciallized
;             (match $aptrnspace (AbstractPattern $pattern) (build-specialization $pattern $dbspace $specspace)) ; specializa abstract patterns
;             (candidatePattern $dbspace $specspace $minsup $cndpspace); get candidate patterns
;             (match $cndpspace (CandidatePattern $pattern) (let $conj (do-conjunct $dbspace $cndpspace (replacev $pattern) $minsup (fromNumber $depth)) (if (== $conj ()) () (add-atom $conjspace $conj)))) ; store candidate patterns
;             ; (match &conjspace $pattern (superpose ((add-atom &conjspace (supportOf $pattern (sup-num $dbspace (replacev $pattern)))) (remove-atom &conjspace $pattern))))
;             (formatter $kb $conjspace $dbspace)
;         ))
; )

; (= (formatter $kb $conjspace $dbspace) 
;     (let* (
;         ($sorted (unique (match $conjspace $pattern (sort_conj $pattern))))
;         (() (println! (inforamter $sorted)))

;         ($res (cons-atom , $sorted)) 
;         ($dummy (collapse (add-atom $kb (supportOf $res (sup-num $dbspace (replacev $res)))))) 
;     )()

; )
; )

(= (frequency-pattern-miner $kb $dbspace $specspace $cndpspace $aptrnspace $conjspace $minsup $depth)
    (let*(
            (() (abstract-pattern $dbspace $minsup $aptrnspace)) ; prevent patterns that dont have a support from being speciallized
            ($var  (collapse (match $aptrnspace (AbstractPattern $pattern) (build-specialization $pattern $dbspace $specspace)))) ; specializa abstract patterns
            ($temp2  (collapse (candidatePattern $dbspace $specspace $minsup $cndpspace))); get candidate patterns
             ($temp3  (collapse (conjunct $dbspace $cndpspace $conjspace $minsup $depth ))) ; store candidate patterns
           
           ($temp4   (formatter $kb $conjspace $dbspace))
              
        ) 
        (var $temp4))
)

;  ! (abstract-pattern &dbspace 2 &aptrnspace)
;  ! (match &aptrnspace (AbstractPattern $pattern) $pattern)


; ! (frequency-pattern-miner &kb &dbspace &specspace &cndpspace &aptrnspace &conjspace 5 0)
; ! (match  &kb $pattern $pattern)
