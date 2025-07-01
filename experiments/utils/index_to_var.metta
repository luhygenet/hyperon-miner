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

(= (debruijn2num Z) 0)

(= (debruijn2num (S $k)) (+ 1 (debruijn2num $k)))

(= (fromNum $n) (if (<= $n 0) Z (S (fromNum (- $n 1)))))
; !(filter (($x 1) ($y 2) ($z 3)) $v (eval (equals $v $y)))

(= (deb2var $pattern)
    (map-atom $pattern $x (if (== (get-type $x) Nat) (gen_var (eval (debruijn2num $x))) (if (and (not (== (get-type $x) Nat)) (== (get-metatype $x) Expression)) (deb2var $x) $x))) ;
)
(= (num2deb $pattern)
    (map-atom $pattern $x (if (== (get-type $x) Number) (fromNumber $x) (if (and (not (== (get-type $x) Number)) (== (get-metatype $x) Expression)) (num2deb $x) $x)))
)
; !(num2deb (,(, (link 1 2) (an 3 1)) (this 2 4)))

; !(filter (1 2 3 4 5) $x (eval (> $x 3))) 
!(map-atom (Inheritance 1 2) $x (if (== (get-type $x) Number) (fromNum $x) $x))
(= (randomvar) 
    (random)
)

(= (check $list $var)
   (if (== (intersection-atom $list $var) ()) False True)
)
!(check ($1 $x $y) ($x))

(= (var2deb $pattern)
)

!(var2deb (,(, (link $x $y) (an $o $y)) (this $x $t)))
!(var2deb (Inheritance $x $y))
; !(index-atom ($x $y 1) 1)
; !(get-metatype 1)
!(union-atom ($x) ())

(= (equals $x $y)
    ; (== $x $y)
    (function
        (eval (chain (== (car-atom $x) $y) $v
            (return $v))))
)
(= (track $list $var)
    (filter-atom $list $v (eval (equals $v $var)))
)

; !(for-each-in-atom (($x 1) ($y 2) ($z 3)) (if (== (car-atom ))) )


; !(track (($x 1) ($y 2) ($z 3)) $y)

; !(filter-atom ($x $y $z) $v (eval (equals $v $y)))

; !(eval (car-atom ($x 1)))

; !(=alpha (,(Father $Jhon) (Fathr $Bob)) (,(Fathr $Bob) (Father $Jhon)))


; !(eval (equals ($Father $Jhon) $Father))