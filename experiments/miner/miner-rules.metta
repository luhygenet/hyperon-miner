;; Rules 

;; Rule to check if a pattern meets the minimum support threshold.
(: minsupport 
    (-> (supportOf $ptrn $cnt)
          (-> (ms-threshold $ms)
                 (-> (⍃ $ms $cnt)
                        (minsup $ptrn)))))

;; Rule to extract abstract patterns from the database.
(: abstract-pattern
 (-> (db-ref $db)
   (-> (uniqueLink $db $ptrn $cnt)
    (-> (ms-threshold $ms)
      (-> (⍃ $ms $cnt)
       (AbstractPattern $ptrn))))))

;; Rule to specialize abstract patterns.
(: specialization
    (-> (AbstractPattern $aptrn) 
      (-> (db-ref $db)
        (specializationOf $aptrn (build-specialization-chain $aptrn $db)))))

;; rule to get candidate patterns
(: candidate  
      (-> (minsup $ptrn)
       (-> (replace_variables $ptrn)
         (candidatePattern $ptrn))))

(: candidatePattern  
      (-> (specializationOf $aptrn $sptrn)
                (candidatePattern $sptrn)))


(: supportOfff 
      (-> (minsup $ptrn)
            (-> (db-ref $db)
                  (-> (db-ratio $ratio)
                        (supportOfff $ptrn (do-sup $ptrn $db $ratio))))))


;; rule to expand conjunctions
; (: conjunction
;       (-> (candidatePattern $ptrn1)
;             (-> (candidatePattern $ptrn2)
;              (-> (replace_index $ptrn1 $nptrn1)
;               (-> (replace_index $ptrn2 $nptrn2)
;                (-> (ms-threshold $ms)
;                   (-> (db-ref $db)
;                         (conjunction (expand_conjunction $nptrn1 $nptrn2 $db $ms 2 False)))))))))

;; rule for creating conjunctions with more clauses
(: conjunction-expand
      (-> (candidatePattern $ptrn1)
      (-> (replace_index $ptrn1 $nptrn1)
         (-> (clause_count $nptrn1 $cnt)   
          (-> (maxClauses $max)
            (-> (equals $cnt $max)
            (-> (candidatePattern $ptrn2)
             (-> (replace_index $ptrn2 $nptrn2)
               (-> (ms-threshold $ms)
                  (-> (db-ref $db)
                        (conjunction (expand_conjunction $nptrn1 $nptrn2 $db $ms 2 False))))))))))))

(: conjunction-i
      (-> (conjunction $conj)
         (-> (replace_variables $conj)
            (candidatePattern $conj))))
;; rule to clean conjunctions from redundant clauses
(: remove-conjuncts-with-redundant-clause
      (-> (conjunction $ptrn)
        (-> (replace_variables $ptrn)
            (conjunction-clean (remove_conjuncts_with_redundant_clauses $ptrn)))))


;; Rule to calculate surprisingness of a pattern.
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
                      

----------------------------------------------------------------------
;; Rule to calculate the Jensen-Shannon Distance between the empirical
;; truth value and the truth value estimate of a pattern according to
;; some db.
(: jsd-tv 
            (-> (minsup $ptrn)
                 (-> (emp-val $ptrn $emp)
                       (-> (est-tv $ptrn $est)
                              (jsdsurp $ptrn (do-jsd $emp $est))))))

----------------------------------------------------------------------
;; Rule to calculate the empirical probability of a pattern.
(: emp-prob-rule 
   (->  (minsup $pattern) 
                  (-> (prob-cpu $pattern $prob)
                             (empProb $pattern $prob))))

------------------------------------------------------------------------
;;  generate partitions for a pattern.          
(: partitions 
   (-> (empProb $pattern $prob) 
         (-> (partition-cpu $pattern $partitions)
                  (partitions $pattern $partitions))))

------------------------------------------------------------------------
;; Rule to estimate the probability interval for a pattern.
(: est-prob-rule 
          (-> (partitions $pattern $partitions)
                  (-> (est-prob-cpu  $pattern $partitions $emin-emax)
                           (est-prob $pattern  $emin-emax)))) 
                           
------------------------------------------------------------------------
;; Rule to calculate the distance from the empirical probability to the estimated interval (upper bound).
(: dst-from-interval 
  (->  (empProb $pattern $emp)  
            (-> (est-prob $pattern ($emin $emax))
                   (-> (⍄ $emp $emax) 
                            (-> (dst-cpu $emp $emax $dst)
                                  (dst $pattern $dst))))))

-----------------------------------------------------------------------
;; Rule to calculate the distance from the empirical probability to the estimated interval (lower bound).
(: dst-from-interval 
  (->  (empProb $pattern $emp)
            (-> (est-prob $pattern ($emin $emax))
                   (-> (⍄ $emin $emp) 
                           (-> (dst-cpu $emin $emp $dst)
                                   (dst $pattern $dst))))))

------------------------------------------------------------------------
;; Rule to calculate the old surprisingness value (normalized True).
(: old-surp 
   (-> (normalized True) 
      (-> (empProb $pattern $emp)
           (-> (dst $pattern $dst)
                  (surp-old $pattern (min ( (// $dst $emp) 1.0)) )))))


---------------------------------------------------------------------
;; Rule to calculate the old surprisingness value (normalized False).
(: old-surp 
   (-> (normalized False) 
        (-> (empProb $pattern $emp)
               (-> (dst $pattern $dst)
                     (surp-old $pattern (min ($dst 1.0)) )))))
                                                  