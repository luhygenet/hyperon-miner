
(=(is-number $x) 
   (== (get-type $x) Number)  
)

;; define system proofs 
------------------------------------------------------------------
;; System proof for ⍃
;; if conclusion equals (⍃ $X $Y), then return (: CPU (⍃ $X $Y)) 
;; if $x and $Y are fully grounded and (< $X $Y)
------------------------------------------------------------------
(= (syn $kb $_ (: $prf (⍃ $X $Y))) 
    (if (and (and (is-number $X) (is-number $Y)) (<= $X $Y))
          (: CPU (⍃ $X $Y))
             (empty)))

(= (syn $kb $_ (: $prf (equals $X $Y))) 
    (if (and (and (is-number $X) (is-number $Y)) (== $X $Y))
          (: CPUequals (equals $X $Y))
             (empty)))


(= (syn $kb $_ (: $prf (⍄ $X $Y))) 
    (if (and (and (is-number $X) (is-number $Y)) (> $X $Y))
          (: CPU (⍄ $X $Y))
             (empty))) 

(= (syn $kb $_ (: $prf (Equal $X $Y))) 
    (if (== $X $Y)
          (: Equal-CPU (Equal $X $Y))
             (empty)))
             
; (= (syn $kb $depth (: $prf (XOR $x $y))) 
;     (let* (    
;         ( (: $xprf $query-x) (syn $kb $depth (: $prfx (superpose ( $x $y)))))
;                (() (println! (""here"" $query-x))) 
;             ($xres (unify $x $query-x True False))
;             ($yres (unify $y $query-x True False))
;                (() (println! (""here"" $xres))) 
;                (() (println! (""here"" $yres))) 
        
;            )
;           ( if (xor $xres $yres)
;                  (: XOR-CPU (XOR $x $y)) 
;                    (empty) )
;             ))



(= (syn $kb $_ (: $prf (uniqueLink $db $pattern $cnt))) 
    (let* (
        ($uniquelink (collapse (unique (match $db ($link $x $y) $link)) ) )
        ($sup (superpose $uniquelink))
        )
    (if (== (size-atom $uniquelink) 0)
          (empty)
             (: CPUUnique (Abstract ($uniquelink $x $y)))
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


-----------------------------------------------------------------------------
(= (syn $kb $_ (: $prf (prob-cpu  $pattern $prob))) 
    (let $dbb (match $kb (db-ref $db) $db)
    (: CPUPROB (prob-cpu  $pattern (prob $pattern  $dbb) ))
    ) 
)

-----------------------------------------------------------------------------
;; system proof to calculate the partitions for the given pattern.
(= (syn $kb $_ (: $prf (partition-cpu  $pattern $partitions))) 
    (let $partitions (generet-partition-without-pattern $pattern)
    (: CPUPARTN (partition-cpu  $pattern $partitions)) ) 
)

----------------------------------------------------------------------------
;; min max estimation of the pattern for isurp old
(= (syn $kb $_ (: $prf (est-prob-cpu  $pattern $partitions $emin-emax))) 
    (let $dbb (match $kb (db-ref $db) $db)
    (: CPUESTPROB (est-prob-cpu   $pattern $partitions (min-max (isurp-old_  $partitions $dbb)))) ) 
)

-------------------------------------------------------------------------
;; calculates the distance between the estimate value and emperical value
(= (syn $kb $_ (: $prf (dst-cpu $x $y $dst))) 
    (let $dst (- $x $y)
    (: CPUDST (dst-cpu  $x $y $dst)) ) 
)

-------------------------------------------------------------------------
;; create the minimum relation 
(= (syn $kb $_ (: $prf (minimum $x $y $z)))
         (let $min (min $x $y)
               (: MINIMUMCPU  (minimum $x $y $min))))

-------------------------------------------------------------------------
;; division relation 
(= (syn $kb $_ (: $prf (divide $x $y $z)))
         (let $div (// $x $y)
               (: DIVIDECPU (divide $x $y $div))))












; ================================================================================

;; Base case
(= (syn $kb $_ (: $prf $ccln)) (match $kb (: $prf $ccln) (: $prf $ccln)))

;; Recursive step
(= (syn $kb (S $k) (: ($prfabs $prfarg) $ccln))
   (let* (
     ((: $prfabs (-> $prms $ccln)) (syn $kb $k (: $prfabs (-> $prms $ccln))))
         ; (() (println! (Next prims : $prms)))
          ((: $prfarg $prms) (syn $kb $k (: $prfarg $prms)))
          )
     (: ($prfabs $prfarg) $ccln)))


     

; ;; Base case.  For now it terminates at exactly iteration Z to avoid
; ;; collecting too many redundant results.
; (= (isyn $kb $depth Z $query) $query)

; ;; Iterative step
; (= (isyn $kb $depth (S $k) $query)
;    (let* (
;       (() (println! (have called)))
;       ($cres (collapse (syn $kb $depth $query)))
;           (() (println! (cres: $cres)))
;           ($dummy (add-atoms-nodup $kb $cres))
;           )
;      (isyn $kb $depth $k (superpose $cres))))




(= (collapser $kb $depth  $query)
   (let* (
      (() (println! (have called)))
      ($cres (collapse (syn $kb $depth $query)))
      ($dummy (add-atoms-nodup $kb $cres))
      (() (println! (cres: $cres)))
          )
     $cres))





    