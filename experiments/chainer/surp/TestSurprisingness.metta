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




;;;;;;;;;;;
;; To Do ;;
;;;;;;;;;;;

;: - Initialize Miner – Create a function to initialize the frequent pattern miner.
;: - Mine Patterns – Extract patterns that meet the minsup threshold.
;: - Launch Backward Chainer – Use the mined patterns and the surprisingness rule in the backward chainer.
;: - Calculate Surprisingness – The rule triggers do-isurp to compute the surprisingness value for patterns that satisfy it.
;: - Sort & Return – Return patterns sorted by their surprisingness value.



;; Type definition for -> to prevent early reduction
;; of the conclusions before matching the correct premises.
(: -> (-> Atom Atom Type))




;;add facts 
!(import! &kb experiments:chainer:surp:kb)
!(match &kb $x (if (== (get-type $x) hyperon::space::DynSpace) (remove-atom &kb $x) (Empty) ))
!(add-atom &kb (: FACT1 (minsup (,(Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)))))
!(add-atom &kb (: FACT2 (minsup (,(Interact_with  $x $y) (Interact_with  Abe $y) (Interact_with  Zac $y) (Interact_with  Zac $y)))))
!(add-atom &kb (: FACT3 (supportOf (,(Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)) 5)))
!(add-atom &kb (: FACT4 (supportOf (,(Interact_with $x $y)  (Interact_with  Abe $y) (Interact_with  Zac $y) (Interact_with  Zac $y)) 5)))



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
           (-> (AbsentOf $ptrn $cnt)
                 (surp $ptrn 0.2)))))


;;Add  rules  to the kb
!(add-reduct &kb (minSup-rule))
!(add-reduct &kb (surp-rule))


;; Add constants to kb
!(add-atom &kb (ms_threshold 6))

;; Action Functions
(=(do-isurp $pattern) (
     isurp $pattern &kb False 0.5
)) 

(=(is-number $x) (
  if (== (get-type $x) Number) True False
))


;; define system proofs 
;; System proof for ⍃
;; if conclusion equals (⍃ $X $Y), then return (: CPU (⍃ $X $Y)) 
;; if $x and $Y are fully grounded and (< $X $Y)
(= (syn $s_ $s_ (: CPU (⍃ $X $Y))) 
    (if (and (and (is-number $X) (is-number $Y)) (< $X $Y))
        (: CPU (⍃ $X $Y))
        (empty)))


;!(syn &kb (fromNumber 2) (: $prf (surp (, (Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)) $value)))
;!(syn &kb (fromNumber 2) (: $prf (surp $what_is_surprise $value)))




;;;;;;;;;; functions related to Conjunction ;;;;;;;;;;;;

;; Extracts conjuncts from a conjunctive expression,
(= (get-conjuncts $cnj) (
  unify (, $ncnj $ptrn) $cnj (let $result (get-conjuncts $ncnj) (cons-atom $ptrn $result) ) ($cnj)
))

;; Flattens a conjunctive expression by extracting its conjuncts using `get-conjuncts`,
;; reversing the list to maintain order, and reassembling the conjuncts into a single expression.
(= (flatten $cnj) (
  let $flatten  (reverse-list (get-conjuncts $cnj))   (cons-atom , $flatten)
))


;;;;;;;;;;;;; Sorting function ;;;;;;;;;;;;;

;(: insert_N (-> $a (List $a) (List $a)))
(= (insert_N $x Nil) (Cons $x Nil))
(= (insert_N $x (Cons $head $tail))
   (let ((: $prf ($lable $patrn $value)) (: $Tprf ($Tlable $Tpatrn $Tvalue))) ($x $head)
    ( if (< $value $Tvalue)
       (Cons $x (Cons $head $tail))
       (Cons $head (insert_N $x $tail)))))

;; Sorts a list of patterns by their surprisingness value using insertion sort.
;(: sort_surp_list (-> (List $a) (List $a)))
(= (sort_surp_list Nil) Nil)
(= (sort_surp_list (Cons $head $tail)) (insert_N $head (sort_surp_list $tail)))


;;;;;;;;;;; converters ;;;;;;;;; 
;; Converts a list to a tuple
(= (list_to_tuple Nil) ())
(= (list_to_tuple (Cons $head $tail)) (
  let $temp (list_to_tuple $tail) (cons-atom $head $temp)
))

;; Converts a tuple back to a list
(=(tuple_to_list ()) Nil)
(=(tuple_to_list $list)( 
  let ($head $tail) (decons-atom $list) (Cons $head (tuple_to_list $tail))
))


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


[((, (, (INHERITANCE_LINK $X $Y) (LIST_LINK $X $B)) (LIST_LINK $X $Y)) 
  ((, (, (INHERITANCE_LINK $X $Y) (LIST_LINK $X $B)) (LIST_LINK $X $X)) 
   ((, (, (INHERITANCE_LINK $X $Y) (LIST_LINK $X $B)) (LIST_LINK $X $B))
    ((, (, (INHERITANCE_LINK $X $Y) (LIST_LINK $X $B)) (LIST_LINK $X $D))
     ((, (, (INHERITANCE_LINK $X $Y) (LIST_LINK $X $B)) (LIST_LINK $X $A)) 
     ((, (, (INHERITANCE_LINK $X $Y) (LIST_LINK $X $B)) (LIST_LINK $Y $B)) 
     ((, (, (INHERITANCE_LINK $X $Y) (LIST_LINK $X $B)) (LIST_LINK $Y $D)) 
     ((, (, (INHERITANCE_LINK $X $Y) (LIST_LINK $X $B)) (LIST_LINK $Y $A)) 
     ((, (, (INHERITANCE_LINK $X $Y) (LIST_LINK $X $B)) (LIST_LINK $B $D)) 
     ((, (, (INHERITANCE_LINK $X $Y) (LIST_LINK $X $B)) (LIST_LINK $B $A)) ()))))))))))]





;!(flatten (, (, (INHERITANCE_LINK $X $Y) (LIST_LINK $X $B)) (LIST_LINK $X $B)))


;!(is-number 2)





