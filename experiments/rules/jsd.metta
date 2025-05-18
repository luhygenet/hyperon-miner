;! (register-module! ../../experiments)
;! (import! &self experiments:utils:util-jsd)




(= (do-jsd $emp $est)
    (let* (
            ($emp_extracted (strength $emp))
            ($est_extracted (strength $est))
            ($m (// (+ $emp_extracted $est_extracted) 2))
        )
    (sqrt-math (+ (// (* $emp_extracted (log-math 10 (// $emp_extracted $m))) 2)

             (// (* $est_extracted (log-math 10 (// $est_extracted $m))) 2)))
)
)













