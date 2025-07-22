!(register-module! ../../experiments)
; !(register-module!  ../../../../chaining)

!(import! &self experiments:miner:miner)
!(import! &self experiments:miner:miner-utils)
!(import! &self experiments:rules:conj-exp)
!(import! &self experiments:rules:freq-pat)
!(import! &self experiments:rules:use-python)
!(import! &self experiments:utils:variable-combinations)


;; import utils and rules files 
! (import! &self experiments:rules:isurp)
! (import! &self experiments:rules:isurp-old)
! (import! &self experiments:utils:common-utils)
! (import! &self experiments:utils:beta-dist)
! (import! &self experiments:utils:constants)
! (import! &self experiments:utils:TruthValue)
! (import! &self experiments:utils:surp-utils)
! (import! &self experiments:utils:miner-utils)
! (import! &self experiments:rules:build-specialization)
! (import! &self experiments:rules:conjunction-expansion)

! (import! &self experiments:utils:gen_partition)
! (import! &self experiments:rules:est-tv)
! (import! &self experiments:rules:emp-tv)
! (import! &self experiments:rules:emp-prob)
! (import! &self experiments:rules:jsd)
! (import! &self experiments:utils:emp-tv-bs)
! (import! &self experiments:utils:bs-utils)
! (import! &self experiments:utils:util-jsd)
; ! (import! &temp-dbspace experiments:data:ugly_man_sodaDrinker)
! (import! &dbspace experiments:data:small-ugly)



;; config kb : load the chainer , rules , system-proofs ....
 !(import! &self  chaining:dtl:backward:curried)
!(import! &temp   experiments:miner:miner-rules)
!(import! &self  experiments:miner:system-proofs)

;;create new space for kb
!(bind! &kb (new-space)) 
!(bind! &db (new-space)) 

!(let ($link $x $y) (get-atoms &dbspace) (add-atom &db ($link $x $y)))



;;copy atoms from temp space to kb to remove unnecessary atoms from the space
!(let $atoms  (get-atoms &temp) (add-reduct &kb $atoms) )


;; define parameters 
(=(min-sup) 6)
(=(surp-mode ) nisurp-old)
(=(db-ratio) 0.5)
; !(add-atom &kb (: msT (ms-threshold 2)))
; !(add-atom &kb (: SUP (supportOf $ptrn 5)))

; !(init-miner &db &kb (min-sup) (surp-mode) (db-ratio))

;; test the cog-miner
;; without sorting 
; ! (cog-mine &db &kb (min-sup) (surp-mode) (db-ratio) )
; ! (cog-mine &db &kb (min-sup) (surp-mode) (db-ratio) 1 2)
!(union-atom () (1 2 3 4 5 6 7 8 9 10))


; !(syn &kb (fromNumber 0) (: $prf (uniqueLink $pattern $cnt))) 
; !(syn &kb (fromNumber 0) (: $prf (valuation X (Inheritance $x $y) $val))) 
; !(syn &kb (fromNumber 0) (: $prf (valuation Y (Inheritance $x $y) $val))) 
; !(abstract (fromNumber 5) &kb)
; !(specialization (fromNumber 3) &kb)
; !(support (fromNumber 4) &kb)
; !(let $atom  (: candidate (-> (minsup $ptrn) (-> (replace_variables $ptrn) (candidatePattern $ptrn)))) (add-atom &kb $atom) )
; !(candidate (fromNumber 5) &kb)
; !(let $atom  (: candidate (-> (minsup $ptrn) (-> (replace_variables $ptrn) (candidatePattern $ptrn)))) (remove-atom &kb $atom) )
; !(conjunction (fromNumber 11) &kb 1 2)
; 

; !(match &kb $x $x)
;!(get-metatype (@doc random-int (@desc "Returns random int number from range defined by two numbers (first and second argument)")))

;;add the rb ref to the kb 
;;!(add-atom &kb (rb-ref &rb))



(: Grounded Type)
(: check Grounded)
(=(check $v) (> $v 3))

;!(chain (> 2 3) $v (not $v))
;! (not (== 2 3))
;!(filter-atom (1 2 2 4) $v (chain  (eval (check $v)) $x  (not $x))) will give (3 4)
;!(chain   $x  (not $x))

;!(filter-atom (1 2 3 4) $v (eval (> $v 3)))

;!(eval (not (eval (check 4))))

;!(get-type check)


; (=(min-sup) 2)
; (=(surp-mode) jsdsurp)
; (=(db-ratio) 0.5)

; ! (cog-mine &db &kb (min-sup) (surp-mode) (db-ratio) 1 2)

; !(syn &kb Z (: $prf (substitute_variables (link $nx $ny) ($valx $valy) ($subptrn $remaining))))

; !(init-miner &db &kb (min-sup) (surp-mode) (db-ratio))

; !(conjunction (fromNumber 13) &kb 1 2)



; (syn &kb Z (: $prf (clause_count $ptrn $cnt)))


; !(register-module! ../../experiments)
; ; !(register-module!  ../../../../chaining)

; ; !(import! &self experiments:miner:miner)
; !(import! &self experiments:miner:miner-utils)
; !(import! &self experiments:rules:conj-exp)
; !(import! &self experiments:rules:freq-pat)
; !(import! &self experiments:rules:use-python)
; !(import! &self experiments:utils:variable-combinations)



; ;; import utils and rules files 
; ! (import! &self experiments:rules:isurp)
; ! (import! &self experiments:rules:isurp-old)
; ! (import! &self experiments:utils:common-utils)
; ! (import! &self experiments:utils:beta-dist)
; ! (import! &self experiments:utils:constants)
; ! (import! &self experiments:utils:TruthValue)
; ! (import! &self experiments:utils:surp-utils)
; ! (import! &self experiments:utils:miner-utils)
; ! (import! &self experiments:rules:build-specialization)
; ! (import! &self experiments:rules:conjunction-expansion)

; ! (import! &self experiments:utils:gen_partition)
; ! (import! &self experiments:rules:est-tv)
; ! (import! &self experiments:rules:emp-tv)
; ! (import! &self experiments:rules:emp-prob)
; ! (import! &self experiments:rules:jsd)
; ! (import! &self experiments:utils:emp-tv-bs)
; ! (import! &self experiments:utils:bs-utils)
; ! (import! &self experiments:utils:util-jsd)
; ; ! (import! &dbspace experiments:data:ugly_man_sodaDrinker)
; ! (import! &dbspace experiments:data:small-ugly)