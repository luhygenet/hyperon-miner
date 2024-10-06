! (register-module! ../../../hyperon-miner)
! (import! &dbspace hyperon-miner:experiments:data:sample-data)
! (import! &self hyperon-miner:experiments:rules:valuation-set)
! (import! &self hyperon-miner:experiments:rules:shallow-abstraction)
! (import! &self hyperon-miner:experiments:rules:specialization)
! (import! &self hyperon-miner:experiments:rules:candidate-patterns)
! (import! &self hyperon-miner:experiments:rules:mined-patterns)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (import! &self hyperon-miner:experiments:utils:DeBruijnIndex)
! (bind! &shabspace (new-space))
! (bind! &valspace (new-space))
! (bind! &spezspace (new-space))
! (bind! &cndpspace (new-space))
! (bind! &minedpspace (new-space))

(= (depth) (fromNumber 1))

! (add-atom &cndpspace (CandidatePattern (Inheritance (VarIdx Z) (VarIdx (S Z)) )))

(= (cleanup-spaces $valspace $shabspace $spezspace) (
        superpose (
            (match $valspace (ValuationOf $x $y) (remove-atom $valspace (ValuationOf $x $y)))
            (match $shabspace (ShallowAbstractionOf $x $y) (remove-atom $shabspace (ShallowAbstractionOf $x $y)))
            (match $spezspace (SpecializationOf $x $y) (remove-atom $spezspace (SpecializationOf $x $y)))
        )
)
)

(= (init-miner $minsup $link $x $y $dbspace $valspace $shabspace $spezspace $cndpspace $minedpspace) (
        (superpose (
                (let ($link1 $s $t) (Debruijn2var ($link $x $y) (Cons $Xvar (Cons $Yvar Nil))) (valuation-set $link1 $s $t $dbspace $valspace))
                (shallow-abstraction $valspace $shabspace)
                (let ($link1 $s $t) (Debruijn2var ($link $x $y) (Cons $Xvar (Cons $Yvar Nil))) (specialize-pattern $link1 $s $t $shabspace $spezspace))
                (remove-atom $cndpspace (CandidatePattern ($link $x $y)))
                (candidate-pattern $dbspace $spezspace $minsup $cndpspace)
                (add-mined-pattern $minedpspace $cndpspace)
                (cleanup-spaces $valspace $shabspace $spezspace)
            ))
)
)

(= (run-miner $minsup Z $dbspace $valspace $shabspace $spezspace $cndpspace $minedpspace) (
        let ($link $x $y) (match $cndpspace (CandidatePattern ($link $x $y)) ($link $x $y)) (init-miner $minsup $link $x $y $dbspace $valspace $shabspace $spezspace $cndpspace $minedpspace)
    )
)

(= (run-miner $minsup (S $k) $dbspace $valspace $shabspace $spezspace $cndpspace $minedpspace) ( (superpose (
                (let ($link $x $y) (match $cndpspace (CandidatePattern ($link $x $y)) ($link $x $y)) (init-miner $minsup $link $x $y $dbspace $valspace $shabspace $spezspace $cndpspace $minedpspace))
                (run-miner $minsup $k $dbspace $valspace $shabspace $spezspace $cndpspace $minedpspace)))
    )
)

! (run-miner 2 (depth) &dbspace &valspace &shabspace &spezspace &cndpspace &minedpspace)
! (match &cndpspace $h $h)
! (match &minedpspace $h $h)
