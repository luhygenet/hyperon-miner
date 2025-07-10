; !(register-module! ../rules)
; !(import! &self rules:freq-pat)
; (: tuple-count (-> %Undefined% Number))
; (= (tuple-count $atom) (size-atom $atom))

(= (count-sup $db $ptrn)
    (let $result (collapse (match $db $ptrn $ptrn))
         (size-atom $result)
    )
)

(= (handle-nested-exp $p)
    (if (not (== (get-metatype $p) Expression))
        $p
        (let* (
                (() (println! (Handling nested expression: $p)))
                ( ($link $x $y) $p)
                ( $nx (collapse (handle-nested-exp $x)))
                ( $ny (collapse (handle-nested-exp $y)))
            )
        (superpose (
                ($link (superpose $nx) $w)
                ($link $z (superpose $ny))
                ($link $x $u)
                ($link $k $y)
                $d
                ($link $g $o)
                ($link (superpose $nx) (superpose $ny))
            )
    )
)

)
)


(= (get-clauses $cnj) (
  unify (, $ncnj $ptrn) $cnj (let $result (get-clauses $ncnj) (cons-atom $ptrn $result) ) ($cnj)
))


(=(is-numb $x) 
   (== (get-type $x) Number) 
)

;; define system proofs 
------------------------------------------------------------------
;; System proof for ⍃
;; if conclusion equals (⍃ $X $Y), then return (: CPU (⍃ $X $Y)) 
;; if $x and $Y are fully grounded and (< $X $Y)
------------------------------------------------------------------
(= (syn $kb $_ (: $prf (⍃ $X $Y))) 
    (if (and (and (is-numb $X) (is-numb $Y)) (<= $X $Y))
          (: CPU (⍃ $X $Y))
             (empty)))

(= (syn $kb $_ (: $prf (equals $X $Y))) 
    (if (and (and (is-numb $X) (is-numb $Y)) (== $X $Y))
          (: CPUequals (equals $X $Y))
             (empty)))
             

(= (syn $kb $_ (: $prf (uniqueLink $db $pattern $cnt))) 
    (let* (
        ($uniquelink (collapse (unique (match $db ($link $x $y) $link)) ) )
        ($sup (superpose $uniquelink))
        )
    (if (== (size-atom $uniquelink) 0)
          (empty)
             (: CPUUnique (uniqueLink $db ($sup $a $b) (count-sup $db ($sup $a $b))))
             ))
    )

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
        ($clauses (get-clauses $ptrn))
        ($cnt (size-atom $clauses))
        )
    (if (== $cnt 0)
          (empty)
             (: CPUCount (clause_count $ptrn $cnt))
        )    
    )
)
(= (syn $kb $_ (: $prf (depth-handler $p $np)))
    (let
     $np (handle-nested-exp $p)
    (if (== $np ())
          (empty)
             (: CPUHandleNestedExp (depth-handler $p $np))
        )    
    )
)

(= (syn $kb $_ (: $prf (valuation $db ($link $x $y) ($valx $valy))))
    (let
        ($valx $valy) (match $db ($link $x $y) ($x $y))
    (if (== ($valx $valy) ())
          (empty)
             (: CPUHandleValuation (valuation $db ($link $x $y) ($valx $valy)))
        )    
    )
)
;; Proof for prunning
; (= (syn $kb $_ (: PRUNEPRF (valid-conj $p1 $p2))) 
;     (if (prune? (, $p1 $p2))
;         (empty)
;         (: PRUNEPRF (valid-conj $p1 $p2))))


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


;; Backward chainer/synthesizer
(: syn (-> $a                           ; Knowledge base space
           Nat                          ; Maximum depth
           $b                           ; Query
           $b))                         ; Result


 
;; Base case
(= (syn $kb $_ (: $prf $ccln)) (match $kb (: $prf $ccln) (: $prf $ccln)))

;; Recursive step
(= (syn $kb (S $k) (: ($prfabs $prfarg) $ccln))
   (let* (
     ((: $prfabs (-> $prms $ccln)) (syn $kb $k (: $prfabs (-> $prms $ccln))))
          (() (println! (Next prims : $prms)))
          ((: $prfarg $prms) (syn $kb $k (: $prfarg $prms)))
          )
     (: ($prfabs $prfarg) $ccln)))

;; Base case.  For now it terminates at exactly iteration Z to avoid
;; collecting too many redundant results.
(= (isyn $kb $depth Z $query) $query)

;; Iterative step
(= (isyn $kb $depth (S $k) $query)
   (let* (
      (() (println! (have called)))
      ($cres (collapse (syn $kb $depth $query)))
          (() (println! (cres: $cres)))
          ($dummy (add-atoms-nodup $kb $cres)))
     (isyn $kb $depth $k (superpose $cres))))

(= (collapser $kb $depth  $query)
   (let* (
      (() (println! (have called)))
      ($cres (collapse (syn $kb $depth $query)))
      (() (println! (cres: $cres)))
          )
     $cres))
