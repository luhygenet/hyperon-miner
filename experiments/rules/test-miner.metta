! (register-module! ../../../hyperon-miner)
! (import! &dbspace hyperon-miner:experiments:data:sample-data)
! (import! &self hyperon-miner:experiments:rules:valuation-set)
! (import! &self hyperon-miner:experiments:rules:shallow-abstraction)
! (import! &self hyperon-miner:experiments:rules:specialization)
! (import! &self hyperon-miner:experiments:rules:candidate-patterns)
! (import! &self hyperon-miner:experiments:utils:common-utils)

!(bind! &spezspace (new-space))
!(bind! &shabspace (new-space))
!(bind! &valspace (new-space))


;; Assert that total valuations for pattern 'Inheritance $x $y' is 9.
;!(valuation-set Inheritance $x $y &dbspace &valspace)
;!(assertEqual (counter &valspace (ValuationOf $x $y)) 9)

;; Assert that total valuations for pattern 'Inheritance A $y' is 4.
!(valuation-set Inheritance A $y &dbspace &valspace)
!(assertEqual (counter &valspace (ValuationOf $x $y)) 4)

