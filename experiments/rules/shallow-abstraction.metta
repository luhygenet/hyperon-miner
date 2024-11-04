! (register-module! ../../../hyperon-miner)
! (import! &dbspace hyperon-miner:experiments:data:sample-data)
! (import! &self hyperon-miner:experiments:rules:valuation-set)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (import! &self conj-exp)
! (bind! &shabspace (new-space))
! (bind! &valspace (new-space))

 ;; Function to retrive shallow abstraction over all variables of a pattern from a valuation space
(= (shallow-abstraction $x $y $valspace $shabspace)

    (superpose ( (collapse (match $valspace (ValuationOf $x $z) (superpose ( (remove-atom $shabspace (ShallowAbstractionOf $x $z)) (add-atom $shabspace (ShallowAbstractionOf $x $z))))))
            (collapse (match $valspace (ValuationOf $y $t) (superpose ( (remove-atom $shabspace (ShallowAbstractionOf $y $t)) (add-atom $shabspace (ShallowAbstractionOf $y $t))))))
            (let $t (match $valspace (, (ValuationOf $x $c) (ValuationOf $y $c)) True) (if (== $t True) (add-atom $shabspace (ShallowAbstractionOf $x $y)) Empty))
            (collapse (match $valspace (ValuationOf $y $t) (superpose (
                            (if (== (is-expression $t) True)
                                (let $result (abstract-recursive $t) (superpose ( (remove-atom $shabspace (ShallowAbstractionOf $y $result)) (add-atom $shabspace (ShallowAbstractionOf $y $result)))))
                                empty
                            )
                         ; (add-atom $shabspace (ShallowAbstractionOf $y $t))
                    ))))
    (collapse (match $valspace (ValuationOf $x $z) (superpose (
                    (if (== (is-expression $z) True)
                        (let $result (abstract-recursive $z) (superpose ( (remove-atom $shabspace (ShallowAbstractionOf $x $result)) (add-atom $shabspace (ShallowAbstractionOf $x $result)))))
                        empty
                    )
                 ; (add-atom $shabspace (ShallowAbstractionOf $y $t))
            ))))
)
)
)

(= (abstract-recursive $p)
    (if (== (is-expression $p) False)
        $d
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
                ($link $g $o)
                ($link $nx $ny)
            )
    )
)

)
)

 ; ! (abstract-recursive (Or (And T S) (And N M)) 1)

 ; First, let's run the valuation-set function to populate the &valspace with the valuation sets
! (valuation-set Inheritance $x $y &dbspace &valspace)

 ;; Check if valuation sets are inserted correctly
! (match &valspace (ValuationOf $c $d) (ValuationOf $c $d))

 ;; let's run the shallow-abstraction function to calculate the shallow abstraction over both variable X and Y
! (shallow-abstraction X Y &valspace &shabspace)

 ;; Check if shallow abstractions are inserted correctly
! (match &shabspace (ShallowAbstractionOf $c $d) (ShallowAbstractionOf $c $d))