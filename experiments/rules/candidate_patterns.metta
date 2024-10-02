 ; Rule to specialization a pattern
! (register-module! ../../../hyperon-miner)
! (import! &dbspace hyperon-miner:experiments:data:sample-data)
 ; ! (import! &dspace hyperon-miner:experiments:data:samplet)
! (import! &self hyperon-miner:experiments:rules:valuation-set)
! (import! &self hyperon-miner:experiments:rules:shallow-abstraction)
! (import! &self hyperon-miner:experiments:rules:specialization)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (bind! &shabspace (new-space))
! (bind! &valspace (new-space))
! (bind! &spezspace (new-space))
! (bind! &cndpspace (new-space))
! (bind! &nspace (new-space))
! (bind! &shalbspace (new-space))
! (bind! &valuspace (new-space))
! (bind! &spezispace (new-space))
! (bind! &cndpsspace (new-space))

(= (candidatePattern $dbspace $spezspace $minsup $cndpspace)
    (superpose (
            (collapse (
                    match $spezspace (SpecializationOf $pattern $specialized)
                    (let $result (sup-eval $dbspace $specialized $minsup)
                        (add-atom $cndpspace $result)
                    )
            )
    )
)
)
)

 ; (= (adder $space $nspace)
 ;     (match $space $pattern (add-atom $nspace (CandidatePattern $pattern)))
 ; )
(= (matcher $space)
    ( let  $result (match $space (CandidatePattern (Inheritance $xval $yval)) ($xval $yval)) $result)
)

(= (process-candidates $cndpspace $dbspace $shabspace $spezspace $valspace $minsup)
    (superpose (
            (collapse (
                    (match &cndpspace (CandidatePattern (Inheritance $xval $yval))
                        (let* ( ( $valu (valuation-set Inheritance $xval $yval &dbspace &valuspace))
                                 ; ( $vals (match &valuspace (ValuationOf $c $d) (ValuationOf $c $d)))
                                ( $shall (shallow-abstraction X Y &valuspace &shalbspace))
                                 ; ( $shal (match &shalbspace (ShallowAbstractionOf $c $d) (ShallowAbstractionOf $c $d)))
                                ( $spec (specialize-pattern Inheritance $xval $yval &shalbspace &spezispace))
                                 ; ( $specs (match &spezispace (SpecializationOf $x $y) (SpecializationOf $x $y)))
                                 ;  ; (remove-atom $cndpspace $pattern)
                                ( $cndp (candidatePattern $dbspace &spezispace $minsup &cndpsspace))
                                ( $cnd (match &cndpsspace $h $h))
                            )
                        $cnd
                         ; Remove the pattern from the candidate space after processing
                    )
            )
    ))
))
)
 ;  ; First, let's run the valuation-set function to populate the &valspace with the valuation sets
! (valuation-set Inheritance $xvalue $yvalue &dbspace &valspace)

 ;; Check if valuation sets are inserted correctly
 ; ! (match &valspace (ValuationOf $c $d) (ValuationOf $c $d))

 ;; let's run the shallow-abstraction function to calculate the shallow abstraction over both variable X and Y
! (shallow-abstraction X Y &valspace &shabspace)

 ;; Check if shallow abstractions are inserted correctly
 ; ! (match &shabspace (ShallowAbstractionOf $c $d) (ShallowAbstractionOf $c $d))

 ;; Let's now run the specialization rule
! (specialize-pattern Inheritance $x $y &shabspace &spezspace)

 ;; Check if the specializations are inserted correctly
 ; ! (match &spezspace (SpecializationOf $x $y) (SpecializationOf $x $y))

! (candidatePattern &dbspace &spezspace 2 &cndpspace)

 ; ! (adder &dbspace &nspace)

 ; ! (match &nspace (CandidatePattern $pattern) $pattern)

 ; ! (match &cndpspace (CandidatePattern (Inheritance $xval $yval)) ($xval $yval))
 ; ! (matcher &cndpspace)
! (process-candidates &cndpspace &dbspace &shabspace &spezspace &valspace 2)
 ; ! (match &cndpsspace $h $h)