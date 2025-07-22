

;;;;;;;;;;;;;;;;;
;; Basic steps ;;
;;;;;;;;;;;;;;;;;

;: - Initialize Miner – Create a function to initialize the frequent pattern miner.
;: - Mine Patterns – Extract patterns that meet the minsup threshold.
;: - Launch Backward Chainer – Use the mined patterns and the surprisingness rule in the backward chainer.
;: - Calculate Surprisingness – The rule triggers do-isurp to compute the surprisingness value for patterns that satisfy it.
;: - Sort & Return – Return patterns sorted by their surprisingness value.



;; Type definition for -> to prevent early reduction
;; of the conclusions before matching the correct premises.
(: -> (-> Atom Atom Type))


====================================================
;;initialize the hyper-parameters in the KB,
(= (init-miner $db $kb $ms $surp $db-ratio)
    (         let* (  
                 (() (add-atom $kb (: msT (ms-threshold $ms))))
                 (() (add-atom $kb (: dbref (db-ref $db))))
                 (() (add-atom $kb (: dbr (db-ratio $db-ratio))))
                 (() (add-reduct $kb (if (or (== $surp nisurp) (== $surp nisurp-old)) 
                                              (: normalize (normalized True))  
                                              (: normalize (normalized False)))))
                 (() (add-atom $kb (surp-mod $surp)))
                 (() (add-atom $kb (db-ratio $db-ratio)))
                 (() (add-atom $kb (db-size (db_size $db))))
                 (() (add-atom &self (kb-ref $kb)))
                 (() (add-atom $kb (db-ref $db)))
                )()))


=========================================================================
;;Returns frequent patters with their support from the kb
(= (get-patterns $kb) (
  chain (match $kb (: msT (ms-threshold $ms)) $ms) $msT
          ( match $kb (: $x (supportOf $pattern $value))
                (let True (>= $value $msT) (($pattern) (sup $value))))           
))

==========================================================================
;; extract the mode of the Surprisingness
;; if the surprisingness mode is none return lis of mined patterns
;; otherwise launches the backward chainer for surprising patterns mining
(= (mine-surp $kb $res $surp-mode)  
  ( case $surp-mode (
        (none  (chain (get-patterns $kb) $result (add-atom $res $result)) ) 
        (jsdsurp (chain  (syn $kb (fromNumber 13) (: $prf (jsdsurp $what_is_surprise $value))) $result   (add-atom $res $result)))
        (isurp-old (chain (syn $kb (fromNumber 15) (: $prf (surp-old $what_is_surprise $value))) $result   (add-atom $res $result)))
        (nisurp-old (chain (syn $kb (fromNumber 15) (: $prf (surp-old $what_is_surprise $value))) $result   (add-atom $res $result)))
        (isurp     (chain (syn $kb (fromNumber 4) (: $prf (surp $what_is_surprise $value))) $result   (add-atom $res $result)))
        ($_        (chain (syn $kb (fromNumber 15) (: $prf (surp-old $what_is_surprise $value))) $result   (add-atom $res $result)))
    )                                                         
))


(= (abstract $depth $kb)
    ; (chain (syn $kb $depth (: $prf (AbstractPattern $x))) $res (add-reduct $kb $res))
 
   (let* (
    ($res (syn $kb $depth (: $prf (AbstractPattern $x))))
    ($rem (remove-atom $kb $res))
    ($add (add-reduct $kb $res))
    ) 
    $res
    )
)
(= (specialization $depth $kb)
    ; (chain (syn $kb $depth (: $prf (specializationOf $aptrn $sptrn))) $res (add-reduct $kb $res)) 
   (let* (
    ($resy (syn $kb $depth (: $prf (specializationOf $aptrn $sptrn))))
    ($rem (remove-atom $kb $resy))
    ($add (add-atom $kb $resy))
    
    ) 
    $resy
    )
) 
(= (support $depth $kb)
    ; (chain (syn $kb $depth (: $prf (supportOf $sptrn $cnt))) $res (add-reduct $kb $res))

   (let* (
    ($res (syn $kb $depth (: $prf (supportOf $sptrn $cnt))))
    ($rem (remove-atom $kb $res))
    ($add (add-reduct $kb $res))
    ) 
    ()
    )
)

(= (candidate $depth $kb)
   
   (let*(
    ($atom (: candidate (-> (minsup $ptrn) (-> (replace_variables $ptrn) (candidatePattern $ptrn)))))
    ($add (add-atom $kb $atom))
    ($res (syn $kb $depth (: $prf (candidatePattern $x)))) 
    ($rem (remove-atom $kb $atom))
    ($rem2 (remove-atom $kb $res))
    ($add2 (add-reduct $kb $res))
    )
    ()
    )
)

conjunct and pattern
1 and 1
2 1
3
(= (conjunction $depth $kb $rec $maxrec) 
    (let*
        (
        ($prevrec (- $rec 1))
        ($re (collapse (remove-atom $kb (: maxClauses (maxClauses $prevrec)))))
        ($add (collapse (add-atom $kb (: maxClauses (maxClauses $rec)))))
        ($res (collapse (syn $kb $depth (: $prf (candidatePattern $y)))))
        ($red (collapse (add-reduct $kb (superpose $res))))
        )
    (if (> (+ $rec 1) $maxrec) $red (conjunction $depth $kb (+ $rec 1) $maxrec))
    )
)

