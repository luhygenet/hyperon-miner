!(register-module! ../../experiments)
!(register-module!  ../../../chaining)

!(import! &self experiments:miner:miner)
!(import! &self experiments:miner:miner-utils)


;; import utils and rules files 
! (import! &self experiments:rules:isurp)
! (import! &self experiments:rules:isurp-old)
! (import! &self experiments:utils:common-utils)
! (import! &self experiments:utils:beta-dist)
! (import! &self experiments:utils:constants)
! (import! &self experiments:utils:TruthValue)
! (import! &self experiments:utils:surp-utils)
! (import! &self experiments:utils:miner-utils)
! (import! &self experiments:utils:gen_partition)
! (import! &self experiments:rules:est-tv)
! (import! &self experiments:rules:emp-tv)
! (import! &self experiments:rules:emp-prob)
! (import! &self experiments:rules:jsd)
! (import! &self experiments:utils:emp-tv-bs)
! (import! &self experiments:utils:bs-utils)
! (import! &self experiments:utils:util-jsd)
! (import! &db experiments:data:ugly_man_sodaDrinker)


;; config kb : load the chainer , rules , system-proofs ....
!(import! &self  chaining:dtl:backward:curried)
!(import! &temp   experiments:miner:miner-rules)
!(import! &self  experiments:miner:system-proofs)

;;create new space for kb
!(bind! &kb (new-space))

;;copy atoms from temp space to kb to remove unnecessary atoms from the space
!(let $atoms  (get-atoms &temp) (add-atom &kb $atoms) )
;!(chain (get-atoms &temp) $atoms (add-atom &kb $atoms))

;; define parameters 
(=(min-sup) 6)
(=(surp-mode ) isurp-old)
(=(db-ratio) 0.5)


;; test the cog-miner
;; without sorting 
! (cog-mine &db &kb (min-sup) (surp-mode) (db-ratio))

;; with sorting 
;! (let $res (collapse (cog-mine &db &kb (min-sup) (surp-mode) (db-ratio))) (surp-sorting $res))




