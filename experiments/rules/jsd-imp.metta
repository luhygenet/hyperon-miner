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
                (gt-zero-confidence-eval $emp)
                (gt-zero-confidence-eval $est)))
        (jsd-eval $pattern $db $emp $est)
        (superpose ())
    ))
)

(= (jsd-eval $pattern $db $emp $est)
    (let* (
            ($m (/ (+ $emp $est) 2))
        )
    (cog-set-tv $pattern (cog-new-stv (sqrt (+ (/ (* $emp (log (/ $emp $m))) 2)
                    (/ (* $est (log (/ $est $m))) 2))) 1.0))
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
