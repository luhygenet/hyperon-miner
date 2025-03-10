

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
(:est-tv 
   (-> (minsup $ptrn)
         (-> (emp-tv $ptrn))
               (-> (db-ref $db)
                     (est-tv $ptrn (do-ji-tv-est $db $ptrn)))
   ))


;; Rule to calculate the empirical truth value of a pattern.
(:emp-val 
   (-> (minsup $ptrn) 
          (-> (db-ratio $ratio) 
                 (emp-val (do-emp)))))


;; Rule to calculate the Jensen-Shannon Distance between the empirical
;; truth value and the truth value estimate of a pattern according to
;; some db.
(:jsd-tv 
       (-> (emp-val $ptrn $emp)
                (-> (est-tv $ptrn $est))
                      (jsd-surp $ptrn (do-jsd $emp $est))))