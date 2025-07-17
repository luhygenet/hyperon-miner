; (= (add-formatted-to-space $kb  $dbspace $atom  ) (
;    let $var  (cons-atom , $atom) (add-reduct $kb (supportOf  $var (sup-num $dbspace (replacev $var))))
; ))

; (= (formatter $kb $conjspace $dbspace) 
;     (let  $sorted  (unique-atom (collapse (match $conjspace $pattern $sorted)))  $sorted
                              
; )
; )



(= (formatter $kb $conjspace $dbspace) 
    (let* (
        (() (println! (inforamter)))
        (() (println! (match $conjspace $pattern (sort_conj $pattern))))
        ($sorted (unique (match $conjspace $pattern (sort_conj $pattern))))
        ($res (cons-atom , $sorted)) 
        ($dummy (collapse (add-atom $kb (supportOf $res (sup-num $dbspace (replacev $res)))))) 
    )()
    
)
)