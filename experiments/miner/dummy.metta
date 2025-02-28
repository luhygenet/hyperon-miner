(= (syn-old $kb $_ (: $prf (surp $ptrn $value))) 
      (if (> (counter $kb (surp $ptrn $value)) 0) ;; use match here
             (empty)
               (: CpuSurp (surp $ptrn $value))))


(= (syn-old $kb $env (S $k) (: $prf (surp $ptrn $value)))
   (let ; Recurse on minsup
        (: $prfminsup (minsup $ptrn))
          (syn $kb $env Z (: $prfminsup (minsup $ptrn)))
            (when ... ...)))


;; Recursive step
(= (syn-old $kb (S $k) (: ($prfabs $prfarg) $ccln))
   (let* (((: $prfabs (-> $prms $ccln)) (syn $kb $k (: $prfabs (-> $prms $ccln))))
          ((: $prfarg $prms) (syn $kb $k (: $prfarg $prms))))
     (: ($prfabs $prfarg) $ccln)))



;; Base case
(= (syn $kb $_ (: $prf $ccln)) (match $kb (: $prf $ccln) (: $prf $ccln)))

;; Recursive step
(= (syn $kb (S $k) (: ($prfabs $prfarg) $ccln))
   (let* (((: $prfabs (-> $prms $ccln)) (syn $kb $k (: $prfabs (-> $prms $ccln))))
          ((: $prfarg $prms) (syn $kb $k (: $prfarg $prms))))
     (: ($prfabs $prfarg) $ccln)))
