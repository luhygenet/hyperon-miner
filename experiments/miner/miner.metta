

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




;; Initializers
;;initialize the necessary input parameters in the KB,
(= (init-miner $db $kb $ms $surp $db-ratio)
    (         let* (  
                 (() (add-atom $kb (: msT (ms-threshold $ms))))
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
    match $kb (: $x (supportOf $pattern $value)) (($pattern) (sup $value))
))


;; extract the mode of the Surprisingness
;; if the surprisingness mode is none return lis of mined patterns
;; otherwise launches the backward chainer for surprising patterns mining
(= (init-surp $kb $res $surp-mode)  
  (           
        if (== $surp-mode none) (get-patterns $kb)                                   
              ;;(let $result  (syn $kb (fromNumber 4) (: $prf (surp $what_is_surprise $value)))   (add-atom $res $result))    
                 (syn $kb (fromNumber 4) (: $prf (surp $what_is_surprise $value)))         
))



(=(call-this) (
 superpose((: (surprisingness (((minsupport FACT4) msT) CPU)) (surp (, (, (INHERITANCE_LINK $X $Y) (LIST_LINK L $D)) (LIST_LINK B k)) 0.6))
               (: (surprisingness (((minsupport FACT4) msT) CPU)) (surp (, (, (INHERITANCE_LINK $X $Y) (LIST_LINK L $D)) (LIST_LINK B k)) 0.8)))
))




;;;;; Dummies ;;;;;;
;; mocking the frequent pattern miner results 
(= (frequent-miner $db $kb) ( 
     let*  ( (() (add-atom $kb (: FACT1 (supportOf (, (, (INHERITANCE_LINK $X $Y) (LIST_LINK A $D)) (LIST_LINK $X $G)) 4))))
         (() (add-atom $kb (: FACT2 (supportOf (, (, (INHERITANCE_LINK $X $Y) (LIST_LINK $F $D)) (LIST_LINK A G)) 8))))
         (() (add-atom $kb (: FACT3 (supportOf (, (, (INHERITANCE_LINK $X $Y) (LIST_LINK A $D)) (LIST_LINK $G $D)) 5))))
         (() (add-atom $kb (: FACT4 (supportOf (, (, (INHERITANCE_LINK $X $Y) (LIST_LINK L G)) (LIST_LINK B k))  16))))
         ;(() (add-atom $kb (: (surprisingness (((minsupport FACT4) msT) CPU)) (surp (, (, (INHERITANCE_LINK $X $Y) (LIST_LINK L $D)) (LIST_LINK B k)) 0.6))))
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
        (isurp-old 0.4)
      ;;  (isurp-old (isurp-old $ptrn $db False))
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

!(bind! &res (new-space))

(= (cog-mine $db $kb $ms $surp $db-ratio) (
    let* (
          ;; initializes the necessary input parameters in the KB
          ;;configures and runs the frequent pattern miner with conjunction expansion
          ;;proceeds to surprisingness pattern mining using the backward chainer 
             (() (init-miner $db $kb $ms $surp $db-ratio)) 
             (() (frequent-miner $db $kb)) 
            ; (() (init-surp $kb &res $surp))

            ;($res  (init-surp $kb &res $surp))
             ($res (collapse (init-surp $kb &res $surp)))
            ; ($res   (collapse (match &res (: $prf (surp $pattern $value)) (: $prf (surp $pattern $value)))))
    )
    ;; finally returns sorted patterns with their surprisingness value.
            $res
         ; ( collapse (match &res (: $prf (surp $pattern $value)) (: $prf (surp $pattern $value))))
            ;(let $surps (collapse (match $kb (: $prf (surp $pattern $value)) (: $prf (surp $pattern $value))))  $surps)
          ;(collapse (syn $kb (fromNumber 4) (: $prf (surp $what_is_surprise $value))))  
          ;(match &res $x $x)   
))






(=(cog-mine-old  $db $kb $ms $surp $db-ratio) 
   (superpose (     
             (init-miner $db $kb $ms $surp $db-ratio)
             (frequent-miner $db $kb)
             (init-surp $kb &res $surp)
             (match &res $y $y)        
))
)















