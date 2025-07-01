! (register-module! ../../../hyperon-miner)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (import! &self hyperon-miner:experiments:rules:freq-pat)


; (= (func $pattern)
;     (let* (
;         ($head (car-atom $pattern))
;         ($tail (cdr-atom $pattern))
;         ($res (if (== (get-type $head) Nat) (concatTuple ($head) $list) $list))
;         ($fin (func $tail $res))
;     )
;     ; (cons $head (func $tail ()))
;     ; (func $tail $res)
;     $res
;     )
; )

; !(func (Inheritance Z (S (S Z))))
;    !(filter-atom 
;    (collapse (Inheritance Z (S (S Z))))
;     ; $x (== (get-type $x) Nat)
;     $x
;     $x
;     )

(@doc noeval
  (@desc "Returns its argument")
  (@params (
    (@param "Input argument")))
  (@return "Input argument"))
(: noeval (-> Atom Atom))
(= (noeval $x) $x)

(: atom-subs (-> Atom Variable Atom Atom))
(= (atom-subs $atom $var $templ)
  (function (chain (eval (noeval $atom)) $var (return $templ))) )

; !(eval (atom-subs ($x 1) $v (== (car-atom $v) $x)))
; !(eval (== (eval (car-atom ($x 1)))  $x))
(: filter (-> Expression Variable Atom Expression))
(= (filter $list $var $filter)
  (function (eval (if-decons-expr $list $head $tail
    (chain (eval (filter $tail $var $filter)) $tail-filtered
      (chain (eval (atom-subs $head $var $filter)) $filter-expr
        (chain $filter-expr $is-filtered
          (eval (if $is-filtered
            (chain (cons-atom $head $tail-filtered) $res (return $res))
            (return $tail-filtered) )))))
    (return ()) ))))












; !(for-each-in-atom (($x 1) ($y 2) ($z 3)) (if (== (car-atom ))) )


; !(track (($x 1) ($y 2) ($z 3)) $y)

; !(filter-atom ($x $y $z) $v (eval (equals $v $y)))

; !(eval (car-atom ($x 1)))

; !(=alpha (,(Father $Jhon) (Fathr $Bob)) (,(Fathr $Bob) (Father $Jhon)))


; !(eval (equals ($Father $Jhon) $Father))