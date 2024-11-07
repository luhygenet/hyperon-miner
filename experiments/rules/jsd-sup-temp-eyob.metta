
! (register-module! ../../experiments)
! (import! &self  jsd-surpr)
! (import! &self experiments:utils:util-jsd)

(: map (-> (-> $t $t) Expression Expression))
(= (map $f $expr)
    (if (== $expr ()) ()
        (let* ( ($head (car-atom $expr))
                ($tail (cdr-atom $expr))
                ($head-new ($f $head))
                ($tail-new (map $f $tail))
            )
        (cons-atom $head-new $tail-new)
    )
)

)

(= (minsup-eval $f $ms)
    (Predicate minsup (List $f $ms))
)

(= (surp-eval $mode $f )
    (Predicate $mode (List $mode $f))
)

(= (jsd-eval $f) (
        Predicate jsd (List $f)
    ))

(= (cog-mean $patter)
    (let* ( ($tv (cog-tv $patter))
            ($type (car-atom $tv))
            ($mean_confidece (cdr-atom $tv))
            ($mean (car-atom $mean_confidece))

        )
    ($mean)
)
)
(= (gen-jsd-surprisingness-rule $nary,$f-vardecl)
    (
        if (> $nary 1)
        (let* (
                ($cnj-bodies (gen-variable $nary))
                ($f ($f-vardecl $cnj-bodies))
                ($jsd-e (jsd-eval $f))

                ($conclusion (surp-eval jsd-surp $f))
                ($surp (cog-mean $jsd-e))
            )
        (cog-set-tv! $conclusion (stv $surp 1))
    )
))
