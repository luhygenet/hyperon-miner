;! (register-module! ../../../hyperon-miner)
;!(import! &dbspace hyperon-miner:experiments:data:sample-data)
;!(bind! &valspace (new-space))

;; Satisfying set Implementation
(= (satisfying-set $x $db) (match $db $x $x))

;; test satisfying-set Implementation
;!(satisfying-set (Inheritance $x $y) &dbspace)

 ;; Valuation set Implementation
(= (valuation-set $link $x $y $dbspace $valspace) (let* ((($w $z) (match $dbspace ($link $x $y) ($x $y)))
                                    (() (add-atom $valspace (ValuationOf X $w)))
                                    (() (add-atom $valspace (ValuationOf Y $z))))
                                    (println! "Inserted valuation set into valuation space")))
