

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


                      
                      