! (register-module! ../../../hyperon-miner)
! (import! &dbspace hyperon-miner:experiments:data:ugly_man_sodaDrinker) ;; db changed for testing
! (import! &self hyperon-miner:experiments:rules:build-specialization)
! (import! &self hyperon-miner:experiments:rules:candidate-patterns)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (bind! &specspace (new-space))
! (bind! &cndpspace (new-space))
! (bind! &aptrnspace (new-space))
! (import! &self freq-pat)

;steps 
; 1. get abstract patterns that have minimum support
; 2. specializa abstract patterns
; 3. get candidate patterns
; 4. store candidate patterns


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

! (frequency-pattern-miner &dbspace &specspace &cndpspace &aptrnspace 10)
;! (match &specspace $x $x)
! (match &cndpspace $x $x)
 ; ! (match &dbspace (: $p ($link $x $y)) $p)
 ; ! (match &dbspace $x (if (not (== (get-type $x) hyperon::space::DynSpace)) $x ()))


 
(CandidatePattern (Inheritance Z man)), (CandidatePattern (Inheritance Z human)), (CandidatePattern (Inheritance Rio Z)), (CandidatePattern (Inheritance Hessley Z)), (CandidatePattern (Inheritance Z sodaDrinker)), (CandidatePattern (Inheritance Davion Z)), (CandidatePattern (Inheritance Jadrian Z)), (CandidatePattern (Inheritance Sophia Z)), (CandidatePattern (Inheritance Cason Z)), (CandidatePattern (Inheritance Alaura Z)), (CandidatePattern (Inheritance Allen Z)), (CandidatePattern (Inheritance Abe Z)), (CandidatePattern (Inheritance Jassy Z)), (CandidatePattern (Inheritance Breonna Z)), (CandidatePattern (Inheritance Zac Z)), (CandidatePattern (Inheritance Bob Z)), (CandidatePattern (Inheritance Z ugly)), (CandidatePattern (Inheritance Mike Z)), (CandidatePattern (Inheritance Jaleesa Z)), (CandidatePattern (Inheritance Emily Z)), (CandidatePattern (Inheritance Kecia Z)), (CandidatePattern (Inheritance Jenica Z)), (CandidatePattern (Inheritance Lucy Z)), (CandidatePattern (Inheritance Z woman)), (CandidatePattern (Inheritance Lily Z))
