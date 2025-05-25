; !(register-module! ../rules)
; !(import! &self rules:freq-pat)


;; define system proofs 
;; System proof for ⍃
;; if conclusion equals (⍃ $X $Y), then return (: CPU (⍃ $X $Y)) 
;; if $x and $Y are fully grounded and (< $X $Y)
(= (syn $kb $_ (: $prf (⍃ $X $Y))) 
    (if (and (and (is-number $X) (is-number $Y)) (<= $X $Y))
          (: CPU (⍃ $X $Y))
             (empty)))

(= (syn $kb $_ (: $prf (equals $X $Y))) 
    (if (and (and (is-number $X) (is-number $Y)) (== $X $Y))
          (: CPUequals (equals $X $Y))
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
        )
    (if (== (size-atom $uniquelink) 0)
          (empty)
             (: CPUUnique (uniqueLink $db ($sup $x1 $y1) (counter $db ($sup $x1 $y1))))
        )    
    ))

(= (syn $kb $_ (: $prf (replace_variables $ptrn)))
    (let* (
        ($new_ptrn (call_replace $ptrn))
        )
    (if (== $new_ptrn ())
          (empty)
             (: CPUReplacevar (replace_variables $new_ptrn))
        )    
    )
)

(= (syn $kb $_ (: $prf (replace_index $ptrn $res)))
    (let* (
        ($new_ptrn (call_replacev $ptrn))
        )
    (if (== $new_ptrn ())
          (empty)
             (: CPUReplaceindex (replace_index $ptrn $new_ptrn))
        )    
    )
)

(= (syn $kb $_ (: $prf (clause_count $ptrn $cnt)))
    (let* (
        ($clauses (get-conjuncts $ptrn))
        ($cnt (size-atom $clauses))
        )
    (if (== $cnt 0)
          (empty)
             (: CPUCount (clause_count $ptrn $cnt))
        )    
    )
)
;; Proof for prunning
; (= (syn $kb $_ (: PRUNEPRF (valid-conj $p1 $p2))) 
;     (if (prune? (, $p1 $p2))
;         (empty)
;         (: PRUNEPRF (valid-conj $p1 $p2))))


;; System proof for Surpabsent
;; check if surprisingness value already calculated 
;; if count > 0 then no proof for the absent of the surprisingness value 
;;(= (syn $kb $_ (: $prf (surpabsent $ptrn))) 
;;      (if (> (counter $kb (surp $ptrn $value)) 0) ;; use match here
;;             (empty)
;;               (: CPUSurpAb (surpabsent $ptrn))))




