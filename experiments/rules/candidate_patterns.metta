 ;; Rule to specialization a pattern
! (register-module! ../../../hyperon-miner)
! (import! &dbspace hyperon-miner:experiments:data:sample-data)
! (import! &self hyperon-miner:experiments:rules:build-specialization)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (bind! &specspace (new-space))
! (bind! &specredspace (new-space))
! (bind! &cndpspace (new-space))

(= (candidatePattern $dbspace $spezspace $minsup $cndpspace)
    (superpose (
            (collapse (
                    match $spezspace (SpecializationOf $pattern $specialized)
                    (let $result (sup-eval $dbspace $specialized $minsup)
                        (if (== $result True)
                            (add-atom $cndpspace (CandidatePattern $specialized))
                            $result
                        )
                )
        )
)
)
)
)

! (build-specialization Inheritance $x $y &dbspace &specspace &specredspace)

! (candidatePattern &dbspace &specspace 2 &cndpspace)

! (match &cndpspace $h $h)
