
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


(: cog-mine (-> db         ;; Data base space 
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
                            ;;            l    inkage into account.
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

))

(= (cog-mine $db $kb $ms $cnjexp $maxcnj $maxcevar $surp $db-ratio) (
    let* (
           (() (init-miner $db &kb $ms $surp $db-ratio)) ;; initialize parameters values
           (() (frequent-miner))   ;; Run pattern miner in a forward way
           (($su_results) (init-surp))  ;; 
    )
      (if (== $surp none) $su_results (
          let $list (tuple_to_list $su_results) (list_to_tuple (sort_surp_list $list))
      ))
))


((init-surp $kb) (
   let $surp_mode (match $kb (: surpM (surp-mod $surp)) $surp)                    ;; extract the mode of the Surprisingness
        (if (== $surp_mode none) (get-patterns)                                   ;; if the surprisingness mode is none return lis of mined patterns 
            ((syn &kb (fromNumber 5) (: $prf (surp $what_is_surprise $value)))))  ;; Launch the backward chainer for surprising patterns 
))



;; Action Functions
(=(do-surp $pattern) (
     let* (
          ($ms (match &kb (: msT (ms-threshold $ms)) $ms))
          ($surp (match &kb (surp-mod $surp) $surp))
          ($db (db-ref (match &kb (db-ref $db))))
          ($db-ratio (match &kb (db-ratio $db-ratio) $db-ratio))
          ($db-size (match &kb (db-size $db-size) $db-size))   
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




(= (init-miner $db $kb $ms $surp $db-ratio)
    (superpose ( (add-atom $kb (: msT (ms-threshold $ms))) 
                 (add-atom $kb (surp-mod $surp))
                 (add-atom $kb (db-ref $db))
                 (add-atom $kb (db-ratio $db-ratio))
                 (add-atom $kb (db-size (db_size $db)))
                 )))



;;;;;;;;;; functions related to Conjunction ;;;;;;;;;;;;

;; Extracts conjuncts from a conjunctive expression,
(= (get-conjuncts $cnj) (
  unify (, $ncnj $ptrn) $cnj (let $result (get-conjuncts $ncnj) (cons-atom $ptrn $result) ) ($cnj)
))

;; Flattens a conjunctive expression by extracting its conjuncts using `get-conjuncts`,
;; reversing the list to maintain order, and reassembling the conjuncts into a single expression.
(= (flatten $cnj) (
  let $flatten  (reverse-list (get-conjuncts $cnj))   (cons-atom , $flatten)
))



;;;;;;;;;;;;; Sorting function for surprisingness ;;;;;;;;;;;;;

;(: insert_N (-> $a (List $a) (List $a)))
(= (insert_N $x Nil) (Cons $x Nil))
(= (insert_N $x (Cons $head $tail))
   (let ((: $prf ($lable $patrn $value)) (: $Tprf ($Tlable $Tpatrn $Tvalue))) ($x $head)
    ( if (< $value $Tvalue)
       (Cons $x (Cons $head $tail))
       (Cons $head (insert_N $x $tail)))))

;; Sorts a list of patterns by their surprisingness value using insertion sort.
;(: sort_surp_list (-> (List $a) (List $a)))
(= (sort_surp_list Nil) Nil)
(= (sort_surp_list (Cons $head $tail)) (insert_N $head (sort_surp_list $tail)))


;;;;;;;;;;; converters ;;;;;;;;; 
;; Converts a list to a tuple
(= (list_to_tuple Nil) ())
(= (list_to_tuple (Cons $head $tail)) (
  let $temp (list_to_tuple $tail) (cons-atom $head $temp)
))

;; Converts a tuple back to a list
(=(tuple_to_list ()) Nil)
(=(tuple_to_list $list)( 
  let ($head $tail) (decons-atom $list) (Cons $head (tuple_to_list $tail))
))


;;;;; Dummies ;;;;;;
;; mocking the frequent pattern miner results 
((frequent-miner) (
    superpose(
        !(add-atom &kb (: FACT1 (supportOf (, (, (INHERITANCE_LINK $X $Y) (LIST_LINK A $D)) (LIST_LINK $X $G)) 4)))
        !(add-atom &kb (: FACT2 (supportOf (, (, (INHERITANCE_LINK $X $Y) (LIST_LINK $F $D)) (LIST_LINK A G)) 8)))
        !(add-atom &kb (: FACT3 (supportOf (, (, (INHERITANCE_LINK $X $Y) (LIST_LINK A $D)) (LIST_LINK $G $D)) 5)))
        !(add-atom &kb (: FACT4 (supportOf (, (, (INHERITANCE_LINK $X $Y) (LIST_LINK L $D)) (LIST_LINK B k))  16)))
    )
))



(=(test $kb) (
  let $ref (match $kb (syPrf-ref $rf) $rf) (get-atoms $ref)
))



