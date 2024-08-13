! (register-module! ../../experiments)
! (import! &self experiments:utils:common-utils)
! (import! &self data:u:common-utils)
! (import! &db )

(: LambdaLink Type)
(: ConceptNode Type)
(: NumberNode Type)

(: LambdaT LambdaLink)
(: ConceptT ConceptNode)
(: NumberT NumberNode)

(: gen-est-rule (-> LambdaT ConceptT NumberT  Atom))

(= (gen-est-rule $pattern $db $ms)
    (
        let $minsup_pattern (sup-eval $pattern $db $ms) ( if ($minsup_pattern) ($minsup_pattern) () )
    ))
