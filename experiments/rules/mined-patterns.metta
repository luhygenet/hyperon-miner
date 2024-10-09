(= (add-mined-pattern $minedpspace $cndpspace) (
    match $cndpspace $pat
        (superpose ( (remove-atom $minedpspace (MinedPattern $pat)) (add-atom $minedpspace (MinedPattern $pat))))
    )
)
