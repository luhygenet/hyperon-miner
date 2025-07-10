!(register-module! ../../experiments)
; !(register-module!  ../../../../chaining)

; !(import! &self experiments:miner:miner)
!(import! &self experiments:miner:miner-utils)
!(import! &self experiments:rules:conj-exp)
!(import! &self experiments:rules:freq-pat)
!(import! &self experiments:rules:use-python)
!(import! &self experiments:utils:variable-combinations)



;; import utils and rules files 
! (import! &self experiments:rules:isurp)
! (import! &self experiments:rules:isurp-old)
! (import! &self experiments:utils:common-utils)
! (import! &self experiments:utils:beta-dist)
! (import! &self experiments:utils:constants)
! (import! &self experiments:utils:TruthValue)
! (import! &self experiments:utils:surp-utils)
! (import! &self experiments:utils:miner-utils)
! (import! &self experiments:rules:build-specialization)
! (import! &self experiments:rules:conjunction-expansion)

! (import! &self experiments:utils:gen_partition)
! (import! &self experiments:rules:est-tv)
! (import! &self experiments:rules:emp-tv)
! (import! &self experiments:rules:emp-prob)
! (import! &self experiments:rules:jsd)
! (import! &self experiments:utils:emp-tv-bs)
! (import! &self experiments:utils:bs-utils)
! (import! &self experiments:utils:util-jsd)
; ! (import! &dbspace experiments:data:ugly_man_sodaDrinker)
! (import! &dbspace experiments:data:small-ugly)



;; config kb : load the chainer , rules , system-proofs ....
; !(import! &self  chaining:dtl:backward:curried)
!(import! &temp   experiments:miner:miner-rules)
!(import! &self  experiments:miner:system-proofs)

;;create new space for kb
!(bind! &kb (new-space)) 
!(bind! &db (new-space)) 

!(let ($link $x $y) (get-atoms &dbspace) (add-atom &db ($link $x $y)))
!(let $atoms  (get-atoms &temp) (add-atom &kb $atoms) )


; !(add-atom &kb (: candidate (candidate-clean (Inheritance Z ugly))))
; !(add-atom &kb (: candidate (candidate-clean ())))
; !(add-atom &kb (: candidate (candidate-clean (Inheritance Z sodaDrinker))))


;;;;;;;;;;;
;; To Do ;;
;;;;;;;;;;;

;: - Initialize Miner – Create a function to initialize the frequent pattern miner.
;: - Mine Patterns – Extract patterns that meet the minsup threshold.
;: - Launch Backward Chainer – Use the mined patterns and the surprisingness rule in the backward chainer.
;: - Calculate Surprisingness – The rule triggers do-isurp to compute the surprisingness value for patterns that satisfy it.
;: - Sort & Return – Return patterns sorted by their surprisingness value.



;; Type definition for -> to prevent early reduction
;; of the conclusions before matching the correct premises.
(: -> (-> Atom Atom Type))

; ; ;; Backward chainer/synthesizer
; (: syn (-> $a                           ; Knowledge base space
;            Nat                          ; Maximum depth
;            $b                           ; Query
;            $b))                         ; Result

; ;; Base case
; (= (syn $kb $_ (: $prf $ccln)) (match $kb (: $prf $ccln) (: $prf $ccln)))
; ;; Recursive step
; (= (syn $kb (S $k) (: ($prfabs $prfarg) $ccln))
;    (let* (
;      (() (println! (syn-⍃ (: ($prfabs $prfarg) $ccln))))
;      ((: $prfabs (-> $prms $ccln)) (syn $kb $k (: $prfabs (-> $prms $ccln))))
;           ((: $prfarg $prms) (syn $kb $k (: $prfarg $prms))))
;      (: ($prfabs $prfarg) $ccln)))


;; Initializers
;;initialize the necessary input parameters in the KB,
(= (init-miner $db $kb $ms $surp $db-ratio)
    (         let* (  
                 (() (add-atom $kb (: msT (ms-threshold $ms))))
                 (() (add-atom $kb (: dbref (db-ref $db))))
                 (() (add-atom $kb (: dbr (db-ratio $db-ratio))))
                 (() (add-atom $kb (surp-mod $surp)))
                 (() (add-atom $kb (db-ratio $db-ratio)))
                 (() (add-reduct $kb (db-size (db_size $db))))
                 (() (add-atom &self (kb-ref $kb)))
                 (() (add-atom $kb (db-ref $db)))
                ;; (() (add-reduct $kb (minsup-rule)))
                ;; (() (add-reduct $kb (surp-rule)))
                )()))


;;Returns frequent patters with their support from the kb
(= (get-patterns $kb) (
  chain (match $kb (: msT (ms-threshold $ms)) $ms) $msT
          ( match $kb (: $x (supportOf $pattern $value))
                (let True (>= $value $msT) (($pattern) (sup $value))))           
))


