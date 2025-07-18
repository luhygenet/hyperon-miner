
! (bind! &dbspace (new-space))
! (bind! &specspace (new-space))
! (bind! &cndpspace (new-space))
! (bind! &aptrnspace (new-space))
! (bind! &conjspace (new-space))

; (isurp-old (, (Inheritance $x human) (Inheritance $x sodaDrinker) (Inheritance $x man)) &db  True)

(= (add-atom-nodup $space $atom)
   (case (match $space $atom $atom)
     (($atom ())
      (Empty (add-atom $space $atom)))))

(= (do-surp $kb $db $surp-mode $normalization ) (
    let (supportOf $pattern $support) (unique (match $kb  $x $x))
         ;(let $surp_val  ($surp-mode $pattern $db True) (add-atom-nodup $kb (surprisingnessOf $pattern $surp_val)))    
         (println! (surp $pattern)) 
))

(=(call-surprisingness $kb $db $surp-mode)
  (case $surp-mode (
     (nisurp-old  (do-surp $kb $db isurp-old  True))
     (isurp-old  (do-surp $kb $db isurp-old   False))
     ($_  ())
  )))
  

(= (pattern-miner $kb $db $minsup $depth $surp-mode) ( 
    let*
    (  ($dummy (collapse (let ($link $x $y) (get-atoms $db) (add-atom &dbspace ($link $x $y))) ))
          (() (frequency-pattern-miner $kb &dbspace &specspace &cndpspace &aptrnspace &conjspace $minsup $depth))
          ($dummy2 (collapse (call-surprisingness $kb $db $surp-mode)))
          )  ()

))




; !(match &dbspace (, (Inheritance $x man) (Inheritance $x sodaDrinker)) $x)