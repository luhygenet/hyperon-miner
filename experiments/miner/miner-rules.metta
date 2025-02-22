;; Rules 
(= (minSup-rule) 
  (: minsupport 
    (-> (supportOf $ptrn $cnt)
          (-> (ms_threshold $ms)
            (-> (⍃ $ms $cnt)
                 (minsup $ptrn))))))

(= (surp-rule)
  (: surprisingness 
    (-> (minsup $ptrn)
           (-> (surpabsent $ptrn)
                 (surp $ptrn (do-surp $ptrn))))))