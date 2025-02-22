
;; define system proofs 
;; System proof for ⍃
;; if conclusion equals (⍃ $X $Y), then return (: CPU (⍃ $X $Y)) 
;; if $x and $Y are fully grounded and (< $X $Y)
(= (syn $kb $_ (: $prf (⍃ $X $Y))) 
    (if (and (and (is-number $X) (is-number $Y)) (< $X $Y))
          (: CPU (⍃ $X $Y))
             (empty)))



;; System proof for Surpabsent
;; check if surprisingness value already calculated 
;; if count > 0 then no proof for the absent of the surprisingness value 
(= (syn $kb $_ (: $prf (surpabsent $ptrn))) 
      (if (> (counter $kb (surp $ptrn $value)) 0)
             (empty)
               (: CPUSurpAb (surpabsent $ptrn))))






