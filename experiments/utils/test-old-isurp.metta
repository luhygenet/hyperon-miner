! (register-module! ../../../hyperon-miner)
! (import! &db hyperon-miner:data:ugly_man_sodaDrinker)
! (import! &self hyperon-miner:experiments:utils:isurp-old)
! (import! &self hyperon-miner:experiments:rules:est-tv)
;;! (import! &self hyperon-miner:experiments:rules:emp-tv)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (import! &self hyperon-miner:experiments:utils:TruthValue)
! (import! &self hyperon-miner:experiments:utils:gen_partition)



!(isurp_old (, (Inheritance $x man)  (Inheritance $x ugly)) &db True)



;;;;;;;;;;;
;; Tests ;;
;;;;;;;;;;;

;!(total_counts  (, (Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)) (get-space))

;!(n_conjuncts_new (, (Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)))
;!(sup-num (get-space) (Inheritance Abe $y) )

;!(prob (Inheritance Abe $y) (get-space))
;!(ptrn-support  (, (Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y) (Human Abe Kebe)) (get-space))

;!(prob  (, (Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)) (get-space))

;!(sup-num  (get-space) (Inheritance Zac $y))

;!(accumulator-x (1 2 3 4))

;!(add-pattern ((Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)) (get-space))

;!(isurp_old (, (Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)) (get-space) True)

