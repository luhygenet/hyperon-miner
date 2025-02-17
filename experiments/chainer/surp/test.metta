!(register-module! ../../../experiments)
! (import! &self experiments:utils:common-utils)
!(decons-atom (1 2 3))
!(unique-atom (1 1 2 3 4 4))




(= (get-conjuncts $cnj) (
  unify (, $ncnj $ptrn) $cnj (let $result (flatten $ncnj) (cons-atom $ptrn $result) ) ($cnj)
))

(= (flatten $flatten) (
     (cons-atom , $flatten)
))

;!(flatten (get-conjuncts (, (, (Inheritance Abe $x) (Inheritance $y $x)) (Human Abe))))
!(get-conjuncts (, (, (Inheritance Abe $x) (Inheritance $y $x)) (Human Abe)))

;!(cons-atom , (Inheritance Abe $x))

;!(append-list 1 (1 2))

;((Human Abe) (, , (Inheritance Abe $x) (Inheritance $y $x)))