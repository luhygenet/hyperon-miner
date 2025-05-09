
! (register-module! ../../experiments)
! (import! &self  jsd-surpr)
! (import! &self experiments:utils:util-jsd)

(: gt_zero_confidence_eval (-> Atom Bool))
(= (gt_zero_confidence_eval $x)
    (> (confidence $x) 0)
)

(= (minsup-eval $f $ms)
    ((Predicate minsup) (cons-atom $f $ms))
)

(= (surp-eval $mode $f )
    ((Predicate $mode) $f)
)

(= (jsd-eval $f) (
        (Predicate jsd) $f
    ))

(= (emp-eval $pattern) ( (Predicate emp) $pattern))
(= (est-eval $pattern) ( (Predicate est) $pattern))

(= (cog-mean $patter)
    (let* ( ($tv (cog-tv $patter))
            ($type (car-atom $tv))
            ($mean_confidece (cdr-atom $tv))

        )
    $mean_confidece
)
)


(= (gen-jsd-surprisingness-rule $nary)
    (
        if (> $nary 1)
        (let* (
                ($cnj-bodies (gen-variables "$gen-body" $nary))
                ($f ($cnj-bodies))
                ($jsd-e (jsd-eval $f))
                ($conclusion (surp-eval jsd-surp $f))

                ($mean_confidece (cog-mean $jsd-e))

                ($surp (car-atom $mean_confidece) )

                ($mean_confidece1 (cdr-atom $mean_confidece))

                ($confidence (car-atom $mean_confidece1))

            )
        (if (< 0 $confidence)
            (cog-set-tv! $conclusion (stv $surp 1))
            (confidence is zero)

        )
)

(Pattern is not conjuncts)

))

;  !  (gen-variables "$cnj-bodies" 2)
! (gen-jsd-surprisingness-rule  2 )
