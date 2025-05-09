

;; Rules 
  (: minsupport 
    (-> (supportOf $ptrn $cnt)
          (-> (ms-threshold $ms)
                 (-> (⍃ $ms $cnt)
                       (minsup $ptrn)))))

;; rule to extract abstract patterns from the database
(: abstract-pattern
 (-> (db-ref $db)
   (-> (uniqueLink $db $ptrn $cnt)
    (-> (ms-threshold $ms)
      (-> (⍃ $ms $cnt)
       (AbstractPattern $ptrn))))))

;; rule to specialize abstract patterns
(: specialization
    (-> (AbstractPattern $aptrn) 
      (-> (db-ref $db)
        (specializationOf $aptrn (build-specialization-chain $aptrn $db)))))

;; rule to get candidate patterns
(: candidate  
      (-> (minsup $ptrn)
         (candidatePattern $ptrn)))

;; rule to get the support of specialized patterns

(: hasSupport 
      (-> (specializationOf $aptrn $sptrn)
            (-> (db-ref $db)
                (supportOf $sptrn (counter $db $sptrn)))))

;; rule to expand conjunctions
(: conjunction
      (-> (candidatePattern $ptrn1)
            (-> (candidatePattern $ptrn2)
               (-> (ms-threshold $ms)
                  (-> (db-ref $db)
                        (conjunction (expand_conjunction $ptrn1 $ptrn2 $db $ms 2 False)))))))

;; rule for creating conjunctions with more clauses
(: conjunction-next
      (-> (conjunction-clean $ptrn1)
            (-> (candidatePattern $ptrn2)
               (-> (ms-threshold $ms)
                  (-> (db-ref $db)
                        (conjunction (expand_conjunction $ptrn1 $ptrn2 $db $ms 2 False)))))))

;; rule to clean conjunctions from redundant clauses
(: remove-conjuncts-with-redundant-clause
      (-> (conjunction $ptrn)
            (conjunction-clean (remove_conjuncts_with_redundant_clauses $ptrn1))))



;; iSurprisingness rule
(: surprisingness 
      (-> (minsup $ptrn)
            (surp $ptrn (do-surp $ptrn))))






;; Rule to calculate the probability (or truth value) estimate of a
;; pattern, given the empirical probabilities (truth values) of its
;; components.
(: est-rule 
   (-> (minsup $ptrn)
         (-> (emp-val $ptrn $emp)
               (-> (db-ref $db)
                     (est-tv $ptrn (do-ji-tv-est $db $ptrn))))))



;;(do-ji-tv-est $db $ptrn)
;; Rule to calculate the empirical truth value of a pattern.
(: emp-val 
   (-> (minsup $ptrn) 
          (-> (db-ref $db) 
                 (-> (db-ratio $ratio)
                           (emp-val $ptrn (do_emp_tv $ptrn $db $ratio))))))


;;(do_emp_tv $ptrn $db $ratio)
;;(do_emp_tv (flatten $ptrn) $db $ratio)


;; Rule to calculate the Jensen-Shannon Distance between the empirical
;; truth value and the truth value estimate of a pattern according to
;; some db.
(: jsd-tv 
      (-> (emp-val $ptrn $emp)
            (-> (est-tv $ptrn $est)
                  (jsdsurp $ptrn (do-jsd $emp $est)))))


                      
                      