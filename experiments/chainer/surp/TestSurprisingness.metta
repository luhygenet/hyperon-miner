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
   isurp $pattern &kb True 0.5
))


;;add facts 
!(import! &kb experiments:chainer:surp:kb)
!(match &kb $x (if (== (get-type $x) hyperon::space::DynSpace) (remove-atom &kb $x) (Empty) ))
!(add-atom &kb (: FACT1 (minsup (,(Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)))))
!(add-atom &kb (: FACT2 (minsup (,(Interact_with  $x $y) (Interact_with  Abe $y) (Interact_with  Zac $y)))))
!(add-atom &kb (: FACT3 (supportOf (,(Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)) 5)))
!(add-atom &kb (: FACT4 (supportOf (,(Interact_with $x $y)  (Interact_with  Abe $y) (Interact_with  Zac $y)) 5)))


;;add the rule to the kb
!(add-atom &kb (: surprisingness 
    (-> (minsup $ptrn)
        (-> (supportOf $ptrn $cnt)
            (surp $ptrn (do-isurp $ptrn))))))

;;!(syn &kb (fromNumber 2) (: $prf (surp (,(Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)) $value)))
!(syn &kb (fromNumber 2) (: $prf (surp $what_is_surprise $value)))


;;!(do-isurp (,(Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)))


(= (substitute $pattern ()) $pattern)
(= (substitute () $variables) ())
 (= (substitute $pattern $variables)
     (let* (
             ($head (car-atom $pattern))
             ($tail (cdr-atom $pattern)))

         (if (== (get-metatype $head) Expression)
             (case $head
                 ( ( ($link $x $y) (concatTuple
                             (substitute $head $variables)
                             (substitute $tail (let $temp (cdr-atom $variables) (cdr-atom $temp)))))
                     ( ($link $x ) (concatTuple
                             (substitute $head $variables)
                             (substitute $tail (cdr-atom $variables))))))

             (if (== (get-metatype $head) Variable)
                 (concatTuple ( (car-atom $variables)) (substitute $tail (cdr-atom $variables)))
                 ( (concatTuple ($head) (substitute $tail $variables))))
         )
 )
 )

;;! (substitute (LIST_LINK (INHERITANCE_LINK A $D) (LIST_LINK G $G)) ($A $B))

(LIST_LINK (INHERITANCE_LINK A $A) (LIST_LINK G $B))

 
(=(substitute_new $term (, $x $z) $args) (
    let (, $x $z)  $args $term
))

;;!(substitute_new (LIST_LINK (Inheritance A $x) (Inheritance G $z)) (, $x $z) (, $a $d))

;;!(compose (LIST_LINK (INHERITANCE_LINK A $D) (LIST_LINK G $G)) (($D $B) ($G $A)))

;;!(get-type "(, (Inheritance $x#3542 $y#3543) (Inheritance Abe $y#3543) (Inheritance Zac $y#3543) ")
