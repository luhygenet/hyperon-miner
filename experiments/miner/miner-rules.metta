

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




(: abstract-pattern
  (-> (db-ref $db)
    (-> (uniqueLink $db)
      (-> (Abstract $ptrn)
        (-> (minsup $ptrn)
          (AbstractPattern $ptrn))))))
          

(: specialization
    (-> (AbstractPattern $aptrn) 
        (-> (specializationOf $aptrn (build-specialization $aptrn $dbspace)))))

(: candidatePattern  
      (-> (specializationOf $aptrn $sptrn)
                (candidatePattern $sptrn)))

(: supportOf 
      (-> (minsup $ptrn)
            (-> (db-ref $db)
                  (-> (db-ratio $ratio)
                        (supportOf $ptrn (do-sup $ptrn $db $ratio))))))


(: conjunction-expansion
      (-> (candidatePattern $ptrn1)
            (-> (candidatePattern $ptrn2)
               (-> (ms-threshold $ms)
                        (supportOf (do-conjunct) (count ))))))


;; iSurprisingness rule
(: surprisingness 
      (-> (minsup $ptrn)
            (surp $ptrn (do-surp $ptrn))))





;;(do-ji-tv-est $db $ptrn)
;; Rule to calculate the empirical truth value of a pattern.
(: emp-rule 
   (-> (minsup $ptrn) 
          (-> (db-ref $db) 
                 (emp-val $ptrn (emp-tv (flatten $ptrn) $db)))))

;;(do_emp_tv (flatten $ptrn) $db $ratio)

;; Rule to calculate the probability (or truth value) estimate of a
;; pattern, given the empirical probabilities (truth values) of its
;; components.
(: est-rule 
   (-> (minsup $ptrn)
         (-> (emp-val $ptrn $emp)
               (-> (db-ref $db)
                     (est-tv $ptrn (do-ji-tv-est $db $ptrn $emp))))))



;;(do_emp_tv $ptrn $db $ratio)
;;(do_emp_tv (flatten $ptrn) $db $ratio)


;; Rule to calculate the Jensen-Shannon Distance between the empirical
;; truth value and the truth value estimate of a pattern according to
;; some db.
(: jsd-tv 
      (-> (emp-val $ptrn $emp)
            (-> (est-tv $ptrn $est)
                  (jsdsurp $ptrn (do-jsd $emp $est)))))


                      
                      