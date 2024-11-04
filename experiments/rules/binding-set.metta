 ;! (register-module! ../../../hyperon-miner)
 ;!(import! &dbspace hyperon-miner:experiments:data:sample-data)
 ;!(bind! &bindspace (new-space))

 ;; Satisfying set Implementation
(= (satisfying-set $x $db) (match $db $x $x))

 ;; test satisfying-set Implementation
 ;!(satisfying-set (Inheritance $x $y) &dbspace)

 ;; Valuation set Implementation
(= (binding-set $link $x $y $dbspace $bindspace) (superpose (
            (collapse (match $dbspace ($link $x $y) (superpose ( (remove-atom $bindspace (BindingOf X $x)) (add-atom $bindspace (BindingOf X $x))))))
            (collapse (match $dbspace ($link $x $y) (superpose ( (remove-atom $bindspace (BindingOf Y $y)) (add-atom $bindspace (BindingOf Y $y))))))
        )
)
)
