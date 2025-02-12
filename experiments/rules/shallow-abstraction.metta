 ; ! (register-module! ../../../hyperon-miner)
 ; ! (import! &dbspace hyperon-miner:experiments:data:sample-data)
 ; ! (import! &self hyperon-miner:experiments:rules:binding-set)
 ; ! (import! &self hyperon-miner:experiments:utils:common-utils)
! (import! &self freq-pat)
 ; ! (bind! &shabspace (new-space))
 ; ! (bind! &shabredspace (new-space))
 ; ! (bind! &bindspace (new-space))

 ;; Function to retrive shallow abstraction over all variables of a pattern from a binduation space
(= (shallow-abstraction $x $y $bindspace $shabspace $shabredspace)

    (superpose (
             ; (let $t (match $bindspace (, (BindingOf $x $c) (BindingOf $y $c)) True) (if (== $t True) (add-atom $shabspace (ShallowAbstractionOf $x $y)) Empty))
            (collapse (match $bindspace (BindingOf $y $t) (superpose (
                            (if (== (get-metatype $t) Expression)
                                (let $result (abstract-recursive $t) (superpose ( (remove-atom $shabspace (ShallowAbstractionOf $y $result)) (add-atom $shabspace (ShallowAbstractionOf $y $result)))))
                                (superpose ( (remove-atom $shabspace (ShallowAbstractionOf $y $t)) (add-atom $shabspace (ShallowAbstractionOf $y $t))))
                            )
                         ; (add-atom $shabspace (ShallowAbstractionOf $y $t))
                    ))))
    (collapse (match $bindspace (BindingOf $x $z) (superpose (
                    (if (== (get-metatype $z) Expression)
                        (let $result (abstract-recursive $z) (superpose ( (remove-atom $shabspace (ShallowAbstractionOf $x $result)) (add-atom $shabspace (ShallowAbstractionOf $x $result)))))
                        (superpose ( (remove-atom $shabspace (ShallowAbstractionOf $x $z)) (add-atom $shabspace (ShallowAbstractionOf $x $z))))
                    )
                 ; (add-atom $shabspace (ShallowAbstractionOf $y $t))
            ))))
(collapse (let ($shal $v $res) (redunpat) (add-atom $shabredspace (ShallowAbstractionOf $v $res))))
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
                $d
                ($link $g $o)
                ($link $nx $ny)
            )
    )
)

)
)

 ; First, let's run the binding-set function to populate the &valspace with the valuation sets
 ; ! (binding-set Inheritance $x $y &dbspace &bindspace)

 ;; Check if valuation sets are inserted correctly
 ; ! (match &bindspace (BindingOf $c $d) (BindingOf $c $d))

 ;; let's run the shallow-abstraction function to calculate the shallow abstraction over both variable X and Y
 ; ! (shallow-abstraction X Y &bindspace &shabspace &shabredspace)
 ; ! (let ($shal $v $res) (redunpat) ($shal $v $res))
 ; ! (let $res (redunpat) (get-metatype $res))
 ; ! (let $res (redunpat)  $res)

 ;; Check if shallow abstractions are inserted correctly
 ; ! (match &shabspace (ShallowAbstractionOf $c $d) (ShallowAbstractionOf $c (get-metatype $d)))
 ; ! (match &shabredspace (ShallowAbstractionOf X $d) (ShallowAbstractionOf X $d))
 ; ! (match &shabredspace $x $x)