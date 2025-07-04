

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
                 (() (add-atom $kb (: dbref (db-ref $db))))
                 (() (add-atom $kb (: dbr (db-ratio $db-ratio))))
                 (() (add-atom $kb (: normalize (normalized True))))
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

(= (mine-surp $kb $res $surp-mode)  
  (           
        if (== $surp-mode none) 
              (chain (get-patterns $kb) $result (add-atom $res $result))  
                 (if  ( == $surp-mode jsdsurp)  
                            (chain  (syn $kb (fromNumber 13) (: $prf (jsdsurp $what_is_surprise $value))) $result   (add-atom $res $result))                          
                                   ; (chain   (syn $kb (fromNumber 4)  (: $prf (db-ref $db))) $result  $result)   
                                    ; (chain (collapser $kb (fromNumber 4)  (: $prf (surp $what_is_surprise $value))) $result  $result) 
                                     (chain (syn $kb (fromNumber 15) 
                                            (: $prf (surp-old $pattern $emin-emax))) $result  $result) 
                                     ;(chain   (collapser $kb (fromNumber 4)  (: $prf (-> (→ $q $r) (-> (→ $p $q) (-> $p $r))))) $result  $result)                                         
)))





;;;;; Dummies ;;;;;;
;; mocking the frequent pattern miner results 
(= (frequent-miner $db $kb) ( 
     let*  ( 

        ;  (() (add-atom $kb (: FACT1  (supportOf (, (, (Inheritance $x human) (Inheritance $x ugly)) (Inheritance $x woman)) 8))))
        ;  (() (add-atom $kb (: FACT2 (supportOf (, (, (Inheritance $x sodaDrinker) (Inheritance $x human)) (Inheritance $x woman)) 8))))
        ;  (() (add-atom $kb (: FACT3 (supportOf (, (, (Inheritance $x human) (Inheritance $x sodaDrinker)) (Inheritance $x man)) 4))))
        ;  (() (add-atom $kb (: FACT4 (supportOf (, (, (Inheritance $x human) (Inheritance $x sodaDrinker)) (Inheritance $x man)) 8))))

         ;; fro new surp 
         (() (add-atom $kb (: FACT1  (supportOf (, (Inheritance $x human) (Inheritance $x ugly) (Inheritance $x woman)) 5))))
         (() (add-atom $kb (: FACT2 (supportOf (, (Inheritance $x sodaDrinker) (Inheritance $x human) (Inheritance $x woman)) 5))))
         (() (add-atom $kb (: FACT3 (supportOf (,  (Inheritance $x human) (Inheritance $x sodaDrinker) (Inheritance $x ugly)) 4))))
         (() (add-atom $kb (: FACT4 (supportOf (,  (Inheritance $x human) (Inheritance $x sodaDrinker) (Inheritance $x man)) 8))))
        ; (() (add-atom $kb (: ((est-rule (((minsupport FACT4) msT) CPU)) dbref) (est-tv (, (, (Inheritance $x human) (Inheritance $x sodaDrinker)) (Inheritance $x man)) 0.6))))
        ; (() (add-atom $kb (: ((emp-rule (((minsupport FACT4) msT) CPU)) CPUEMP) (emp-val (, (, (Inheritance $x human) (Inheritance $x sodaDrinker)) (Inheritance $x man)) (EMPTV 0.5 0.7)))))
        ;; (() (add-atom $kb (: (surprisingness (((minsupport FACT4) msT) CPU)) (jsdsurp (, (, (INHERITANCE_LINK $X $Y) (LIST_LINK L $D)) (LIST_LINK B k)) 0.6))))
        ) ()
))

(: do-emp-prob (->  $db $kb atom))
(=(do-emp-prob $db $kb) ( 
   let $frq-patterns  (get-atoms $kb) 
              (let (: $fact (supportOf $pattern $support)) $frq-patterns 
                      (add-reduct $kb (empProb $pattern (prob $pattern $db))))
))

(: init-surp (->  $db $kb atom))
(= (init-surp  $db $kb)(
  let* (($res1 (collapse (do-emp-prob $db $kb)))) ()
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
         ;(nisurp-old (0.5))
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
(= (cog-mine $db $kb $ms $surp $db-ratio) (
    let* (
             (() (init-miner $db $kb $ms $surp $db-ratio)) 
             (() (frequent-miner $db $kb))
             ;($var (collapse (init-surp $db $kb)))           
              ($var (collapse (mine-surp $kb &res $surp)))           
    )
    ;; return all atoms in &res
       ;(match $kb (: $prf (empProb $pattern $prob)) (empProb $pattern $prob))
     ; (collapse (match &res $x $x))
       $var 
))






















