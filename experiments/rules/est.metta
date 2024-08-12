
(: LambdaLink Type)
(: ConceptNode Type)
(: NumberNode Type)

(: LambdaT LambdaLink)
(: ConceptT ConceptNode)
(: NumberT NumberNode)

(: gen-est-rule (-> LambdaT ConceptT NumberT  Atom))

(= (gen-est-rule $pattern $db $ms)
    (
        let $minsup_pattern (minsup_eval $pattern $db $ms) ()
    ))