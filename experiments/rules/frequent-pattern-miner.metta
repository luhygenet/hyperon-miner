! (register-module! ../../../hyperon-miner)
! (import! &dbspace hyperon-miner:experiments:data:sample-data)
! (import! &self hyperon-miner:experiments:rules:valuation-set)
! (import! &self hyperon-miner:experiments:rules:shallow-abstraction)
! (import! &self hyperon-miner:experiments:rules:specialization)
! (import! &self hyperon-miner:experiments:rules:candidate-patterns)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (bind! &shabspace (new-space))
! (bind! &valspace (new-space))
! (bind! &spezspace (new-space))
! (bind! &cndpspace (new-space))

(= (depth)(fromNumber 1))

!(add-atom &cndpspace (CandidatePattern (Inheritance $x $y)))

(= (init-miner $dbspace $valspace $shabspace $spezspace $cndpspace $minsup $link $x $y)(
    (superpose(
    (valuation-set $link $x $y &dbspace &valspace)
    (shallow-abstraction X Y &valspace &shabspace)
    (specialize-pattern $link $x $y $shabspace $spezspace)
    (candidate-pattern $dbspace $spezspace $minsup $cndpspace)
    ))
    )
)
(= (run-miner $cndpspace Z)(
    match $cndpspace (CandidatePattern ($link $x $y)) (init-miner &dbspace &valspace &shabspace &spezspace &cndpspace 2 $link $x $y)
    )
)

(= (run-miner $cndpspace (S $k))(
    superpose(
        (run-miner $cndpspace Z)
        (run-miner $cndpspace $k)
    )
    )
)

!(run-miner &cndpspace (depth))

!(match &cndpspace $h $h)
;!(match &spezspace (SpecializationOf $x $y) (SpecializationOf $x $y))
