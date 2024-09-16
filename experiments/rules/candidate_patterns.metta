 ;; Rule to specialization a pattern
! (register-module! ../../../hyperon-miner)
! (import! &dbspace hyperon-miner:experiments:data:sample-data)
! (import! &self hyperon-miner:experiments:rules:valuation-set)
! (import! &self hyperon-miner:experiments:rules:shallow-abstraction)
! (import! &self hyperon-miner:experiments:rules:specialization)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (bind! &shabspace (new-space))
! (bind! &valspace (new-space))
! (bind! &spezspace (new-space))
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

 ;; First, let's run the valuation-set function to populate the &valspace with the valuation sets
! (valuation-set Inheritance $xvalue $yvalue &dbspace &valspace)

 ;; Check if valuation sets are inserted correctly
! (match &valspace (ValuationOf $c $d) (ValuationOf $c $d))

 ;; let's run the shallow-abstraction function to calculate the shallow abstraction over both variable X and Y
! (shallow-abstraction X Y &valspace &shabspace)

 ;; Check if shallow abstractions are inserted correctly
! (match &shabspace (ShallowAbstractionOf $c $d) (ShallowAbstractionOf $c $d))

 ;; Let's now run the specialization rule
! (specialize-pattern Inheritance $x $y &shabspace &spezspace)

 ;; Check if the specializations are inserted correctly
! (match &spezspace (SpecializationOf $x $y) (SpecializationOf $x $y))

! (candidatePattern &dbspace &spezspace 2 &cndpspace)

! (match &cndpspace $h $h)
