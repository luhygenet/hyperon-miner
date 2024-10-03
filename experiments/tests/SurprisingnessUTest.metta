! (register-module! ../../../hyperon-miner)
! (import! &self hyperon-miner:experiments:utils:minerUtils)
! (import! &self hyperon-miner:experiments:rules:est-tv)
! (import! &self hyperon-miner:experiments:utils:TruthValue)

;;Test compose 
;; !(assertEqual (compose (Inheritance $y B) (($y A))) (Inheritance A B))
;; !(assertEqual (compose (Evaluation $x $y) (($x "scm-eager: absolutely-true"))) (Evaluation "scm-eager: absolutely-true" $y))
;; !(assertEqual (compose (Implication $x $y) (($x $y))) (Implication $y $y) )
;; !(assertEqual (compose x (($x sa))) (compose x (($x sa))))




;; Test avrg_tv
(=(test_avrg_tv_1)(
    let* (
       ($tv_1 ((Inheritance Abe $x) (STV 0 0.1)))
       ($tv_2 ((Inheritance John $x) (STV 0 0.1)))
       ($result (avrg_tv ($tv_1 $tv_2)))

    )
    $result 
))

!(test_avrg_tv_1)