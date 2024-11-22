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

(= (build-specialization $link $x $y $dbspace $specspace $specredspace) (superpose (
            (let*
                (
                    ( ($subx $suby) (match $dbspace ($link $x $y) ($x $y)))
                    ($shabx (abstract-recursive $subx))
                    ($shaby (abstract-recursive $suby))
                )
            (
                superpose (
                    (add-atom $specredspace (SpecializationOf ($link $x $y) ($link $shabx $y)))
                    (add-atom $specredspace (SpecializationOf ($link $x $y) ($link $x $shaby)))
                    (add-atom $specredspace (SpecializationOf ($link $x $y) ($link $shabx $shaby)))
                )
        )
)
(let ($name $aptrn $spec) (redunpat) (add-atom $specspace (SpecializationOf $spec $aptrn)))
))
)

 ; ! (build-specialization Inheritance $x $y &dbspace &specspace &specredspace)

 ; ! (match &specspace (SpecializationOf $x $y) (SpecializationOf $x $y))
 ; ! (match &specredspace (SpecializationOf $x $y) (SpecializationOf $x $y))

 ; ! (let $res (redunpat)  $res)