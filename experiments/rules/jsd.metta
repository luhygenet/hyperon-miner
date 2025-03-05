! (register-module! ../../experiments)
! (import! &self experiments:utils:util-jsd)


(= (do-jsd $emp $est)
    (let* (
            ($emp_extracted (strength $emp))
            ($est_extracted (strength $est))
            ($m (/ (+ $emp_extracted $est_extracted) 2))
        )
    (sqrt-math (+ (/ (* $emp_extracted (log-math 10 (/ $emp_extracted $m))) 2)

             (/ (* $est_extracted (log-math 10 (/ $est_extracted $m))) 2)))
)
)

(= (jsd-rule $pattern $db)
    (let* (
            ($emp (emp-eval $pattern))
            ($est (est-eval $pattern))
            ($emp-tv (cog-tv $emp))
            ($est-tv (cog-tv $est))
            ($conclusion (jsd-eval $pattern))

        )
    (if (and (and (exist $emp) (exist $est))
            (and
                (gt_zero_confidence_eval $emp-tv)
                (gt_zero_confidence_eval $est-tv)))
        (let* (
            ($jsd (do-jsd $emp-tv $est-tv))
            ($jsd-tv (cog-new-stv $jsd 1))
        )
        (cog-set-tv $conclusion $jsd-tv)
        )
        (superpose ())
    ))
)






 ;  ;; Test 
!(do-jsd (STV 0.5 1) (STV 0.65 1))
; !(cog-set-tv (emp-eval (Parent abel henok)) (STV 15 10))
; !(cog-set-tv (est-eval (Parent abel henok)) (STV 25 12))

; ! (jsd-rule (Parent abel henok) db1)
; !(cog-tv (jsd-eval (Parent abel henok)))


