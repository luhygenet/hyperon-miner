; calculates square root of a number
! (bind! sqrt (
    py-atom math.sqrt (
        -> Number Number
    )
))


; calculates average of two numbers
(= (average () ()) ())
(= (average (:: $emp-tvs $emp-tvsN) (:: $est-tvs $est-tvsN))(
    ::(/ (+ $emp-tvs $est-tvs) 2) (average $emp-tvsN $est-tvsN)
))


; calculates natural logarithm of a number
! (bind! logarithm (
    py-atom math.log (
        -> Number Number
    )
))

; calculates Kullback–Leibler divergence
(= (kld () ()) 0)
(= (kld (:: $P $Pn) (:: $Q $Qn)) 
    (+ 
    (* $P (logarithm (/ $P $Q)))
    (kld $Pn $Qn)
    )
)

; calculates the Jensen-Shannon(JS) Divergence
(= (jsd () ()) 0)
(= (jsd $emp-tvs $est-tvs)(
    sqrt (
        / (
            + (
                kld $emp-tvs (average $emp-tvs $est-tvs)
            )
            (
                kld $est-tvs (average $emp-tvs $est-tvs)
            )
        )
        2
    )
))



; example usages
!(jsd (:: 0.5 (:: 0.9 (:: 0.4 ()))) (:: 0.5 (:: 3 (:: 1 ()))))
!(jsd (:: 10 (:: 9 (:: 14 ()))) (:: 25 (:: 13 (:: 12 ()))))
!(jsd (:: 10 (:: 15 (:: 20 ()))) (:: 10 (:: 15 (:: 20 ()))))