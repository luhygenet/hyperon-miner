! (register-module! ../../experiments)
! (import! &self experiments:utils:util-jsd)

! (bind! logarithm (py-atom numpy.log10 (-> Number Number)))
! (bind! squareroot (py-atom numpy.sqrt (-> Number Number)))

(: LambdaT LambdaLink)
(: ConceptT ConceptNode)

(: jsd-rule (-> LambdaT ConceptT Atom))
(= (jsd-rule $pattern $db)
    (let* (
            ($emp (emp-eval $pattern $db))
            ($est (est-eval $pattern $db))
        )
    (if (and (and (exist $emp) (exist $est))
            (and
                (gt-zero-confidence-eval (let* ( ($list (cdr-atom $emp)) ($conf (car-atom $list))) $conf))
                (gt-zero-confidence-eval (let* ( ($list (cdr-atom $est)) ($conf (car-atom $list))) $conf))))
        (jsd-eval $pattern $db $emp $est)
        (superpose ())
    ))
)

(= (jsd-eval $pattern $db $emp $est)
    (let* (
            ($emp_extracted (car-atom $emp))
            ($est_extracted (car-atom $est))
            ($m (/ (+ $emp_extracted $est_extracted) 2))
        )
    (cog-set-tv $pattern (cog-new-stv (sqrt (+ (/ (* $emp_extracted (log (/ $emp_extracted $m))) 2)
                    (/ (* $est_extracted (log (/ $est_extracted $m))) 2))) 1.0))
)
)

(= (log $a)
    (logarithm $a)
)
(= (sqrt $a)
    (squareroot $a)
)

 ;  ;;Test
! (jsd-rule (Parent abel henok) db1)
