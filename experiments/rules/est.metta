! (register-module! ../../experiments)
! (import! &self experiments:utils:common-utils)
! (import! &db  experiments:data:sample-data)

(: LambdaLink Type)
(: ConceptNode Type)
(: NumberNode Type)

(: LambdaT LambdaLink)
(: ConceptT hyperon::space::DynSpace)
(: NumberT Number)

(: gen-est-rule (-> hyperon::space::DynSpace  LambdaT  Number  Atom))

(: check (-> ConceptT LambdaT Atom))
(= (gen-est-rule $db $pattern $ms)
    (let $minsup_pattern (sup-eval $db $pattern $ms) ( if $minsup_pattern $minsup_pattern () )))

! (gen-est-rule &db (abebe) 2)
 ;! (get-metatype &db)

(= (check $db $pattern)
    (match $db $pattern $pattern)
)
 ; (check &db (abebe))
 ;! (match &db (abebe) yes)