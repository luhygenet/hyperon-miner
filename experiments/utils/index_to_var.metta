! (register-module! ../../../hyperon-miner)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (import! &self hyperon-miner:experiments:rules:freq-pat)


(= (func $pattern)
    (let* (
        ($head (car-atom $pattern))
        ($tail (cdr-atom $pattern))
        ($res (if (== (get-type $head) Nat) (concatTuple ($head) $list) $list))
        ($fin (func $tail $res))
    )
    ; (cons $head (func $tail ()))
    ; (func $tail $res)
    $res
    )
)

!(func (Inheritance Z (S (S Z))))
   !(filter-atom 
   (collapse (Inheritance Z (S (S Z))))
    ; $x (== (get-type $x) Nat)
    $x
    $x
    )












!(for-each-in-atom (($x 1) ($y 2) ($z 3)) (if (== (car-atom ))) )


!(track (($x 1) ($y 2) ($z 3)) $y)

!(filter-atom ($x $y $z) $v (eval (equals $v $y)))

!(eval (car-atom ($x 1)))

!(=alpha (,(Father $Jhon) (Fathr $Bob)) (,(Fathr $Bob) (Father $Jhon)))


!(eval (equals ($Father $Jhon) $Father))