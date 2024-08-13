! (register-module! ../../../hyperon-miner)
! (import! &database hyperon-miner:experiments:data:sample-data)

 ;; Satisfying set Implementation
(= (satisfying-set $x $db) (match &database $x $x))

 ;; test satisfying-set Implementation
! (satisfying-set (Inheritance $x $y))

 ;; Valuation set Implementation
(= (valuation-set $x $y $z) (match &database ($x $y $z) ("Y" -> $y  "Z" -> $z)))

 ;; Test valuation-set Implementation
! (valuation-set Inheritance $y $z)