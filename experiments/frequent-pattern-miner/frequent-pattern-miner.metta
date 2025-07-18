
! (import! &self build-specialization)
! (import! &self candidate-patterns)
! (import! &self conjunction-expansion)

! (import! &self freq-pat)
! (import! &self conj-exp)



(= (abstract-pattern $dbspace $minsup $aptrnspace)        
 (let $linkunique (unique (match $dbspace ($link $x $y) $link))
                       ( let True (sup-eval $dbspace ($linkunique $z $t) $minsup)
                         (add-atom $aptrnspace (AbstractPattern ($linkunique Z (S Z)))))))







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




(= (frequency-pattern-miner $kb $dbspace $specspace $cndpspace $aptrnspace $conjspace $minsup $depth)
    (let*(
            (() (abstract-pattern $dbspace $minsup $aptrnspace)) ; prevent patterns that dont have a support from being speciallized
            ($var  (collapse (match $aptrnspace (AbstractPattern $pattern) (build-specialization $pattern $dbspace $specspace)))) ; specializa abstract patterns
            ($temp2  (collapse (candidatePattern $dbspace $specspace $minsup $cndpspace))); get candidate patterns
             ($temp3  (collapse (conjunct $dbspace $cndpspace $conjspace $minsup $depth ))) ; store candidate patterns
            ($temp4   (formatter $kb $conjspace $dbspace))
              
        ) 
        ())
)

