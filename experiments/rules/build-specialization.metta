;  ! (register-module! ../../../hyperon-miner)
;  ! (import! &dbspace hyperon-miner:experiments:data:sample-data)
;  ! (import! &self hyperon-miner:experiments:utils:common-utils)
;  ! (bind! &specspace (new-space))
;  ! (bind! &specredspace (new-space))
! (import! &self freq-pat)


; function name: depth-handler
                ; function to handle the depth of the pattern

                ; parameters:
                    ; $p: the pattern to be handled

                ;steps
                    ; 1. check if the pattern is an expression
                    ; 2. if it is not an expression, return the pattern
                    ; 3. if it is an expression, destructure the pattern and handle the depth of the pattern by recursively getting all combinations of the variables and symbols of the pattern
(= (depth-handler $p)
    (if (not (== (get-metatype $p) Expression))
        $p
        (let* (
                ( ($link $x $y) $p)
                ( $nx (depth-handler $x))
                ( $ny (depth-handler $y))
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

; !(depth-handler (And (And C D) E))

; function name: build-specialization
                ; function to build the specialization of a pattern and add it to the specialization space

                ; parameters:
                    ; $pattern: the abstract pattern to be specialized
                    ; $dbspace: the database space to get the valuation of the pattern
                    ; $specspace: the specialization space to add the specialization to

                ;steps
                    ; 1. get the pattern
                    ; 2. get the valuation of the pattern by destructuring the pattern
                    ; 3. abstract the pattern and handle patterns with depth
                    ; 4. build the specialization
                    ; 5. add the specialization to the specialization space

(= (build-specialization ($link $x $y) $dbspace $specspace) 
            (let*
                (
                    ( ($link $x1 $y1) (replacev ($link $x $y)))                            ; replacev is a function that replaces index with variables
                    ( ($subx $suby) (match $dbspace ($link $x1 $y1) ($x1 $y1)))            ; getting the substitution /valuation of the pattern
                    ($shabx (depth-handler $subx))                                    ;handle depth in the x node
                    ($shaby (depth-handler $suby)) 
                     (() (println! (shab-⍃ ($shabx $shaby))))                                   ; handle depth in the y node
                    ($spec1 (replace (SpecializationOf ($link $shabx $y1) ($link $x $y)))) ;build the specialization and change the variables to indexs 
                    ($spec2 (replace (SpecializationOf ($link $x1 $shaby) ($link $x $y)))) ;build the specialization and change the variables to indexs
                    (() (println! (shab-⍃ ($spec1 $spec2))))
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
)

(= (build-specialization-chain ($link $x $y) $dbspace) (superpose (
            (let*
                (
                    ( ($subx $suby) (match $dbspace ($link $x $y) ($x $y))) ; getting the substitution /valuation of the pattern
                    ($shabx (depth-handler $subx))                                 
                    ($shaby (depth-handler $suby))  
                    ($spec1 ($link $shabx $y)) ;build the specialization and change the variables to indexs 
                    ($spec2 ($link $x $shaby)) ;build the specialization and change the variables to indexs
                     ; ($spec3 (replace (SpecializationOf ($link $shabx $shaby) ($link $x $y)))) ;optional
                )
            (
                superpose (
                    $spec1
                    $spec2
                    ; $spec3

                )

        )
)
 ; (let ($name $aptrn $spec) (redunpat) (add-atom $specspace (SpecializationOf $spec $aptrn)))
))
)

;  ! (build-specialization Inheritance z (s z) &dbspace &specspace &specredspace)
;  ! (build-specialization (Inheritance Z (S Z)) &dbspace &specspace)

;  ! (match &specspace (SpecializationOf $x $y) (SpecializationOf $x $y))
 ; ! (match &specredspace (SpecializationOf $x $y) (SpecializationOf $x $y))
 ; ! (match &specredspace $h $h)

 ; ! (let $res (redunpat)  $res)
