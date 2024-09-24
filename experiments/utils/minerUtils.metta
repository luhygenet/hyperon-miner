;;Define compose 


(=(new_pat $var ($key $val)) (
    if (
        == $var $key
    ) $val null
))

(= (check $var $subPat) (
    if (
        == $subPat ()
    ) () (
        let* (
        ($head (car-atom $subPat))
        ($tail (cdr-atom $subPat))
        ($temp (new_pat $var $head))
         ($newVar (if (== $temp null) (check $var $tail) $temp))
        )
        
        $newVar

    )
))


(=(compose ($link $x) $subPat) (
    let* (
        ($new_x      (   
                           case (get-metatype $x) 
                            (
                             (Expression (let $result_x (compose $x  $subPat) $result_x))
                             (Variable  (let $result_x (check $x $subPat) $result_x))
                             ($_ $x)
                            )
                      )
        )
     
    ) 
        ($link  $new_x )

))

(=(compose ($link $x $y) $subPat) (
    let* (
        ($new_x      (   
                           case (get-metatype $x) 
                            (
                             (Expression (let $result_x (compose $x  $subPat) $result_x))
                             (Variable  (let $result_x (check $x $subPat) $result_x))
                             ($_ $x)
                            )
                      )
        )
        (
         $new_y    (
                           case (get-metatype $y) 
                            (
                             (Expression (let $result_y (compose $y  $subPat) $result_y))
                             (Variable  (let $result_y (check $y $subPat) $result_y))
                             ($_ $y)
                            )

                   )
        )
        
    ) 
        ($link  $new_x $new_y)

))


!(compose (parent $x (human $y)) (($y $o) ($s $d) ($x $t)))
;!(check $x ())
;!(get-metatype $x)
