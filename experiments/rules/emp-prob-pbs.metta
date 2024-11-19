

(= (subsmp-size $pattern $db-size $support-estimate)
    (let* ( ($nc (n-conjuncts $pattern))
            ($min-subsize 10)
            ($alpha (/ $support-estimate (pow-py $db-size $nc)))
            ($res (pow-py (/ $db-size (* 10 $alpha)) (/ 1 $nc))))
        (max $res (min $min-subsize $db-size))
    )
)



(= (emp-prob-pbs $pattern $db $db-ratio)
    (if (> 1 (n-conjuncts $pattern))
        (let ($emin $emax) (ji-prob-est-interval $pattern $db $db-ratio)

            (emp-prob-pbs $pattern $db $emax $db-ratio)
        )
    (emp-prob $pattern $db)
)
)



(= (emp-prob-pbs $pattern $db $prob-estimate $db-ratio)
    (let* ( ($support-estimate (prob_to_support $pattern $db $prob-estimate))
            ($db-size (* (db-size $db) $db-ratio)))
        (if (< $db-size $support-estimate)
            (let* ( ($subsize (subsmp-size $pattern $db-size $support-estimate))
                    ($n-resample 10)
                    ($emp-prob (emp_prob_bs $pattern $db $n-resample $subsize)))

                (if (== $emp-prob 0)
                    (handle-zero-probability)
                )
            $emp-prob
        )
    (emp-prob $pattern $db)
)
)
)