 ;Creates truth value to be use on cog-set-tv stv is just an alias
(: cog-new-stv (-> Number Number Tuple))
(= (cog-new-stv $mean $confidence)
    (stv $mean $confidence))

 ; Returns truth value of an atom
(: cog-tv (-> Atom Boolean))
(= (cog-tv $atom)
    (match &self (ConceptNode $atom $stv) $stv)
)

 ;Check if expression is truth value or not
(: cog-tv? (-> Atom Boolean))
(= (cog-tv? $EXP)
    (if (== (match &self (stv $mean $conf) True) True)
        True
        False
    )
)

 ;The tuple is like (SimpleTruthValue 0.9 0.8)
(: cog-set-tv (-> Atom Tuple Atom))
(= (cog-set-tv $atom $tv)
    (ConceptNode $atom $tv)) ;;probably needs add-atom to be added to space

