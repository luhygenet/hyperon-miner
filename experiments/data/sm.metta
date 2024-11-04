! (register-module! ../../../hyperon-miner)
! (import! &dbspace hyperon-miner:experiments:data:sample-data)
! (bind! &nwspace (new-space))
(= (try)
    (match &dbspace $x (superpose ( (remove-atom &nwspace $x) (add-atom &nwspace $x))))
)

! (try)
! (match &nwspace $x $x)