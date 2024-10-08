;;Define compose 

;;;;;;;;;;
;; Type ;;
;;;;;;;;;;


(: pattern Type)
(: dic Type)




;; replace the variable with the key value 
(:replace (->Variable ($key $val)))
(=(replace $var ($key $val)) (
    if (
        == $var $key
    ) $val null
))

;; check if var is in the subPat list and replce it
(:mapper (->Variable dic Variable))
(= (mapper $var $subPat) (
    if (
        == $subPat ()
    ) $var (
        let* (
        ($head (car-atom $subPat))
        ($tail (cdr-atom $subPat))
        ($temp (replace $var $head))
         ($newVar (if (== $temp null) (mapper $var $tail) $temp))
        )
        
        $newVar

    )
))

;;Substitutes variables in a pattern according to a provided map
(: compose (->pattern dic pattern))
(=(compose ($link $x) $subPat) (
    let* (
        ($new_x      (   
                           case (get-metatype $x) 
                            (
                             (Expression (let $result_x (compose $x  $subPat) $result_x))
                             (Variable  (let $result_x (mapper $x $subPat) $result_x))
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
                             (Variable  (let $result_x (mapper $x $subPat) $result_x))
                             ($_ $x)
                            )
                      )
        )
        (
         $new_y    (
                           case (get-metatype $y) 
                            (
                             (Expression (let $result_y (compose $y  $subPat) $result_y))
                             (Variable  (let $result_y (mapper $y $subPat) $result_y))
                             ($_ $y)
                            )

                   )
        )
        
    ) 
        ($link  $new_x $new_y)

))



;!(compose (parent $x (human $y)) (($y $o) ($s $d) ($x $t)))
;!(check $x ())
;!(get-metatype $x)
