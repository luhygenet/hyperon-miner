; Import necessary modules and utilities
! (register-module! ../../experiments)
! (import! &self experiments:utils:util-jsd)

; Bind mathematical functions to Python functions
! (bind! sqrt (
    py-atom math.sqrt (
        -> Number Number
    )
))

! (bind! logarithm (
    py-atom math.log (
        -> Number Number
    )
))

; Calculates average of two numbers
(= (average () ()) ())
(= (average (:: $emp-tvs $emp-tvsN) (:: $est-tvs $est-tvsN))(
    ::(/ (+ $emp-tvs $est-tvs) 2) (average $emp-tvsN $est-tvsN)
))

; Calculates Kullback–Leibler divergence
(= (kld () ()) 0)
(= (kld (:: $P $Pn) (:: $Q $Qn)) 
    (+ 
    (* $P (logarithm (/ $P $Q)))
    (kld $Pn $Qn)
    )
)

; Counts the number items in a list
(= (length ()) 0)
(= (length (:: $list $listN))
   (+ 1 (length $listN)))

; Sum of a list
(= (sum ()) 0)
(=(sum (:: $list $listN))
   (+ $list (sum $listN)))

; Calculates the confidence level of a list
(= (get-confidence-level $tvs)
   (if (> (/ (sum $tvs) (length $tvs)) 0)
       True
       False)
)

; Calculates the Jensen-Shannon(JS) Divergence
(= (jsd () ()) 0)
(= (jsd $emp-tvs $est-tvs)
   (if (get-confidence-level $emp-tvs)
       (sqrt (
           / (
               + (
                   kld $emp-tvs (average $emp-tvs $est-tvs)
               )
               (
                   kld $est-tvs (average $emp-tvs $est-tvs)
               )
           )
           2
       ))  
       "one of the truth values below confidence level")
)

; Example usages
!(jsd (:: 0 (:: 0 (:: 0 ()))) (:: 0.5 (:: 3 (:: 1 ()))))
!(jsd (:: 10 (:: 9 (:: 14 ()))) (:: 25 (:: 13 (:: 12 ()))))
!(jsd (:: 10 (:: 15 (:: 20 ()))) (:: 10 (:: 15 (:: 20 ()))))
