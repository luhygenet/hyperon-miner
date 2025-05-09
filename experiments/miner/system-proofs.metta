
;; define system proofs 
;; System proof for ⍃
;; if conclusion equals (⍃ $X $Y), then return (: CPU (⍃ $X $Y)) 
;; if $x and $Y are fully grounded and (< $X $Y)
(= (syn $kb $_ (: $prf (⍃ $X $Y))) 
    (if (and (and (is-number $X) (is-number $Y)) (< $X $Y))
          (: CPU (⍃ $X $Y))
             (empty)))

             
; (= (syn $kb $_ (: $prf (⍃ $X $Y)))
;     (let () (println! (syn-⍃ (: $prf (⍃ $X $Y))))
;      (if (and (and (is-closed $X) (is-closed $Y)) (< $X $Y))
;           (: CPU (⍃ $X $Y))
;           Empty)))

; (= (bc $kb $_ (: $prf (⍃ $X $Y))) 
;     (if (and (and (is-number $X) (is-number $Y)) (< $X $Y))
;           (: CPU (⍃ $X $Y))
;              (empty)))


; (= (bcc $kb $_ (: $prf (supportOf $ptrn $cnt))) 
;     (let* (
;             ;($link (match $kb (unqLink $sup) $sup))
;            ; ($num (sup-num $kb $ptrn))
;             (println! $num))
;           (: CPUSUP (supportOf $ptrn 2))))



; (= (bc $kb $_ (: $prf (uniqueLink $db $pattern $cnt))) 
;     (let* (
;         ($uniquelink (collapse (unique (match $db ($link $x $y) $link)) ) )
;         ($sup (superpose $uniquelink))
;         (add-atom $kb (unqLink $sup))
;         )
;     (if (== (size-atom $uniquelink) 0)
;           (empty)
;              (: CPUUnique (uniqueLink $db ($sup $x1 $y1) (counter $db ($sup $x1 $y1))))
;         )    
;     ))

(= (syn $kb $_ (: $prf (uniqueLink $db $pattern $cnt))) 
    (let* (
        ($uniquelink (collapse (unique (match $db ($link $x $y) $link)) ) )
        ($sup (superpose $uniquelink))
        (add-atom $kb (unqLink $sup))
        )
    (if (== (size-atom $uniquelink) 0)
          (empty)
             (: CPUUnique (uniqueLink $db ($sup $x1 $y1) (counter $db ($sup $x1 $y1))))
        )    
    ))


;; System proof for Surpabsent
;; check if surprisingness value already calculated 
;; if count > 0 then no proof for the absent of the surprisingness value 
;;(= (syn $kb $_ (: $prf (surpabsent $ptrn))) 
;;      (if (> (counter $kb (surp $ptrn $value)) 0) ;; use match here
;;             (empty)
;;               (: CPUSurpAb (surpabsent $ptrn))))




