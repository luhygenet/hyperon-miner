;;;;;;;;;;;;;;;;;;
;; Common Utils ;;
;;;;;;;;;;;;;;;;;;

(= (decons-atom $exp)
    ((car-atom $exp) (cdr-atom $tail))
)

(= (concatTuple $xs $ys)
    (if (== $xs ())
        $ys
        (let* ( (($head $tail) (decons-atom $xs))
                ($tailNew (concatTuple $tail $ys)))
                 (cons-atom $head $tailNew))  ))

(=(remove-parenthesis $x) (
    let ($head $tail) (decons-atom $x) (if (== $tail ()) (remove-parenthesis $head) $x)
))


(= (get-variables $pattern)
    (if (== $pattern ())
        ()
        (let* (
                ($head (car-atom $pattern))
                ($tail (cdr-atom $pattern)))

            (if (== (get-metatype $head) Expression)
                (concatTuple (get-variables $head)
                    (get-variables $tail))
                (if (== (get-metatype $head) Variable)
                    (concatTuple
                        ($head)
                        (get-variables $tail))

                    (get-variables $tail))))
    )
)


(=(is-symbol $var) 
   (== (get-metatype $var) Symbol)
)

(=(is-variable $var) 
   (== (get-metatype $var) Variable)
)

(=(is-expression $var) 
  (== (get-metatype $var) Expression)
)

(=(reverse-list ()) ())
(=(reverse-list $subparts)(
      let ($head $tail) (decons-atom $subparts) (push-back $head (reverse-list $tail))
))


(=(remove-element $element ())())
(=(remove-element $element $list) (
    let ($head $tail) (decons-atom $list) (
        if (== $element $head) (remove-element $element $tail) (
            let $dummy (remove-element $element $tail) (cons-atom $head $dummy)))))



(=(append-list $atom ()) ($atom))
(=(append-list $atom $list) (
    let* (
        (($head $tail) (decons-atom $list))
        ($dummy (append-list $head $tail))
    ) 
     (cons-atom $atom $dummy)))


(=(append-list-v2 $atom ()) ($atom))
(=(append-list-v2 $atom $list) (
    let* (
        (($head $tail) (decons-atom $list))
        ($dummy ((append-list $head $tail)))
    ) 
     (cons-atom $atom $dummy)))


(=(push-back $atom ()) ($atom))
(=(push-back $atom $list) (
    let* ((($head $tail) (decons-atom $list))
        ($dummy (push-back $atom $tail))) 
     (cons-atom $head $dummy)))


(=(insert () $res) $res)
(=(insert $subparts $res)(
      let ($head $tail) (decons-atom $subparts) (let $temp (push-back $head $res) (insert $tail $temp))))

(=(is-present $atom ()) False)
(=(is-present $atom $list) (
    if (is-expression $list) (
    let ($head $tail) (decons-atom $list) (
        if (== $atom $head) True  (or (is-present $atom $head) (is-present $atom $tail))
    )) (if (== $atom $head) True False)))


(=(is-pattern $expr) (
    collapse(
 or (unify $expr ($link $x $y) (
       and (is-symbol $link) (
        or (or (is-variable $x) (is-expression $x))
             (or (is-variable $y) (is-expression $y)))) False)
    (unify $expr ($link $x) 
       (and (is-symbol $link) 
        (or (is-variable $x) 
            (is-expression $x))) False )  )))

(=(is-valid () $partion) True)
(=(is-valid $clous $partion)(
    let ($head $tail) (decons-atom $clous)  (and (is-present $head $partion) (is-valid $tail $partion)) ))            

(=(comp $main_head ()) ())
(=(comp $main_head $list)(
    let* (
        (($x $tail) (decons-atom $list))
        ($rst (append-list (append-list $main_head  $x) (comp  $main_head $tail)))   
    ) $rst))


(=(get-clouses () ) ())
(= (get-clouses $pattern)
        (let* (
                (($head $tail) (decons-atom $pattern)))
            (if (== (get-metatype $head) Expression)
                (   let $result  (concatTuple ($head)
                    (get-clouses $tail)) (concatTuple $result (get-clouses $head)))
                    (get-clouses $tail))) )


(=(list-patterns $x) (  
    if (== $x ()) () (  
      let* ( 
            ($head (car-atom $x))
            ($tail (cdr-atom $x))
            ($tail_new (superpose(list-patterns $tail))))   
        (cons-atom $head $tail_new ) )))


(=(find_max $num_list $max) (
    if (== $num_list ()) $max (
        let* ((($head $tail)(decons-atom $num_list))
            ($dummy (find_max $tail (if (> $head $max) $head $max)))) 
            $dummy  )))

(=(max $list) (find_max $list (car-atom $list)))

(=(find_min $num_list $min) (
    if (== $num_list ()) $min (
        let* ((($head $tail)(decons-atom $num_list))
            ($dummy (find_min $tail (if (< $head $min) $head $min)))) 
            $dummy  )))


(=(min $list) (find_min $list (car-atom $list)))

(=(get-cnj-clouses $pattern) (
  let ($head $tail) (decons-atom $pattern)  (if (== $head ,) $tail ())
))


(=(min-max $list) ((min $list) (max $list)))