

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
   (-> (uniqueLink $ptrn $cnt)
    (-> (ms-threshold $ms)
      (-> (⍃ $ms $cnt)
      (-> (replace_variables $ptrn)
       (AbstractPattern $ptrn))))))
; (: abstract-pattern
;  (-> (db-ref $db)
;    (-> (uniqueLink $db $ptrn $cnt)
;        (AbstractPattern $ptrn))))

;; rule to specialize abstract patterns
; (: specialization
;     (-> (AbstractPattern $aptrn) 
;      (-> (replace_index $aptrn $naptrn)
;       (-> (db-ref $db)
;         (specializationOf $naptrn (build-specialization-chain $naptrn $db))))))

(: specializationx
       (-> (AbstractPattern ($link $x $y)) 
        (-> (replace_index ($link $x $y) ($link $nx $ny)) 
          (-> (valuation X ($link $nx $ny) $valx)
            (-> (depth-handler $valx $shabx)
            (-> (replace_variables ($shabx $ny))
              (specializationOf ($link $x $y) ($link $shabx $ny))))))))
(: specializationy
       (-> (AbstractPattern ($link $x $y)) 
        (-> (replace_index ($link $x $y) ($link $nx $ny)) 
          (-> (valuation Y ($link $nx $ny) $valy)
            (-> (depth-handler $valy $shaby)
            (-> (replace_variables ($nx $shaby))
              (specializationOf ($link $x $y) ($link $nx $shaby))))))))

(: support 
      (-> (specializationOf $aptrn $sptrn)
      (-> (replace_index $sptrn $nsptrn) 
       (-> (db-ref $db)
          (supportOf $sptrn (counter $db $nsptrn))))))



(: supportOfff 
      (-> (minsup $ptrn)
            (-> (db-ref $db)
                  (-> (db-ratio $ratio)
                        (supportOfff $ptrn (do-sup $ptrn $db $ratio))))))



(: conjunction-expand
      (-> (candidatePattern $ptrn1)
       (-> (replace_index $ptrn1 $nptrn1)
         (-> (clause_count $nptrn1 $cnt)   
          (-> (maxClauses $max)
           (-> (equals $cnt $max)
            (-> (candidatePattern $ptrn2)
              (-> (replace_index $ptrn2 $nptrn2)
               (-> (clause_count $nptrn2 $cnt2)
                (-> (equals $cnt2 1)
                 (-> (ms-threshold $ms)
                  (-> (get_variables $nptrn1 $vars1)
                   (-> (get_variables $nptrn2 $vars2)
                    (-> (combine_variables $vars1 $vars2 $comb)
                     (-> (substitute_variables $nptrn2 $comb ($subptrn2 $remaining))
                      (-> (replace_variables (, $nptrn1 $subptrn2))
                      (-> (conjunction_clean (, $nptrn1 $subptrn2))
                       (candidatePattern (, $nptrn1 $subptrn2)))))))))))))))))))


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


                      
                      