;; extract the mode of the Surprisingness
;; if the surprisingness mode is none return lis of mined patterns
;; otherwise launches the backward chainer for surprising patterns mining

(= (init-surp $kb $res $surp-mode)  
  (           
        if (== $surp-mode none) 
              (chain (get-patterns $kb) $result (add-atom $res $result))  
                 (if  ( == $surp-mode jsdsurp)  
                            (chain  (syn $kb (fromNumber 13) (: $prf (jsdsurp $what_is_surprise $value))) $result   (add-reduct $res $result))                           
                                   (chain  (syn $kb (fromNumber 4) (: $prf (surp $what_is_surprise $value))) $result   (add-reduct $res $result))         
)))


; !(fcc &kb (: dbref (db-ref $db)))


(=(call-this) (
      superpose((: (surprisingness (((minsupport FACT4) msT) CPU)) (surp (, (, (INHERITANCE_LINK $X $Y) (LIST_LINK L $D)) (LIST_LINK B k)) 0.6))
               (: (surprisingness (((minsupport FACT4) msT) CPU)) (surp (, (, (INHERITANCE_LINK $X $Y) (LIST_LINK L $D)) (LIST_LINK B k)) 0.8)))
))
(= (abstract $depth $kb)
    ; (chain (syn $kb $depth (: $prf (AbstractPattern $x))) $res (add-reduct $kb $res))
   (collapse 
   (let* (
    ($res (syn $kb $depth (: $prf (AbstractPattern $x))))
    ($rem (remove-atom $kb $res))
    ($add (add-reduct $kb $res))
    ) 
    $res
    ))
)
(= (specialization $depth $kb)
    ; (chain (syn $kb $depth (: $prf (specializationOf $aptrn $sptrn))) $res (add-reduct $kb $res))
    (collapse 
   (let* (
    ; ($resx (syn $kb $depth (: $prf (specializationx $aptrn $sptrn))))
    ; ($rem (remove-atom $kb $resx))
    ; ($add (add-reduct $kb $resx))
    ($resy (syn $kb $depth (: $prf (specializationy $aptrn $sptrn))))
    ($rem (remove-atom $kb $resy))
    ($add (add-reduct $kb $resy))
    
    ) 
    ($resx $resy)
    ))
) 
(= (support $depth $kb)
    ; (chain (syn $kb $depth (: $prf (supportOf $sptrn $cnt))) $res (add-reduct $kb $res))
      (collapse 
   (let* (
    ($res (syn $kb $depth (: $prf (supportOf $sptrn $cnt))))
    ($rem (remove-atom $kb $res))
    ($add (add-reduct $kb $res))
    ) 
    $res
    ))
)

(= (candidate $depth $kb)
   (collapse 
   (let*(
    ($atom (: candidate (-> (minsup $ptrn) (-> (replace_variables $ptrn) (candidatePattern $ptrn)))))
    ($add (add-atom $kb $atom))
    ($res (syn $kb $depth (: $prf (candidatePattern $x)))) 
    ($rem (remove-atom $kb $atom))
    ($rem2 (remove-atom $kb $res))
    ($add2 (add-reduct $kb $res))
    )
    $res
    ))
)


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

