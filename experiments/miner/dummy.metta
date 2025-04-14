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


 (: minsupport 
    (-> (supportOf $ptrn $cnt)
          (-> (ms-threshold $ms)
                 (-> (⍃ $ms $cnt)
                     (minsup $ptrn)))))

(: minsupport (-> (⍃ $ms $cnt) (minsup $ptrn)))
(: minsupport (minsup $ptrn))

;; Base case
(= (syn $kb $_ (: $prf $ccln)) (match $kb (: $prf $ccln) (: $prf $ccln)))

;; Recursive step
(= (syn $kb (S $k) (: ($prfabs $prfarg) $ccln))
   (let* (((: $prfabs (-> $prms $ccln)) (syn $kb $k (: $prfabs (-> $prms $ccln))))   ;; (: minsupport (-> (⍃ $ms $cnt) (minsup $ptrn)))
          ((: $prfarg $prms) (syn $kb $k (: $prfarg $prms))))                         ;;  ((-> $prms (-> (⍃ $ms $cnt) (minsup $ptrn))))
     (: ($prfabs $prfarg) $ccln)))



;;(= (syn $kb  (S $k) (: $prf (surp $ptrn $value)))
 ;;  (let ; Recurse on surp
 ;;;       (: $prfminsup (sup $ptrn $value))
    ;;      (syn $kb  Z (: $prfsup (sup $ptrn $value)))
      ;;         (:$prfminsup (sup $ptrn $value))))






(supportOf (, (, (Inheritance Z human) (Inheritance Z sodaDrinker)) (Inheritance Z woman)) 5), 
(supportOf (, (, (Inheritance Z human) (Inheritance Z ugly)) (Inheritance Z woman)) 5), 
(supportOf (, (, (Inheritance Z sodaDrinker) (Inheritance Z human)) (Inheritance Z woman)) 5), 
(supportOf (, (, (Inheritance Z human) (Inheritance Z sodaDrinker)) (Inheritance Z man)) 5), 
(supportOf (, (, (Inheritance Z sodaDrinker) (Inheritance Z man)) (Inheritance Z human)) 5), 
(supportOf (, (, (Inheritance Z human) (Inheritance Z woman)) (Inheritance Z ugly)) 5), 
(supportOf (, (, (Inheritance Z ugly) (Inheritance Z sodaDrinker)) (Inheritance Z human)) 5), 
(supportOf (, (, (Inheritance Z man) (Inheritance Z human)) (Inheritance Z ugly)) 5), 
(supportOf (, (, (Inheritance Z human) (Inheritance Z ugly)) (Inheritance Z man)) 5), 
(supportOf (, (, (Inheritance Z sodaDrinker) (Inheritance Z human)) (Inheritance Z ugly)) 5), 
(supportOf (, (, (Inheritance Z sodaDrinker) (Inheritance Z human)) (Inheritance Z man)) 5), 
(supportOf (, (, (Inheritance Z ugly) (Inheritance Z man)) (Inheritance Z sodaDrinker)) 5), 
(supportOf (, (, (Inheritance Z sodaDrinker) (Inheritance Z woman)) (Inheritance Z human)) 5)




[(
(: (surprisingness (((minsupport FACT2) msT) CPU)) (surp (, (, (Inheritance $x#12522 sodaDrinker) (Inheritance $x#12522 human)) (Inheritance $x#12522 woman)) 0.00026951691400994854)) 
(: (surprisingness (((minsupport FACT3) msT) CPU)) (surp (, (, (Inheritance $x#12521 human) (Inheritance $x#12521 sodaDrinker)) (Inheritance $x#12521 man)) 0.0001882464522392705)) 
(: (surprisingness (((minsupport FACT4) msT) CPU)) (surp (, (, (Inheritance $x#12520 human) (Inheritance $x#12520 sodaDrinker)) (Inheritance $x#12520 man)) 0.00013659998646536493)))]



umsd_pattern = (LambdaLink
  (Variable "$X") ; [19679d5b361ad95f][1]
  (PresentLink
    (InheritanceLink
      (Variable "$X") ; [19679d5b361ad95f][1]
      (Concept "man") ; [1b55d1968390f6e6][1]
    ) ; [967d17e2430fb150][1]
    (InheritanceLink
      (Variable "$X") ; [19679d5b361ad95f][1]
      (Concept "soda drinker") ; [62707e4ca36d19af][1]
    ) ; [f2e33e97fd92a096][1]
    (InheritanceLink
      (Variable "$X") ; [19679d5b361ad95f][1]
      (Concept "ugly") ; [f273cc9fde1bcc6][1]
    ) ; [fcf0a6b2cedd2ac8][1]
  ) ; [8ec2901544b47ca4][1]
)


(,(Inheritance $x man) (Inheritance $x sodaDrinker) (Inheritance $x ugly))




ugly_man_pattern (LambdaLink
  (Variable "$X") ; [19679d5b361ad95f][1]
  (PresentLink
    (InheritanceLink
      (Variable "$X") ; [19679d5b361ad95f][1]
      (Concept "man") ; [1b55d1968390f6e6][1]
    ) ; [967d17e2430fb150][1]
    (InheritanceLink
      (Variable "$X") ; [19679d5b361ad95f][1]
      (Concept "ugly") ; [f273cc9fde1bcc6][1]
    ) ; [fcf0a6b2cedd2ac8][1]
  ) ; [d37451a9f223477a][1]
)