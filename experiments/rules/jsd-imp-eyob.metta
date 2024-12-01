! (register-module! ../../experiments)
! (import! &self experiments:utils:util-jsd)

! (bind! logarithm (py-atom numpy.log10 (-> Number Number)))
! (bind! squareroot (py-atom numpy.sqrt (-> Number Number)))



(= (jsd-rule $pattern $db)
    (let* (
            ($emp (emp-eval $pattern))
            ($_  (println! $emp))
            ($est (est-eval $pattern))
            ($emp_tv (cog-tv $emp))
            ($_  (println! $emp_tv))

            ($est_tv (cog-tv $est))
            ($conclusion (jsd-eval $pattern))

        )
    (if (and (and (exist $emp) (exist $est))
            (and
                (gt_zero_confidence_eval $emp_tv)
                (gt_zero_confidence_eval $est_tv)))
        (let* (
            ($jsd (do-jsd $emp-tv $est-tv))
            ($jsd-tv (cog-new-stv $jsd 1))
        )
        (cog-set-tv $conclusion $jsd-tv)
        )
        (superpose ())
    ))
)

(= (do-jsd $emp $est)
    (let* (
            ($emp_extracted (strength $emp))
            ($est_extracted (strength $est))
            ($m (/ (+ $emp_extracted $est_extracted) 2))
        )
    (sqrt (+ (/ (* $emp_extracted (log (/ $emp_extracted $m))) 2)
                    (/ (* $est_extracted (log (/ $est_extracted $m))) 2)))
)
)

(= (log $a)
    (logarithm $a)
)
(= (sqrt $a)
    (squareroot $a)
)

 ;  ;; Test 

; !(do-jsd (STV 0.5 1) (STV 0.65 1))
!(cog-set-tv (emp-eval (Parent abel henok)) (STV 15 10))
!(cog-set-tv (est-eval (Parent abel henok)) (STV 25 12))

! (jsd-rule (Parent abel henok) db1)
!(cog-tv (jsd-eval (Parent abel henok)))