(= (remove_redundant_conjunctions $depth $kb)
   (collapse 
   (let*(
    ($res (syn $kb $depth (: $prf (candidate-clean $x)))) 
    ($rem2 (remove-atom $kb $res))
    ($add2 (add-reduct $kb $res))
    )
    $res
    ))
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



;;;;; Dummies ;;;;;;
;; mocking the frequent pattern miner results 
(= (frequent-miner-old $db $kb) ( 
     let*  ( ;(() (add-atom $kb (: FACT1  (supportOf (, (, (Inheritance $x human) (Inheritance $x ugly)) (Inheritance $x woman)) 5))))
        ; (() (add-atom $kb (: FACT2 (supportOf (, (, (Inheritance $x sodaDrinker) (Inheritance $x human)) (Inheritance $x woman)) 5))))
        ; (() (add-atom $kb (: FACT3 (supportOf (, (, (Inheritance $x human) (Inheritance $x sodaDrinker)) (Inheritance $x man)) 4))))
         (() (add-atom $kb (: FACT4 (supportOf (, (, (Inheritance $x human) (Inheritance $x sodaDrinker)) (Inheritance $x man)) 8))))
        ; (() (add-atom $kb (: ((est-rule (((minsupport FACT4) msT) CPU)) dbref) (est-tv (, (, (Inheritance $x human) (Inheritance $x sodaDrinker)) (Inheritance $x man)) 0.6))))
        ; (() (add-atom $kb (: ((emp-rule (((minsupport FACT4) msT) CPU)) CPUEMP) (emp-val (, (, (Inheritance $x human) (Inheritance $x sodaDrinker)) (Inheritance $x man)) (EMPTV 0.5 0.7)))))
        ;; (() (add-atom $kb (: (surprisingness (((minsupport FACT4) msT) CPU)) (jsdsurp (, (, (INHERITANCE_LINK $X $Y) (LIST_LINK L $D)) (LIST_LINK B k)) 0.6))))
        ) ()
))


(= (frequent-miner $db $kb $maxclauses $limit) 
( 
     let*  ( 
         ($re (collapse (abstract (fromNumber 5) $kb)))
         ($res (collapse (specialization (fromNumber 6) $kb)))
        ;  ($resu (collapse (support (fromNumber 4) $kb)))
        ;  ($result (collapse (candidate (fromNumber 5) $kb)))
        ;  ($results (collapse (conjunction (fromNumber 13) $kb $maxclauses $limit)))
        ;  ($resultn (collapse (remove_redundant_conjunctions (fromNumber 2) $kb)))
        ;  ($resultf (collapse (format (fromNumber 4) $kb)))
      ) ()
)
)




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





;;(: cog-mine (-> db         ;; Data base space 
                ms         ;; Minimum support
                           ;; Minimum support. All patterns with count below
                           ;; ms are discarded.

                cnjexp     ;; Conjunction expansion
                           ;; Flag whether to use the conjunctions expansion
                           ;; heuristic rules. It will only expand conjunctions with enough support
                           ;; with patterns with enough support.

                maxcnj     ;; Maximum number of conjunctions
                           ;; Maximum number of conjuncts of a pattern
                           ;; to apply shallow specialization to, which can be very expensive
                           ;; when applied to patterns with more than 1 conjunct.
                           ;; Any value between 0 and the number of conjuncts of the initial
                           ;; pattern (excluded) will disable shallow specialization.

                max-cnjexp-variables   ;; Maximum number of variables in conjunction expansion
                                       ;; Maximum number of variables in patterns produced
                                       ;; by the conjunction expansion rule.

                surp        ;; Surprisingness measure 
                            ;; After running the pattern miner,
                            ;; patterns can be ranked according to a surprisingness measure.
                            ;; The following supported modes are:
                            ;;    'isurp-old:  Verbatim port of Shujing I-Surprisingness.
                            ;;    'nisurp-old: Verbatim port of Shujing normalized I-Surprisingness.
                            ;;    'isurp:      New implementation of I-Surprisingness that takes
                            ;;            l    linkage into account.
                            ;;    'nisurp:     New implementation of normalized I-Surprisingness
                            ;;                 that takes linkage into account.
                            ;;    'jsdsurp:    Jensen-Shannon Distance based surprisingness.
                            ;;                 The type of surprisingness is determined by the way
                            ;;                 the truth value estimate is calculated.
                            ;;    'none:       No surprisingness measure is applied.
                            ;;    If a surprisingness measure is selected then the pattern miner returns
                            ;;     list of patterns each wrapped in an surp expression with
                            ;;    their surprisingness. Otherwise, if 'none' is selected then it returns a list of patterns.

                db-ratio    ;; db-ratio
                            ;; Controls downsampling for estimating empirical probability in surprisingness measures.  
                            ;; Downsampling reduces computational cost while maintaining accuracy.  
                            ;; Indicates the proportion of the dataset used for pattern count estimation.  
                            ;; dbr < 1 → more efficient, less accurate  
                            ;; dbr > 1 → less efficient, more accurate  
                            ;; Range: (0, +∞), default = 1.0  
                            ;; Affects only surprisingness, not frequent mining.  

;;))

;; $cnjexp $maxcnj $maxcevar

;; new space to store the init-surp results
!(bind! &res (new-space))

---------------------------------------------------------------------------
;; initializes the necessary input parameters in the KB
;;configures and runs the frequent pattern miner with conjunction expansion
;;proceeds to surprisingness pattern mining using the backward chainer 
;;Store the chainer result in to the &res (new space)
----------------------------------------------------------------------------
(= (cog-mine $db $kb $ms $surp $db-ratio $maxclauses $limit) (
    let* (
             (() (init-miner $db $kb $ms $surp $db-ratio)) 
             (() (frequent-miner $db $kb $maxclauses $limit))
            ;  (() (init-surp $kb &res $surp))           
    )
    ;; return all atoms in &res
    ; (match &res $x $x)
    (match $kb $x $x)
))


(=(min-sup) 2)
(=(surp-mode) jsdsurp)
(=(db-ratio) 0.5)

! (cog-mine &db &kb (min-sup) (surp-mode) (db-ratio) 1 2)

; !(syn &kb Z (: $prf (valuation &db ($link $nx $ny) ($valx $valy))))

; !(init-miner &db &kb (min-sup) (surp-mode) (db-ratio))

; !(conjunction (fromNumber 13) &kb 1 2)
















