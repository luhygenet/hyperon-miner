
;; define system proofs 
;; System proof for ⍃
;; if conclusion equals (⍃ $X $Y), then return (: CPU (⍃ $X $Y)) 
;; if $x and $Y are fully grounded and (< $X $Y)
(= (syn $kb $_ (: $prf (⍃ $X $Y))) 
    (if (and (and (is-number $X) (is-number $Y)) (< $X $Y))
          (: CPU (⍃ $X $Y))
             (empty)))

(= (syn $kb $_ (: $prf (uniqueLink $db))) 
    (let $uniquelink (unique (match $db ($link $x $y) $link)) 
    (if (== (size-atom $uniquelink) 0)
          (empty)
             (: CPUUnique (Abstract ($uniquelink $x $y)))
             ))
    )

 (let* (
        ($conjuncts (get-conjuncts $conjunction))
        ($unique_conjuncts (unique-atom $conjuncts))
        )
    (if (== (size-atom $conjuncts) (size-atom $unique_conjuncts))
        $conjunction
        ; (remove_conjuncts_with (unique $conjunction))
        ()
    )
    )
;; System proof for Surpabsent
;; check if surprisingness value already calculated 
;; if count > 0 then no proof for the absent of the surprisingness value 
;;(= (syn $kb $_ (: $prf (surpabsent $ptrn))) 
;;      (if (> (counter $kb (surp $ptrn $value)) 0) ;; use match here
;;             (empty)
;;               (: CPUSurpAb (surpabsent $ptrn))))




