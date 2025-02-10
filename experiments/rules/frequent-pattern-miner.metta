! (register-module! ../../../hyperon-miner)
! (import! &dbspace hyperon-miner:experiments:data:sample-data)
! (import! &self hyperon-miner:experiments:rules:build-specialization)
! (import! &self hyperon-miner:experiments:rules:candidate-patterns)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (bind! &specspace (new-space))
! (bind! &cndpspace (new-space))
! (bind! &aptrnspace (new-space))
! (import! &self freq-pat)


; apriori propertie to prevent patterns that dont have a support from being speciallized
(= (apriori $dbspace $minsup $aptrnspace)
    (match $dbspace $atom
        (if (not (== (get-type $atom) hyperon::space::DynSpace))
            (let* (
                    ( ($link $x $y) $atom)
                    ($result (sup-eval $dbspace ($link $z $t) $minsup))
                )
            (if (== $result True)
                (superpose (
                        (remove-atom $aptrnspace (AbstractPattern ($link Z (S Z))))
                        (add-atom $aptrnspace (AbstractPattern ($link Z (S Z))))
                    ))
            empty
        )
)
empty
)
)
)

; miner
(= (frequency-pattern-miner $dbspace $specspace $cndpspace $aptrnspace $minsup )
    (superpose (
            (apriori $dbspace $minsup $aptrnspace) ; prevent patterns that dont have a support from being speciallized
            (match $aptrnspace (AbstractPattern $pattern) (build-specialization $pattern $dbspace $specspace)) ; specializa abstract patterns
            (candidatePattern $dbspace $specspace $minsup $cndpspace); get candidate patterns
        ))
)

 ; ! (apriori &dbspace 2 &aptrnspace)
 ; ! (match &aptrnspace (AbstractPattern $pattern) $pattern)

! (frequency-pattern-miner &dbspace &specspace &cndpspace &aptrnspace 2)
! (match &specspace $x $x)
! (match &cndpspace $x $x)
 ; ! (match &dbspace (: $p ($link $x $y)) $p)
 ; ! (match &dbspace $x (if (not (== (get-type $x) hyperon::space::DynSpace)) $x ()))