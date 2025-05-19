
;; define system proofs 
------------------------------------------------------------------
;; System proof for ⍃
;; if conclusion equals (⍃ $X $Y), then return (: CPU (⍃ $X $Y)) 
;; if $x and $Y are fully grounded and (< $X $Y)
------------------------------------------------------------------
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
----------------------------------------------------------------------------
;; system proof  to calculate the emp-tv for the given pattern. 
;; The database is queried here because, when it was placed in the premises, 
;; it caused infinite results in CPUEMP.
----------------------------------------------------------------------------
(= (syn $kb $_ (: $prf (emp-cpu $ptrn  $emp ))) 
    (let $dbb (match $kb (db-ref $db) $db)
    (: CPUEMP (emp-cpu $ptrn  (emp-tv (flatten $ptrn) $dbb ))) ) 
)

-----------------------------------------------------------------------------
;; system proof  to calculate the est-tv for the given pattern. 
;; The database is queried here because, when it was placed in the premises, 
;; it caused infinite results in CPUEST.
-----------------------------------------------------------------------------
(= (syn $kb $_ (: $prf (est-cpu  $ptrn $emp $est))) 
    (let $dbb (match $kb (db-ref $db) $db)
    (: CPUEST (est-cpu $ptrn $emp (do-ji-tv-est $dbb (flatten $ptrn) $emp))) ) 
)



;; System proof for Surpabsent
;; check if surprisingness value already calculated 
;; if count > 0 then no proof for the absent of the surprisingness value 
;;(= (syn $kb $_ (: $prf (surpabsent $ptrn))) 
;;      (if (> (counter $kb (surp $ptrn $value)) 0) ;; use match here
;;             (empty)
;;               (: CPUSurpAb (surpabsent $ptrn))))




