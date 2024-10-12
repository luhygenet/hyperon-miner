 ;  ;; Calculate the surprisingness of a pattern as the Jensen-Shannon
 ;  ;; Distance between its empirical truth value and its truth value
 ;  ;; estimate, based a reasoning (typically excluding the emp rule).

 ;;;;;;;;;;
 ;; Imports ;;
 ;;;;;;;;;;

! (register-module! ../../experiments)
! (import! &self  jsd-surpr)
! (import! &self experiments:utils:util-jsd)

 ;;;;;;;;;;
 ;; Type ;;
 ;;;;;;;;;;

(: TruthValue Type)

 ;;;;;;;;;;;;;;;;;;
 ;; Constructors ;;
 ;;;;;;;;;;;;;;;;;;

 ;; Boolean TV constructor
 ;; TODO: alternatively we could have (: ⊤ TruthValue) and (: ⊥ TruthValue)
(: Bl (-> Bool TruthValue))

 ;; First order probability TV constructor, i.e. mere probability.
(: Pr (-> Number TruthValue))

 ;; Simple Truth Value.  A Second order probability TV constructor,
 ;; i.e. probability and confidence.  The probability is in fact the
 ;; mode of the corresponding beta distribution.
(: STV (-> Number Number TruthValue))

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ; We can use Nodes and Links in the OpenCog Classic style,
 ; because these are also symbolic expressions,
 ; although Concept and List will not be turned into types
 ; and will remain just symbols in expressions
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ; (EvaluationLink
 ;     (PredicateNode "eats")
 ;     (ListLink
 ;         (ConceptNode "Sam")
 ;         (ConceptNode "flies")))

 ;; Boolean TV constructor
(: Bl (-> Bool TruthValue))

 ;; First order probability TV constructor, i.e. mere probability.
(: Pr (-> Number TruthValue))

 ;;checks if an atom A is TruethValue and returns True if it is.
(= (absolutely_true_eval $x)
    (if (== (get-type (STV 1 1)) (get-type $x) )
        True
        False

    )
)

 ;; check if confidence is greater than zero
(: gt_zero_confidence_eval (-> Atom Bool))
(= (gt_zero_confidence_eval $x)
    (> (confidence $x) 0)
)

(: confidence (-> TruthValue Number))
(= (confidence (Bl $_)) 1.0)
(= (confidence (Pr $_)) 1.0)
(= (confidence (STV $_ $conf)) $conf)

(: cog-mean (-> TruthValue Number))
(= (cog-mean (Bl True)) 1.0)
(= (cog-mean (Bl False)) 0.0)
(= (cog-mean (Pr $pr)) $pr)
(= (cog-mean (STV $pr $conf)) $pr)

(: mapper (-> (-> $t $t) Expression Expression))
(= (mapper $f $expr)
    (if (== $expr ()) ()
        (let* ( ($head (car-atom $expr))
                ($tail (cdr-atom $expr))
                ($head-new ($f $head))
                ($tail-new (mapper $f $tail))
            )
        (cons-atom $head-new $tail-new)
    )
)
)

 ;; make-pattern a helper function to create a pattern from a variable declaration and a list of bodies
(: make-pattern (-> Atom Atom))
(= (make-pattern $f_vardecl)
    (quote
        (Lambda
            ($f_vardecl)
            (mapper Present ($cnj_bodies))))
)

 ;;TODO:implement minsup-eval
(= (minsup-eval $f $db $ms)
    (True)
)

 ;;TODO:implement surp-eval
(= (surp-eval  $f $db)
    (Inheritance $x $y)
)

 ;;TODO: implement Present
 ;;Present accepts an atom and checks if it is present in the db
(: Present (-> Atom Bool))
(= (Present $x)
    (let $matchOutcome ( (match &self $x True ))
        (if (or (== $matchOutcome ()) (== $matchOutcome empty) ) (False) (True))
    )

)

 ; (: Absent (-> Atom Bool))
 ; (= (Absent $x) not (Present $x))

 ;;The Absent function checks if a given atom exists in the database.
 ;; If the atom exists, the function returns False; otherwise, it returns True.
(: Absent (-> Atom Bool))
(= (Absent $x)
    (let $matchOutcome ( (match &self $x True ))
        (if (or (== $matchOutcome ()) (== $matchOutcome []) ) (True) (False))
    )

)

 ;; evaluateJsdSurpCriteria checks if the JSD-Surprisingness criteria is met
(: evaluateJsdSurpCriteria (-> Atom Atom Atom Bool))
(= (evaluateJsdSurpCriteria $minsup_e $jsd_e $surp_e)
    (and ( and (not (absolutely_true_eval $minsup_e)) (gt_zero_confidence_eval $jsd_e)) (and (and (Present $minsup_e)  (Present $jsd_e)) (Absent $surp_e))

    ))

(= (_gen-variables $a $nary)
    ($cnj-bodies-0 $cnj-bodies-1))
 ;; Generate a rule to calculate the JSD-Surprisingness of a pattern
 ;; that is the conjunction of nary components.
(= (gen-jsd-surprisingness-rule $nary $ms $f_vardecl $db)

    (if (> 1 $nary) ()
        (let* ( ($cnj_bodies (_gen-variables "$cnj-bodies" $nary))
                ($f (gen-jsd-pattern $f_vardecl $cnj_bodies))
                ($minsup_e (minsup-eval $f $db $ms))
                ($jsd_e (jsd-eval $f $db))
                ($surp_e (surp-eval 'jsdsurp $f $db))
            )
         ;;check jsd-surprisingness-criteria
        (jsd-surprisingness-formula $surp_e $minsup_e $jsd_e )

    )
))

(= (jsd-surprisingness-formula $surp_e $minsup_e $jsd_e  )

    (let* ( ($jsdsurp-e $surp_e)
            ($surp ($cog-mean $jsd_e))
            ($tv  (cog-set-tv $jsdsurp-e (stv $surp 1)))

        )
    (cog-tv $jsdsurp-e)
)
)

 ;;Test
(Person A)
! (assertEqual
    (gt_zero_confidence_eval (STV 0.5 0.1) )
    True)

! (assertEqual
    (cog-mean (STV 1 2))
    1)

! (gen-variables "$cnj-bodies" 4)

!  (mapper PresentLink ($cnj-bodies-0 $cnj-bodies-1))
!  (mapper PresentLink ($cnj-bodies-0 $cnj-bodies-1))

! (gt_zero_confidence_eval (STV 0.5 0.1) )
! (absolutely_true_eval  (STV 1 2))
! (absolutely_true_eval  (STV 1 2))
! (Present (Person A))
! (Absent (Person A))

! (gen-jsd-surprisingness-rule 1 2 (Person A) (Inheritance A B))
! (gen-jsd-surprisingness-rule 1 2 (Person A) (new-space))
