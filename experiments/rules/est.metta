! (register-module! ../../../hyperon-miner)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (import! &db  hyperon-miner:data:sample)
!(import! &self hyperon-miner:experiments:rules:emp-tv)

(: LambdaLink Type)
(: ConceptNode Type)
(: NumberNode Type)

(: LambdaT LambdaLink)
(: ConceptT hyperon::space::DynSpace)
(: NumberT Number)

(: gen-est-rule (-> hyperon::space::DynSpace  LambdaT  Number  Atom))

(:get-subpatterns (-> LambdaT Atom))




(=(list-patterns $x) (
    
    if (== $x ()) () (  
      let* (
            ($head (car-atom $x))
            ($tail (cdr-atom $x))
            ($tail_new (superpose(list-patterns $tail))))
        
        (cons-atom $head $tail_new ) 
    ))
)


;Extract subpatterns or blocks from the given nested pattern
( = (get-subpatterns $pattern) 
    (if (== , (car-atom $pattern)) (
         let $result  (list-patterns (cdr-atom $pattern)) $result
    )  $pattern   
) )

;Return variables in the pattern, later used to check the joint variable.
(=(get-variable ($link $var1 $var2)) (
    if (== $var1 $var2) $var1 ($var1 $var2)
))


(=(add-var-to-space $space $ptrns) 
(if (== $ptrns ())()(
  let* (
      ($head (car-atom $ptrns))
      ($tail (cdr-atom $ptrns))
      ($var (let $result (get-variable $head) (superpose $result)))
      ($dummy (if (== (get-type $var) %Undefined%) (add-atom $space $var) (add-reduct $space (superpose($var)))))
      )
       (add-var-to-space $space $tail)
))
)

;Extract joint variables that make the blocks dependent each other.
(=(joint-variable $space $patterns ) (
    (add-var-to-space  $space $patterns)
    (match $space $a $a )
    
))


(=(do-emp-tv $pattern) (emp-tv &db $pattern))



(: check (-> ConceptT LambdaT Atom))
(= (gen-est-rule $db $pattern $ms)
    (let $minsup_pattern (sup-eval $db $pattern $ms) ( if $minsup_pattern $minsup_pattern () )))

! (gen-est-rule &db (abebe) 2)
 ;! (get-metatype &db)

(= (check $db $pattern)
    (match $db $pattern $pattern)
)
 ; (check &db (abebe))
 ;! (match &db (abebe) yes)

 (get-subpatterns (, (Inheritance Abe human) (Inheritance Abe sodadrinker) (Inheritance Abe man)))

! (emp-tv ((Inheritance Abe human) (Abe human)) &db)

;!(do-emp-tv (Inheritance Abe human))

;!(let $result (get-variable (pattern $x $y)) (superpose $result))  

;!(joint-variable (new-space) ((Parent $x $y) (Parent $x $z)))


