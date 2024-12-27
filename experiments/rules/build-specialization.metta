 ; ! (register-module! ../../../hyperon-miner)
 ; ! (import! &dbspace hyperon-miner:experiments:data:sample-data)
 ; ! (bind! &specspace (new-space))
 ; ! (bind! &specredspace (new-space))
! (import! &self freq-pat)

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

(= (build-specialization ($link $x $y) $dbspace $specspace) (superpose (
            (let*
                (
                    ( ($link $x1 $y1) (replacev ($link $x $y)))
                    ( ($subx $suby) (match $dbspace ($link $x1 $y1) ($x1 $y1)))
                    ($shabx (abstract-recursive $subx))
                    ($shaby (abstract-recursive $suby))
                    ($spec1 (replace (SpecializationOf ($link $shabx $y1) ($link $x $y))))
                    ($spec2 (replace (SpecializationOf ($link $x1 $shaby) ($link $x $y))))
                     ; ($spec3 (replace (SpecializationOf ($link $shabx $shaby) ($link $x $y))))
                )
            (
                superpose (
                    (remove-atom $specspace $spec1)
                    (add-atom $specspace $spec1)
                    (remove-atom $specspace $spec2)
                    (add-atom $specspace $spec2)
                    (remove-atom $specspace $spec3)
                    (add-atom $specspace $spec3)

                )

        )
)
 ; (let ($name $aptrn $spec) (redunpat) (add-atom $specspace (SpecializationOf $spec $aptrn)))
))
)

 ; ! (build-specialization Inheritance z (s z) &dbspace &specspace &specredspace)
 ; ! (build-specialization Inheritance Z (S Z) &dbspace &specspace)

 ; ! (match &specspace (SpecializationOf $x $y) (SpecializationOf $x $y))
 ; ! (match &specredspace (SpecializationOf $x $y) (SpecializationOf $x $y))
 ; ! (match &specredspace $h $h)

 ; ! (let $res (redunpat)  $res)