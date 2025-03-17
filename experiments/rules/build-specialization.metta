 ; ! (register-module! ../../../hyperon-miner)
 ; ! (import! &dbspace hyperon-miner:experiments:data:sample-data)
 ; ! (bind! &specspace (new-space))
 ; ! (bind! &specredspace (new-space))
! (import! &self freq-pat)

;steps
; 1. get the pattern
; 2. get the valuation of the pattern by destructuring the pattern
; 3. abstract the pattern and handle patterns with depth
; 4. build the specialization
; 5. add the specialization to the specialization space

 
; handle patterns with depth
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

; build specialization
(= (build-specialization ($link $x $y) $dbspace $specspace) (superpose (
            (let*
                (
                    ( ($link $x1 $y1) (replacev ($link $x $y)))                            ; replacev is a function that replaces index with variables
                    ( ($subx $suby) (match $dbspace ($link $x1 $y1) ($x1 $y1)))            ; getting the substitution /valuation of the pattern
                    ($shabx (abstract-recursive $subx))                                    ;handle depth in the x node
                    ($shaby (abstract-recursive $suby))                                    ; handle depth in the y node
                    ($spec1 (replace (SpecializationOf ($link $shabx $y1) ($link $x $y)))) ;build the specialization and change the variables to indexs 
                    ($spec2 (replace (SpecializationOf ($link $x1 $shaby) ($link $x $y)))) ;build the specialization and change the variables to indexs
                     ; ($spec3 (replace (SpecializationOf ($link $shabx $shaby) ($link $x $y)))) ;optional
                )
            (
                superpose (
                    (remove-atom $specspace $spec1) ; remove the old specialization to avoid redundancy
                    (add-atom $specspace $spec1) ; add the new specialization
                    (remove-atom $specspace $spec2)
                    (add-atom $specspace $spec2)
                    ; (remove-atom $specspace $spec3)
                    ; (add-atom $specspace $spec3)

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