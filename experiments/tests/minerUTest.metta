! (register-module! ../../../hyperon-miner)
! (import! &self hyperon-miner:experiments:utils:minerUtils)

;;Test compose 
!(assertEqual (compose (Inheritance $y B) (($y A))) (Inheritance A B))
!(assertEqual (compose (Evaluation $x $y) (($x "scm-eager: absolutely-true"))) (Evaluation "scm-eager: absolutely-true" $y))
!(assertEqual (compose (Implication $x $y) (($x $y))) (Implication $y $y) )
;!(assertEqual (compose x (($x sa))) (compose x (($x sa))))