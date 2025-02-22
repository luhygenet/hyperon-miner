!(register-module! ../../../experiments)
!(import! &self experiments:chainer:CurriedBackward)
!(import! &self experiments:rules:isurp)
! (import! &self experiments:utils:common-utils)
! (import! &self experiments:utils:beta-dist)
! (import! &self experiments:utils:constants)
! (import! &self experiments:utils:TruthValue)
! (import! &self experiments:utils:surp-utils)
! (import! &self experiments:utils:miner-utils)
! (import! &self experiments:utils:gen_partition)
! (import! &self experiments:rules:est-tv)
! (import! &self experiments:rules:emp-tv)
! (import! &self experiments:rules:emp-prob)
! (import! &self experiments:utils:emp-tv-bs)
! (import! &self experiments:utils:bs-utils)
! (import! &kbb experiments:data:ugly_man_sodaDrinker)









;;add facts 
!(import! &kb experiments:chainer:surp:kb)
!(match &kb $x (if (== (get-type $x) hyperon::space::DynSpace) (remove-atom &kb $x) (Empty) ))
!(add-atom &kb (: FACT1 (supportOf (, (, (INHERITANCE_LINK $X $Y) (LIST_LINK A $D)) (LIST_LINK $X $G)) 4)))
!(add-atom &kb (: FACT2 (supportOf (, (, (INHERITANCE_LINK $X $Y) (LIST_LINK $F $D)) (LIST_LINK A G)) 8)))
!(add-atom &kb (: FACT3 (supportOf (, (, (INHERITANCE_LINK $X $Y) (LIST_LINK A $D)) (LIST_LINK $G $D)) 5)))
!(add-atom &kb (: FACT4 (supportOf (, (, (INHERITANCE_LINK $X $Y) (LIST_LINK L $D)) (LIST_LINK B k))  16)))
;!(add-atom &kb (surp (, (, (INHERITANCE_LINK $X $Y) (LIST_LINK $F $D)) (LIST_LINK A G)) 8))




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
                 (surp $ptrn 0.2)))))


;;Add  rules  to the kb
!(add-reduct &kb (minSup-rule))
!(add-reduct &kb (surp-rule))


;; Add constants to kb
!(add-atom &kb (: msT (ms-threshold 6)))
   !(add-atom &kb     (surp-mod 8)) 
      !(add-atom &kb   (db-ratio 9)) 
       !(add-atom &kb  (db-size 10))



 ;!(let ((db-size $value)) (superpose (match &kb $x $x)) ($value))
 ;!(let ((db-size $val) (db-ratio $val2)) ((db-size 19) (db-ratio 5) ) ($val $val2))

(=(is-number $x) (
  if (== (get-type $x) Number) True False
))




;!(syn &kb (fromNumber 2) (: $prf (surp (, (Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)) $value)))
;!(syn &kb (fromNumber 5) (: $prf (surp $what_is_surprise $value)))
;!(syn &kb (fromNumber 5) (: $prf (surpabsent (, (, (INHERITANCE_LINK $X $Y) (LIST_LINK $F $D)) (LIST_LINK A $D)))))
;!(syn &kb (fromNumber 5) (: $prf (surpabsent (, (, (INHERITANCE_LINK $X $Y) (LIST_LINK A $D)) (LIST_LINK $X G)))))
;;(, (, (INHERITANCE_LINK $X $Y) (LIST_LINK $F $D)) (LIST_LINK A $D))









;(sort (Cons (: ((surprisingness FACT1) FACT3) (surp (, (Inheritance $x $y) (Inheritance Abe $y) (Inheritance Zac $y)) 0.4))
              ;(Cons (: ((surprisingness FACT2) FACT4) (surp (, (Interact_with $x $y) (Interact_with Abe $y) (Interact_with Zac $y)) 0.2)) Nil)))

 ;;!(list_to_tuple  (Cons (value 4) (Cons (value 6) (Cons (value 5) Nil))))             


;!(tuple_to_list (1, 2, 3))


;;!(tuple_to_list (syn &kb (fromNumber 2) (: $prf (surp $what_is_surprise $value))))









;;;;;;; dummies ;;;;;;;;
;;(: ((surprisingness FACT1) FACT3) (surp (, (Inheritance $x#3544 $y#3545) (Inheritance Abe $y#3545) (Inheritance Zac $y#3545)) 0.2)),
;;(: ((surprisingness FACT2) FACT4) (surp (, (Interact_with $x#3542 $y#3543) (Interact_with Abe $y#3543) (Interact_with Zac $y#3543)) 0.2))

;!(emp-prob-pbs (, (Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)) &kb 1.0 0.7)
;!(ji_prob_est_interval (, (Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)) &kb 0.5 )
;!(do-isurp (, (Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)))

;;!(add-atom &kb (: FACT1 (minsup (,(Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)))))
;;!(add-atom &kb (: FACT2 (minsup (,(Interact_with  $x $y) (Interact_with  Abe $y) (Interact_with  Zac $y) (Interact_with  Zac $y)))))
;;!(add-atom &kb (: FACT3 (supportOf (,(Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)) 5)))
;;!(add-atom &kb (: FACT4 (supportOf (,(Interact_with $x $y)  (Interact_with  Abe $y) (Interact_with  Zac $y) (Interact_with  Zac $y)) 5)))








[(Cons ((, (, (INHERITANCE_LINK $X $Y) (LIST_LINK A $D)) (LIST_LINK $X $G)) (sup 8)) 
 (((, (, (INHERITANCE_LINK $X $Y) (LIST_LINK A $D)) (LIST_LINK $X $F)) 8) 
  (((, (, (INHERITANCE_LINK $X $Y) (LIST_LINK A $D)) (LIST_LINK $G $D)) 16) 
   (((, (, (INHERITANCE_LINK $X $Y) (LIST_LINK A $D)) (LIST_LINK $F $D)) 16) ()))))]




;!(flatten (, (, (INHERITANCE_LINK $X $Y) (LIST_LINK $X $B)) (LIST_LINK $X $B)))


;!(is-number 2)






