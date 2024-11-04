 ; ! (register-module! ../../../hyperon-miner)
 ; ! (import! &dbspace hyperon-miner:experiments:data:sample-data)
 ; ! (import! &self hyperon-miner:experiments:rules:binding-set)
 ; ! (import! &self hyperon-miner:experiments:utils:common-utils)
 ; ! (import! &self conj-exp)
 ; ! (bind! &shabspace (new-space))
 ; ! (bind! &bindspace (new-space))

 ;; Function to retrive shallow abstraction over all variables of a pattern from a binduation space
(= (shallow-abstraction $x $y $bindspace $shabspace)

    (superpose ( (collapse (match $bindspace (BindingOf $x $z) (superpose ( (remove-atom $shabspace (ShallowAbstractionOf $x $z)) (add-atom $shabspace (ShallowAbstractionOf $x $z))))))
            (collapse (match $bindspace (BindingOf $y $t) (superpose ( (remove-atom $shabspace (ShallowAbstractionOf $y $t)) (add-atom $shabspace (ShallowAbstractionOf $y $t))))))
             ; (let $t (match $bindspace (, (BindingOf $x $c) (BindingOf $y $c)) True) (if (== $t True) (add-atom $shabspace (ShallowAbstractionOf $x $y)) Empty))
            (collapse (match $bindspace (BindingOf $y $t) (superpose (
                            (if (== (get-metatype $t) Expression)
                                (let $result (abstract-recursive $t) (superpose ( (remove-atom $shabspace (ShallowAbstractionOf $y $result)) (add-atom $shabspace (ShallowAbstractionOf $y $result)))))
                                empty
                            )
                         ; (add-atom $shabspace (ShallowAbstractionOf $y $t))
                    ))))
    (collapse (match $bindspace (BindingOf $x $z) (superpose (
                    (if (== (get-metatype $z) Expression)
                        (let $result (abstract-recursive $z) (superpose ( (remove-atom $shabspace (ShallowAbstractionOf $x $result)) (add-atom $shabspace (ShallowAbstractionOf $x $result)))))
                        empty
                    )
                 ; (add-atom $shabspace (ShallowAbstractionOf $y $t))
            ))))
)
)
)

(= (abstract-recursive $p)
    (if (not (== (get-metatype $p) Expression))
        $p
        (let* (
                ( ($link $x $y) $p)
                ( $nx (abstract-recursive $x))
                ( $ny (abstract-recursive $y))
            )
        (superpose (
                ($link $nx $w)
                ($link $z $ny)
                ($link $x $u)
                ($link $k $y)
                $p
                 ; ($link $g $o)
                ($link $nx $ny)
            )
    )
)

)
)

 ;  ; ! (abstract-recursive (Or (And T S) (And N M)) 1)

 ;  ; First, let's run the binding-set function to populate the &valspace with the valuation sets
 ; ! (binding-set Inheritance $x $y &dbspace &bindspace)

 ;  ;; Check if valuation sets are inserted correctly
 ;  ; ! (match &bindspace (BindingOf $c $d) (BindingOf $c $d))

 ;  ;; let's run the shallow-abstraction function to calculate the shallow abstraction over both variable X and Y
 ; ! (shallow-abstraction X Y &bindspace &shabspace)

 ;  ;; Check if shallow abstractions are inserted correctly
 ; ! (match &shabspace (ShallowAbstractionOf $c $d) (ShallowAbstractionOf $c $d))