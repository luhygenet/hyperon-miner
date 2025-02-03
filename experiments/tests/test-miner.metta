! (register-module! ../../../hyperon-miner)
;! (import! &dbspace hyperon-miner:experiments:data:sample-data)
! (import! &self hyperon-miner:experiments:rules:valuation-set)
! (import! &self hyperon-miner:experiments:rules:shallow-abstraction)
! (import! &self hyperon-miner:experiments:rules:specialization)
! (import! &self hyperon-miner:experiments:rules:candidate-patterns)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (import! &self hyperon-miner:experiments:rules:mined-patterns)
! (import! &self hyperon-miner:experiments:utils:DeBruijnIndex)
! (import! &self hyperon-miner:experiments:rules:frequent-pattern-miner)

!(bind! &spezspace (new-space))
!(bind! &shabspace (new-space))
!(bind! &valspace (new-space))
!(bind! &dbspace (new-space))
!(bind! &cndpspace (new-space))
!(bind! &minedpspace (new-space))

!(add-atom &dbspace (Inheritance A B))
!(add-atom &dbspace (Inheritance A C))
!(add-atom &dbspace (Inheritance C B))
!(add-atom &dbspace (Inheritance A C))
!(add-atom &dbspace (Inheritance D B))
!(add-atom &dbspace (Inheritance D A))


;; Assert that total number of valuations/bindings for pattern 'Inheritance $x $y' from the above &dbspace is 6.
;!(valuation-set Inheritance $x $y &dbspace &valspace)
;!(assertEqual (counter &valspace (ValuationOf $x $y)) 6)

;; Assert that total number of valuations/bindings for pattern 'Inheritance A $y' from the above &dbspace is 3.
;!(valuation-set Inheritance A $y &dbspace &valspace)
;!(assertEqual (counter &valspace (ValuationOf $x $y)) 3)

;; Assert that total number of specializations for the pattern 'Inheritance $x $y' from the above &dbspace is 6.
;!(valuation-set Inheritance $x $y &dbspace &valspace)
;!(shallow-abstraction &valspace &shabspace)
;!(specialize-pattern Inheritance $x $y &shabspace &spezspace) 
;!(assertEqual (counter &spezspace (SpecializationOf $x $y)) 6)

;; Assert that total number of candidate patterns for the pattern 'Inheritance $x $y' from the above &dbspace is 4.
;!(valuation-set Inheritance $x $y &dbspace &valspace)
;!(shallow-abstraction &valspace &shabspace)
;!(specialize-pattern Inheritance $x $y &shabspace &spezspace) 
;!(candidate-pattern &dbspace &spezspace 2 &cndpspace)
;!(assertEqual (counter &cndpspace (CandidatePattern $x)) 4)

;; Assert the total number of mined patterns for the pattern 'Inheritance $x $y/Inheritance (VarIdx Z) (VarIdx (S Z))' from the above &dbspace is  at depth 0.
(= (depth)(fromNumber 1))
!(add-atom &cndpspace (CandidatePattern (Inheritance (VarIdx Z) (VarIdx (S Z)))))
!(run-miner 2 (depth) &dbspace &valspace &shabspace &spezspace &cndpspace &minedpspace)
!(match &minedpspace $h $h)
!(match &cndpspace $h $h)
