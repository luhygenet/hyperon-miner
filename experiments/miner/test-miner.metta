!(register-module! ../../experiments)
!(register-module! ../../../chaining)

!(import! &self experiments:miner:miner)
!(import! &self experiments:miner:miner-utils)
! (import! &self experiments:rules:conj-exp)



;; import utils and rules files 
; ! (import! &self experiments:rules:isurp)
; ! (import! &self experiments:rules:isurp-old)
! (import! &self experiments:utils:common-utils)
; ! (import! &self experiments:utils:beta-dist)
; ! (import! &self experiments:utils:constants)
; ! (import! &self experiments:utils:TruthValue)
; ! (import! &self experiments:utils:surp-utils)
! (import! &self experiments:utils:miner-utils)
! (import! &self experiments:rules:build-specialization)
! (import! &self experiments:rules:conjunction-expansion)

; ! (import! &self experiments:utils:gen_partition)
; ! (import! &self experiments:rules:est-tv)
; ! (import! &self experiments:rules:emp-tv)
; ! (import! &self experiments:rules:emp-prob)
; ! (import! &self experiments:rules:jsd)
; ! (import! &self experiments:utils:emp-tv-bs)
; ! (import! &self experiments:utils:bs-utils)
; ! (import! &self experiments:utils:util-jsd)
;! (import! &dbspace experiments:data:ugly_man_sodaDrinker)
! (import! &dbspace experiments:data:small-ugly)



;; config kb : load the chainer , rules , system-proofs ....
!(import! &self  chaining:dtl:backward:curried)
!(import! &self  chaining:dtl:forward:curried)
!(import! &temp   experiments:miner:miner-rules)
!(import! &self  experiments:miner:system-proofs)

;;create new space for kb
!(bind! &kb (new-space)) 
!(bind! &db (new-space)) 

!(let ($link $x $y) (get-atoms &dbspace) (add-atom &db ($link $x $y)))

(= (abstract $dbspace $minsup $kb)
            (let* (
                    ($linkunique (unique (match $dbspace ($link $x $y) $link)))
                    ($result (sup-eval $dbspace ($linkunique $z $t) $minsup))
                )
            (if (== $result True)
                (superpose (
                        (remove-atom $kb ((: AbstractPattern (AbstractPattern ($linkunique Z (S Z))))))
                        (add-atom $kb ((: AbstractPattern (AbstractPattern ($linkunique Z (S Z))))))
                    ))
            empty
        )
)

)


;;copy atoms from temp space to kb to remove unnecessary atoms from the space
!(let $atoms  (get-atoms &temp) (add-atom &kb $atoms) )
;!(chain (get-atoms &temp) $atoms (add-atom &kb $atoms))

(= (candidate $kb) ( 
     let*  ( 
        (() (add-atom $kb (: candidateP  (candidatePattern (Inheritance $x human) ))))
        (() (add-atom $kb (: candidateP  (candidatePattern (Inheritance $y sodaDrinker) ))))
        ) ()
))


;; define parameters 
(=(min-sup) 2)
(=(surp-mode ) isurp-old) 
(=(db-ratio) 0.5)
!(add-atom &kb (: msT (ms-threshold 2)))
!(add-atom &kb (: SUP (supportOf $ptrn 5)))

!(init-miner &db &kb (min-sup))
!(candidate &kb)


!(abstract &db (min-sup) &kb)

;; test the cog-miner
;; without sorting 
! (cog-mine &db &kb (min-sup) (surp-mode) (db-ratio))

;; with sorting 
;! (let $res (collapse (cog-mine &db &kb (min-sup) (surp-mode) (db-ratio))) (surp-sorting $res))




