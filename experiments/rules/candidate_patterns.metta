 ;; Rule to specialization a pattern
! (register-module! ../../../hyperon-miner)
! (import! &dbspace hyperon-miner:experiments:data:sample-data)
! (import! &self hyperon-miner:experiments:rules:build-specialization)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (bind! &specspace (new-space))
! (bind! &cndpspace (new-space))
! (import! &self freq-pat)

(= (candidatePattern $dbspace $spezspace $minsup $cndpspace)
    (match $spezspace (SpecializationOf $specialized $pattern)
        (let* (
                ( $specializedvar (replacev $specialized))
                ($result (sup-eval $dbspace $specializedvar $minsup))
            )
        (if (== $result True)
            (add-atom $cndpspace (CandidatePattern $specialized))
            $result
        )

)
 ; (let $result (counter $dbspace $specialized)
 ;     $result
 ; )
 ;     $specialized
)

)

! (build-specialization (Inheritance Z (S Z)) &dbspace &specspace)

 ; ! (match &specspace (SpecializationOf $x $y) ( $x))

! (candidatePattern &dbspace &specspace 2 &cndpspace)

! (match &cndpspace $h $h)
