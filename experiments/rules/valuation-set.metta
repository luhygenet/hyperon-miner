;; Satisfying set Implementation
(= (satisfying-set $x) (match &self $x $x))

;; test satisfying-set Implementation
;!(satisfying-set (Inheritance $x $y))

;; Valuation set Implementation
(= (valuation-set $x $y $z) (match &self ($x $y $z) (variable x -> $y and variable y -> $z)))

;; Test valuation-set Implementation
;!(valuation-set Inheritance $y $z)