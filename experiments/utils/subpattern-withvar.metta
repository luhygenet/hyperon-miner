(=(is-pattern $expr) (
    collapse(
 or (unify $expr ($link $x $y) (
       and (is-symbol $link) (
        or (or (is-variable $x) (is-expression $x))
             (or (is-variable $y) (is-expression $y)))) False)
    (unify $expr ($link $x) 
       (and (is-symbol $link) 
        (or (is-variable $x) 
            (is-expression $x))) False ) )))
            
(=(is-present $atom ()) False)
(=(is-present $atom $list) (
    if (is-expression $list) (
    let ($head $tail) (decons-atom $list) (
        if (== $atom $head) True  (or (is-present $atom $head) (is-present $atom $tail))
    )) (if (== $atom $head) True False)))

(=(is-symbol $var) 
   (== (get-metatype $var) Symbol)
)

(=(is-variable $var) 
   (== (get-metatype $var) Variable)
)

(=(is-expression $var) 
  (== (get-metatype $var) Expression)
)

(=(checkIntersection $var $set) 
    (not (== ((intersection-atom ($var) $set)) (())))) 

; (=(process-pattern $acc $pattern $var)
;  (if (== (get-metatype $pattern) Symbol) 
;         $acc 
;         (let* (
;                 ($is_pattern (let $pat_temp (is-pattern $pattern) (car-atom $pat_temp))) 
;                 ($is_expression (== (get-metatype $pattern) Expression)) 
;                 ($vars (cdr-atom $pattern)) 
;                 ($is_connected (checkIntersection $var $vars))) 
;             (if (and (and $is_pattern $is_expression) $is_connected)
;                 (cons-atom $pattern $acc) 
;                 $acc))))

(=(process-pattern  $pattern $var)
 
         
        (let* (
                ($is_pattern (let $pat_temp (is-pattern $pattern) (car-atom $pat_temp))) 
                ($is_expression (== (get-metatype $pattern) Expression)) 
                ($vars (cdr-atom $pattern)) 
                ($is_connected (checkIntersection $var $vars))) 
            (if (and (and $is_pattern $is_expression) $is_connected)
                $pattern 
                (empty))))

; (=(connected-subpatterns-with-var $partition $var)


;     (foldl-atom $partition () $acc $pattern (process-pattern $acc $pattern $var)))

(=(connected-subpatterns-with-var $partition $var)
(let* (($no-comma (cdr-atom $partition))
($return (collapse (process-pattern (superpose $no-comma ) $var)))

) (cons-atom , $return )
    )
    
    
    
    
    )




!(connected-subpatterns-with-var (, (Inheritance $x $y) (Inheritance $y $z) (Inheritance $j $f) (Constant 42) (Inheritance $z $k)) $y)






