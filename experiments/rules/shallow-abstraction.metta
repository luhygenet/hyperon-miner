!(register-module! ../../../hyperon-miner)
!(import! &dbspace hyperon-miner:experiments:data:sample-data)
!(import! &self hyperon-miner:experiments:rules:valuation-set)
!(bind! &shabspace (new-space))
!(bind! &valspace (new-space))

;; Function to retrive shallow abstraction over all variables of a pattern from a valuation space
(= (shallow-abstraction $rel $x $y $db)
(let* (
    (() (match $db (ValuationOf $x $z) (add-atom &shabspace (ShallowAbstractionOf $x $z))))
    (() (match $db (ValuationOf $y $t) (add-atom &shabspace (ShallowAbstractionOf $y $t))))
    )
    (println! "Added shallow abstraction successfully"))
)

;; Testing shallow abstraction

;; First, let's run the valuation-set function to populate the &valspace with the valuation sets
! (valuation-set Inheritance $x $y &dbspace &valspace)

;; Check if valuation sets are inserted correctly
!(match &valspace (ValuationOf $c $d) (ValuationOf $c $d))

;; test shallow-abstraction function now
!(shallow-abstraction Inheritance X Y &valspace)

;; Check if shallow abstractions are inserted correctly
!(match &shabspace (ShallowAbstractionOf $c $d) (ShallowAbstractionOf $c $d))

