;!(register-module! ../../../hyperon-miner)
;!(import! &dbspace hyperon-miner:experiments:data:sample-data)
;!(import! &self hyperon-miner:experiments:rules:valuation-set)
;!(bind! &shabspace (new-space))
;!(bind! &valspace (new-space))

;; Function to retrive shallow abstraction over all variables of a pattern from a valuation space
(= (shallow-abstraction $valspace $shabspace)
   (superpose ((collapse(match $valspace (ValuationOf X $z) (add-atom $shabspace (ShallowAbstractionOf X $z))))
    (collapse(match $valspace (ValuationOf Y $t) (add-atom $shabspace (ShallowAbstractionOf Y $t))))
    )
  )
)
