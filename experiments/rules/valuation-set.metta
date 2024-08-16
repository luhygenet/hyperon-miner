! (register-module! ../../../hyperon-miner)
! (import! &dbspace hyperon-miner:experiments:data:sample-data)
!(bind! &valspace (new-space))

 ;; Satisfying set Implementation
(= (satisfying-set $x $db) (match $db $x $x))

 ;; test satisfying-set Implementation
! (satisfying-set (Inheritance $x $y) &dbspace)

 ;; Valuation set Implementation
(= (valuation-set $link $x $y $db) (let* ((($w $z) (match &dbspace ($link $x $y) ($x $y)))
                                    (() (println! ($w $z)))
                                    (() (add-atom $db (ValuationOf X $w)))
                                    (() (add-atom $db (ValuationOf Y $z))))
                                    (println! "Inserted valuation set into valuation space")))

!(get-atoms &valspace)

 ;; Test valuation-set Implementation
! (valuation-set Inheritance $x $y &valspace)

;; Check if valuation sets are inserted correctly
!(match &valspace (ValuationOf $c $d) (ValuationOf $c $d))