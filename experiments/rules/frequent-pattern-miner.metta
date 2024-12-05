! (register-module! ../../../hyperon-miner)
! (import! &dbspace hyperon-miner:experiments:data:sample-data)
! (import! &self hyperon-miner:experiments:rules:build-specialization)
! (import! &self hyperon-miner:experiments:rules:candidate_patterns)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (bind! &specspace (new-space))
! (bind! &cndpspace (new-space))
! (bind! &aptrnspace (new-space))
! (import! &self freq-pat)

(= (apriori $dbspace $minsup $aptrnspace)
    (match $dbspace ($link $x $y)
        (let $result (sup-eval $dbspace ($link $z $t) $minsup)
            (if (== $result True)
                (superpose (
                        (remove-atom $aptrnspace (AbstractPattern ($link Z (S Z))))
                        (add-atom $aptrnspace (AbstractPattern ($link Z (S Z))))
                    ))
            empty
        )
)
)
)
(= (frequency-pattern-miner $dbspace $specspace $cndpspace $aptrnspace $minsup )
    (superpose (
            (apriori $dbspace $minsup $aptrnspace)
            (match $aptrnspace (AbstractPattern $pattern) (build-specialization $pattern $dbspace $specspace))
            (candidatePattern $dbspace $specspace $minsup $cndpspace)
        ))
)

 ; ! (apriori &dbspace 2 &aptrnspace)

! (frequency-pattern-miner &dbspace &specspace &cndpspace &aptrnspace 2)

! (match &dbspace (: $p ($link $x $y)) $p)