 ; Rule to specialization a pattern
 ; ! (register-module! ../../../hyperon-miner)
 ; ! (import! &dbspace hyperon-miner:experiments:data:sample-data)
 ; ! (import! &self hyperon-miner:experiments:rules:binding-set)
 ; ! (import! &self hyperon-miner:experiments:rules:shallow-abstraction)
 ; ! (import! &self hyperon-miner:experiments:utils:common-utils)
 ;  ; ! (import! &self freq-pat)
 ; ! (bind! &shabspace (new-space))
 ; ! (bind! &shabredspace (new-space))
 ; ! (bind! &bindspace (new-space))
 ; ! (bind! &spezspace (new-space))

(= (specialize-pattern $link $x $y $shabspace $spezspace) (
        superpose (
            (match $shabspace (ShallowAbstractionOf X $t) (add-atom $spezspace (SpecializationOf ($link $x $y) ($link $t $y))))
            (match $shabspace (ShallowAbstractionOf Y $t) (add-atom $spezspace (SpecializationOf ($link $x $y) ($link $x $t))))
        )
)
)

 ;  ; First, let's run the binding-set function to populate the &valspace with the valuation sets
 ; ! (binding-set Inheritance $x $y &dbspace &bindspace)

 ;  ;; Check if valuation sets are inserted correctly
 ;  ; ! (match &bindspace (BindingOf $c $d) (BindingOf $c $d))

 ;  ;; let's run the shallow-abstraction function to calculate the shallow abstraction over both variable X and Y
 ; ! (shallow-abstraction X Y &bindspace &shabspace &shabredspace)

 ;  ;; Check if shallow abstractions are inserted correctly
 ;  ; ! (match &shabspace (ShallowAbstractionOf $c $d) (ShallowAbstractionOf $c $d))

 ;  ;; Let's now run the specialization rule
 ; ! (specialize-pattern Inheritance $x $y &shabredspace &spezspace)

 ;  ;; Check if the specializations are inserted correctly
 ; ! (match &spezspace (SpecializationOf $x $y) (SpecializationOf $x $y))
 ;  ; ! (match &spezspace $x $x)