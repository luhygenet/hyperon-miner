

;; Rules 
  (: minsupport 
    (-> (supportOf $ptrn $cnt)
          (-> (ms-threshold $ms)
                 (-> (⍃ $ms $cnt)
                        (minsup $ptrn)))))



 ;; (: surprisingness 
 ;;   (-> (minsup $ptrn)
 ;;          (-> (surpabsent $ptrn)
 ;;                  (surp $ptrn (do-surp $ptrn)))))




;; rule to extract abstract patterns from the database
(: abstract-pattern
 (-> (db-ref $db)
   (-> (uniqueLink $db $ptrn $cnt)
    (-> (ms-threshold $ms)
      (-> (⍃ $ms $cnt)
      (-> (replace_variables $ptrn)
       (AbstractPattern $ptrn)))))))
; (: abstract-pattern
;  (-> (db-ref $db)
;    (-> (uniqueLink $db $ptrn $cnt)
;        (AbstractPattern $ptrn))))

;; rule to specialize abstract patterns
(: specialization
    (-> (AbstractPattern $aptrn) 
     (-> (replace_index $aptrn $naptrn)
      (-> (db-ref $db)
        (specializationOf $naptrn (build-specialization-chain $naptrn $db))))))

(: support 
      (-> (specializationOf $aptrn $sptrn)
       (-> (db-ref $db)
          (supportOf $sptrn (counter $db $sptrn)))))


;; rule to get candidate patterns
; (: candidate  
;       (-> (minsup $ptrn)
;          (candidatePattern $ptrn)))


; (: candidate  
;       (-> (minsup $ptrn)
;        (-> (replace_variables $ptrn)
;          (candidatePattern $ptrn))))

; (: candidatePattern  
;       (-> (specializationOf $aptrn $sptrn)
;                 (candidatePattern $sptrn)))


(: supportOfff 
      (-> (minsup $ptrn)
            (-> (db-ref $db)
                  (-> (db-ratio $ratio)
                        (supportOfff $ptrn (do-sup $ptrn $db $ratio))))))


;; rule for creating conjunctions with more clauses
; (: conjunction-expand
;       (-> (candidatePattern $ptrn1)
;          (-> (clause_count $ptrn1 $cnt)   
;            (-> (maxClauses $max)
;              (-> (equals $cnt $max)
;               (-> (candidatePattern $ptrn2)
;                (-> (clause_count $ptrn2 $cnt2)
;                 (-> (equals $cnt2 1)
;                  (-> (ms-threshold $ms)
;                   (-> (db-ref $db)
;                    (candidatePattern (expand_conjunction $ptrn1 $ptrn2 $db $ms 2 False))))))))))))
; (: conjunction-expand
;       (-> (candidatePattern $ptrn1)
;        (-> (replace_index $ptrn1 $nptrn1)
;          (-> (clause_count $nptrn1 $cnt)   
;           (-> (maxClauses $max)
;             (-> (equals $cnt $max)
;             (-> (candidatePattern $ptrn2)
;              (-> (replace_index $ptrn2 $nptrn2)
;              (-> (clause_count $nptrn2 $cnt2)
;             (-> (equals $cnt2 1)
;                (-> (ms-threshold $ms)
;                   (-> (db-ref $db)
;                         (candidatePattern (expand_conjunction $nptrn1 $nptrn2 $db $ms 2 False))))))))))))))
(: conjunction-expand
      (-> (candidatePattern $ptrn1)
       (-> (replace_variables $ptrn1)
        (-> (replace_index $ptrn1 $nptrn1)
         (-> (clause_count $nptrn1 $cnt)   
          (-> (maxClauses $max)
           (-> (equals $cnt $max)
            (-> (candidatePattern $ptrn2)
             (-> (replace_variables $ptrn2)
              (-> (replace_index $ptrn2 $nptrn2)
               (-> (clause_count $nptrn2 $cnt2)
                (-> (equals $cnt2 1)
                 (-> (ms-threshold $ms)
                  (-> (db-ref $db)
                    (candidatePattern (expand_conjunction $nptrn1 $nptrn2 $db $ms 2 False))))))))))))))))

;; rule to clean conjunctions from redundant clauses
(: remove-conjuncts-with-redundant-clause
      (-> (candidatePattern $ptrn)
        (-> (replace_variables $ptrn)
            (candidate-clean (remove_conjuncts_with_redundant_clauses $ptrn)))))

(: format 
      (-> (candidate-clean $ptrn)
       (-> (replace_variables $ptrn)
       (-> (replace_index $ptrn $nptrn)
        (-> (db-ref $db)
         (has-support $nptrn (counter $db $nptrn)))))))


(: supportFormat
      (-> (candidate-clean $ptrn)
      (-> (replace_index $ptrn $nptrn)
       (-> (db-ref $db)
          (hasSupport $nptrn (counter $db $nptrn))))))

;; iSurprisingness rule
(: surprisingness 
      (-> (minsup $ptrn)
            (surp $ptrn (do-surp $ptrn))))






;; Rule to calculate the empirical truth value of a pattern.
;;(: emp-rule 
;;         (-> (minsup $ptrn) 
;;               (-> (db-ref $db) 
;;                      (-> (emp-cpu $ptrn $db $emp) 
;;                               (emp-val $ptrn (emp-tv (flatten $ptrn) $db))))))

;; Rule to calculate the empirical truth value of a pattern.
-----------------------------------------------------------------------
;; The change made was that the emp-tv function, which was 
;; previously placed in the conclusion, was interrupting the chainer.
;; So, it was moved to emp-cpu, which serves as a system-proof.
-----------------------------------------------------------------------
(: emp-rule 
       (-> (minsup $ptrn) 
              (-> (emp-cpu $ptrn $emp ) 
                      (emp-val $ptrn $emp))))




;; Rule to calculate the probability (or truth value) estimate of a
;; pattern, given the empirical probabilities (truth values) of its
;; components.
----------------------------------------------------------------------
;;For now, the emp result is not used by est-tv because it represents 
;;the pattern emp-tv , not its components. The component-wise emp-tv is 
;;calculated within the est-tv function
---------------------------------------------------------------------
(: est-rule 
    (-> (minsup $ptrn)
        (->  (emp-val $ptrn $emp)
                (->(est-cpu $ptrn $emp $est)
                      (est-tv $ptrn $est)))))
                      


;; Rule to calculate the Jensen-Shannon Distance between the empirical
;; truth value and the truth value estimate of a pattern according to
;; some db.
(: jsd-tv 
            (-> (minsup $ptrn)
                 (-> (emp-val $ptrn $emp)
                       (-> (est-tv $ptrn $est)
                              (jsdsurp $ptrn (do-jsd $emp $est))))))


                      
                      