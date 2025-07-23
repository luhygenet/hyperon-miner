
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

------------------------------------------------------------------------
;;equality checker relation 
(= (syn $kb $_ (: $prf (equals $X $Y))) 
    (if (and (and (is-number $X) (is-number $Y)) (== $X $Y))
          (: CPUequals (equals $X $Y))
             (empty)))

---------------------------------------------------------------------
(= (syn $kb $_ (: $prf (⍄ $X $Y))) 
    (if (and (and (is-number $X) (is-number $Y)) (> $X $Y))
          (: CPU (⍄ $X $Y))
             (empty))) 


             


==============================================================================
;; chainner 
==============================================================================
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


     

; ;; Base case.  For now it terminates at exactly iteration Z to avoid
; ;; collecting too many redundant results.
; (= (isyn $kb $depth Z $query) $query)

;; Iterative step
(= (isyn $kb $depth (S $k) $query)
   (let* (
      (() (println! (have called)))
      ($cres (collapse (syn $kb $depth $query)))
          (() (println! (cres: $cres)))
          ($dummy (add-atoms-nodup $kb $cres))
          )
     (isyn $kb $depth $k (superpose $cres))))

(= (collapser $kb $depth  $query)
   (let* (
      (() (println! (have called)))
      ($cres (collapse (syn $kb $depth $query)))
      (() (println! (cres: $cres)))
          )
     $cres))





    