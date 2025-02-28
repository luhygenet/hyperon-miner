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



;;;;;;;;;;;;; Sorting function for surprisingness ;;;;;;;;;;;;;

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
  let ($head $tail) (decons-atom $list) (
    if (== $head ,) (tuple_to_list $tail)
    (Cons $head (tuple_to_list $tail)))
))


(=(is-number $x) (
  if (== (get-type $x) Number) True False
))
