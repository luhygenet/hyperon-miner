(= (add-mined-pattern $minedpspace $cndpspace) (
        let $pattern (match $cndpspace $pat $pat)
        (superpose ( (remove-atom $minedpspace (MinedPattern $pattern)) (add-atom $minedpspace (MinedPattern $pattern))))
         ; (add-atom $minedpspace (MinedPattern $pattern))
    )
)
