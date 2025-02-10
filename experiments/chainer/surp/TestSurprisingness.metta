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
! (import! &self experiments:rules:emp-prob-pbs)



;; Type definition for -> to prevent early reduction
;; of the conclusions before matching the correct premises.
(: -> (-> Atom Atom Type))



(=(do-isurp $pattern) (
  ;; isurp $pattern &kb True 0.5
  emp-prob-pbs $pattern &kb 0.6
)) 


;;add facts 
!(import! &kb experiments:chainer:surp:kb)
!(match &kb $x (if (== (get-type $x) hyperon::space::DynSpace) (remove-atom &kb $x) (Empty) ))
!(add-atom &kb (: FACT1 (minsup (,(Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)))))
!(add-atom &kb (: FACT2 (minsup (,(Interact_with  $x $y) (Interact_with  Abe $y) (Interact_with  Zac $y)))))
!(add-atom &kb (: FACT3 (supportOf (,(Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)) 5)))
!(add-atom &kb (: FACT4 (supportOf (,(Interact_with $x $y)  (Interact_with  Abe $y) (Interact_with  Zac $y)) 5)))


;;add the surprisingness  rule to the kb
!(add-atom &kb (: surprisingness 
    (-> (minsup $ptrn)
           (-> (supportOf $ptrn $cnt)
                 (surp $ptrn 0.2)))))


;!(syn &kb (fromNumber 2) (: $prf (surp (, (Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)) $value)))
;!(syn &kb (fromNumber 2) (: $prf (surp $what_is_surprise $value)))

;;!(index-atom ($a $b $c $d $e) (random-int 0 5))
;!(random-int 0 5)


;;(: ((surprisingness FACT1) FACT3) (surp (, (Inheritance $x#3544 $y#3545) (Inheritance Abe $y#3545) (Inheritance Zac $y#3545)) 0.2)),
;;(: ((surprisingness FACT2) FACT4) (surp (, (Interact_with $x#3542 $y#3543) (Interact_with Abe $y#3543) (Interact_with Zac $y#3543)) 0.2))

;(: insert_N (-> $a (List $a) (List $a)))
(= (insert_N (value $x) Nil) (Cons (value $x) Nil))
(= (insert_N (value $x) (Cons ($z $y) $tail))
   (if (< $x $y)
       (Cons (value $x) (Cons ($z $y) $tail))
       (Cons ($z $y) (insert_N (value $x) $tail))))

;; Sort a list
;(: sort (-> (List $a) (List $a)))
(= (sort Nil) Nil)
(= (sort (Cons $head $tail)) (insert_N $head (sort $tail)))


;;!(sort (Cons (value 4) (Cons (value 6) (Cons (value 5) Nil))))

(= (create_list Nil) ())
(= (create_list (Cons $head $tail)) (
  let $temp (create_list $tail) (cons-atom $head $temp)
))

!(create_list (sort (Cons (value 4) (Cons (value 6) (Cons (value 5) Nil)))))





