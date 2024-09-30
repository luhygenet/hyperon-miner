;! (register-module! ../../../hyperon-miner)
;!(import! &dbspace hyperon-miner:experiments:data:sample-data)
;!(bind! &valspace (new-space))

;; Satisfying set Implementation
(= (satisfying-set $x $db) (match $db $x $x))

;; test satisfying-set Implementation
;!(satisfying-set (Inheritance $x $y) &dbspace)


;; Valuation set Implementation
(= (valuation-set $link $x $y $dbspace $valspace) (superpose (
        (println! ($link $x $y))
        (match $dbspace ($link $x $y) (superpose((remove-atom $valspace (ValuationOf X $x)) (add-atom $valspace (ValuationOf X $x)))))
        (match $dbspace ($link $x $y) (superpose((remove-atom $valspace (ValuationOf Y $y)) (add-atom $valspace (ValuationOf Y $y)))))
        )   
    )
)
