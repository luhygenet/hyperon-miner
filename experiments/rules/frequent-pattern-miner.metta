! (register-module! ../../../hyperon-miner2)
! (import! &dbspace hyperon-miner2:experiments:data:sample-data)
! (import! &self hyperon-miner2:experiments:rules:valuation-set)
! (import! &self hyperon-miner2:experiments:rules:shallow-abstraction)
! (import! &self hyperon-miner2:experiments:rules:specialization)
! (import! &self hyperon-miner2:experiments:rules:candidate-patterns)
! (import! &self hyperon-miner2:experiments:rules:mined-patterns)
! (import! &self hyperon-miner2:experiments:utils:common-utils)
! (import! &self hyperon-miner2:experiments:utils:DeBruijnIndex)
! (bind! &shabspace (new-space))
! (bind! &valspace (new-space))
! (bind! &spezspace (new-space))
! (bind! &cndpspace (new-space))
! (bind! &minedpspace (new-space))

(= (depth)(fromNumber 2))

!(add-atom &cndpspace (CandidatePattern (Inheritance (VarIdx Z) (VarIdx (S Z)))))

(=(remove-specd-pats $minedpspace $cndpspace $pat)(
        match $minedpspace (MinedPattern $pat)(remove-atom $cndpspace $pat)
    )
)

(= (cleanup-spaces $valspace $shabspace $spezspace)(
    superpose(
        (match $valspace (ValuationOf $x $y)(remove-atom $valspace (ValuationOf $x $y)))
        (match $shabspace (ShallowAbstractionOf $x $y)(remove-atom $shabspace (ShallowAbstractionOf $x $y)))
        (match $spezspace (SpecializationOf $x $y)(remove-atom $spezspace (SpecializationOf $x $y)))
        )
    )
)

(=(cleanup-cnd-spec $cndpspace)(
    match $cndpspace (CandidatePattern ($link $x $y))(remove-atom $cndpspace (CandidatePattern ($link $x $y)))
    )
)

(= (init-miner $minsup $link $x $y)(
    (superpose(
    (let ($link1 $s $t) (Debruijn2var ($link $x $y) (Cons $Xvar (Cons $Yvar Nil))) (valuation-set $link1 $s $t &dbspace &valspace))
    (shallow-abstraction &valspace &shabspace)
    (let ($link1 $s $t) (Debruijn2var ($link $x $y) (Cons $Xvar (Cons $Yvar Nil))) (specialize-pattern $link1 $s $t &shabspace &spezspace))
    (cleanup-cnd-spec &cndpspace)
    (candidate-pattern &dbspace &spezspace $minsup &cndpspace)
    (add-mined-pattern &minedpspace &cndpspace)
    (match &cndpspace (CandidatePattern ($link $x $y))(remove-specd-pats &minedpspace &cndpspace (CandidatePattern ($link $x $y))))
    (cleanup-spaces &valspace &shabspace &spezspace)
    ))
    )
)

(= (run-miner Z)(
    match &cndpspace (CandidatePattern ($link $x $y)) (init-miner 2 $link $x $y)
    )
)

(= (run-miner (S $k))(
    superpose(
        (run-miner Z)
        (run-miner $k)
    )
)

)

!(run-miner (depth))
!(match &cndpspace $h $h)
!(match &minedpspace $h $h)