(= (format $depth $kb)
   (collapse 
   (let*(
    ($res (syn $kb $depth (: $prf (hasSupport $ptrn $cnt)))) 
    ($rem2 (remove-atom $kb $res))
    ($add2 (add-reduct $kb $res))
    )
    $res
    ))
)

==========================================================================
;; mocking the frequent pattern miner results 
(= (frequent-miner $db $kb) ( 
     let*  ( 
        ;  (() (add-atom $kb (: FACT1  (supportOf (, (, (Inheritance $x human) (Inheritance $x ugly)) (Inheritance $x woman)) 8))))
        ;  (() (add-atom $kb (: FACT2 (supportOf (, (, (Inheritance $x sodaDrinker) (Inheritance $x human)) (Inheritance $x woman)) 8))))
        ;  (() (add-atom $kb (: FACT3 (supportOf (, (, (Inheritance $x human) (Inheritance $x sodaDrinker)) (Inheritance $x man)) 4))))
        ;  (() (add-atom $kb (: FACT4 (supportOf (, (, (Inheritance $x human) (Inheritance $x sodaDrinker)) (Inheritance $x man)) 8))))

         ;; for new surp 
         (() (add-atom $kb (: FACT1  (supportOf (, (Inheritance $x human) (Inheritance $x ugly) (Inheritance $x woman)) 5))))
         (() (add-atom $kb (: FACT2 (supportOf (, (Inheritance $x sodaDrinker) (Inheritance $x human) (Inheritance $x woman)) 5))))
         (() (add-atom $kb (: FACT3 (supportOf (,  (Inheritance $x human) (Inheritance $x sodaDrinker) (Inheritance $x ugly)) 4))))
         (() (add-atom $kb (: FACT4 (supportOf (,  (Inheritance $x human) (Inheritance $x sodaDrinker) (Inheritance $x man)) 8))))
        ; (() (add-atom $kb (: ((est-rule (((minsupport FACT4) msT) CPU)) dbref) (est-tv (, (, (Inheritance $x human) (Inheritance $x sodaDrinker)) (Inheritance $x man)) 0.6))))
        ; (() (add-atom $kb (: ((emp-rule (((minsupport FACT4) msT) CPU)) CPUEMP) (emp-val (, (, (Inheritance $x human) (Inheritance $x sodaDrinker)) (Inheritance $x man)) (EMPTV 0.5 0.7)))))
        ;; (() (add-atom $kb (: (surprisingness (((minsupport FACT4) msT) CPU)) (jsdsurp (, (, (INHERITANCE_LINK $X $Y) (LIST_LINK L $D)) (LIST_LINK B k)) 0.6))))
        ) ()
))


(= (frequent-miner-new $db $kb) ( 
     let*  ( 
         ($re (collapse (abstract (fromNumber 4) $kb)))
         ($res (collapse (specialization (fromNumber 3) $kb)))
         ($resu (collapse (support (fromNumber 4) $kb)))
         ($result (collapse (candidate (fromNumber 5) $kb)))
        ;  ($results (collapse (conjunction (fromNumber 5) $kb)))
      ) ()
))




;; Action Functions
(=(do-surp $pattern) (
     let* (
          ($kb (match &self (kb-ref $ref) $ref))
          ($ms (match $kb (: msT (ms-threshold $ms)) $ms))
          ($surp (match $kb (surp-mod $surp) $surp))
          ($db    (match $kb (db-ref $ref) $ref))
          ($db-ratio (match $kb (db-ratio $db-ratio) $db-ratio))
          ($db-size (match $kb (db-size $db-size) $db-size))   
          ($ptrn (flatten $pattern))
    )
     (case $surp (
        (isurp-old (isurp-old $ptrn $db False))
        (nisurp-old (isurp-old $ptrn $db True))
        (isurp (isurp $ptrn $db False $db-ratio))
        (nisurp (isurp $ptrn $db True $db-ratio))
        ($_ (isurp $ptrn $db False $db-ratio)))
     )
     )
) 







;; new space to store the init-surp results
!(bind! &res (new-space))


---------------------------------------------------------------------------
;; initializes the necessary input parameters in the KB
;;configures and runs the frequent pattern miner with conjunction expansion
;;proceeds to surprisingness pattern mining using the backward chainer 
;;Store the chainer result in to the &res (new space)
----------------------------------------------------------------------------
(= (cog-mine $db $kb $ms $surp $db-ratio) (
    let* (   
             (() (init-miner $db $kb $ms $surp $db-ratio)) 
             (() (frequent-miner $db $kb))         
             ($var (mine-surp $kb &res $surp))        
        
    )
    ;; return all atoms in &res
       ;(match $kb (: $prf (empProb $pattern $prob)) (empProb $pattern $prob))
      (match &res $x $x)
      ; $var 
))

















































