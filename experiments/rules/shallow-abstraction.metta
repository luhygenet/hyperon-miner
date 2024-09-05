;!(register-module! ../../../hyperon-miner)
;!(import! &dbspace hyperon-miner:experiments:data:sample-data)
;!(import! &self hyperon-miner:experiments:rules:valuation-set)
;!(bind! &shabspace (new-space))
;!(bind! &valspace (new-space))

;; Function to retrive shallow abstraction over all variables of a pattern from a valuation space
(= (shallow-abstraction $x $y $valspace $shabspace)

   (superpose ((collapse(match $valspace (ValuationOf $x $z) (add-atom $shabspace (ShallowAbstractionOf $x $z))))
    (collapse(match $valspace (ValuationOf $y $t) (add-atom $shabspace (ShallowAbstractionOf $y $t))))
    (let $t (match $valspace (, (ValuationOf $x $c) (ValuationOf $y $c)) True) (if (== $t True) (add-atom $shabspace (ShallowAbstractionOf $x $y)) Empty))
    ) 
  )
)
