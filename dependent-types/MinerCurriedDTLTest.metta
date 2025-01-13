; !(register-module! ../../hyperon-miner)
; !(import! &self hyperon-miner:utils:MinerUtils)
; !(import! &self hyperon-miner:utils:DeBruijnIndex)
; !(import! &self hyperon-miner:dependent-types:chainer)

;; sample data
!(bind! &db (new-space))

(: Linktype Type)
(: interacts_with (-> $a $b Linktype))
!(add-atom &db (interacts_with (gene TP53) (gene MDM2)))
!(add-atom &db (interacts_with (gene BRCA1) (gene BRCA2)))
!(add-atom &db (interacts_with (gene TP53) (gene BRCA1)))
!(add-atom &db (interacts_with (gene TP53) (gene MDM2)))
!(add-atom &db (interacts_with (gene CDK2) (gene CYCLIN_E)))
!(add-atom &db (interacts_with (gene CDK2) (gene CYCLIN_A)))
!(add-atom &db (interacts_with (gene EGFR) (gene GRB2)))
!(add-atom &db (interacts_with (gene EGFR) (gene ERBB2)))
!(add-atom &db (interacts_with (gene TP53) (gene MDM2)))
!(add-atom &db (interacts_with (gene BRCA1) (gene RAD51)))
!(add-atom &db (interacts_with (gene BRCA2) (gene RAD51)))
!(add-atom &db (interacts_with (gene TP53) (gene BRCA2)))
!(add-atom &db (interacts_with (gene MDM2) (gene MDM4)))
!(add-atom &db (interacts_with (gene TP53) (gene EGFR)))
!(add-atom &db (interacts_with (gene BRCA1) (gene MDM2)))
!(add-atom &db (interacts_with (gene BRCA1) (gene EGFR)))
!(add-atom &db (interacts_with (gene CDK2) (gene CYCLIN_E)))
!(add-atom &db (interacts_with (gene CDK2) (gene CYCLIN_A)))
!(add-atom &db (interacts_with (gene MDM2) (gene TP53)))

;; Parameters
(= (highsurp) 0.8)
(= (ms) 2)

;; Type definition for -> to prevent early reduction
;; of the conclusions before matching the correct premises.
(: -> (-> Atom Atom Type))

;;;;;;;;;;;;;;;;;;;;;;
;; KB and rule base ;;
;;;;;;;;;;;;;;;;;;;;;;

!(import! &kb MinerCurriedDTL)

;; Initialize miner with the given db, kb and parameters
!(init-miner &db &kb (ms) (highsurp))

;;;;;;;;;;
;; Test ;;
;;;;;;;;;;

;; Test 1: Use the forward chainer
;; Start from the most abstract pattern, and collect patterns with minimum support iteratively
; a,
; !(let* (($aptrn (abstract-patterns))
;         ($cnt (count $aptrn))
;         ($fact (: (supportwitness $aptrn) (supportOf $aptrn $cnt)))
;         ($depth (fromNumber 8)))
;     (ifc $fact $depth (S Z) &kb))

;; or b,
; !(ifc (: ST (supportOf (Inheritance (VarIdx Z) (VarIdx (S Z))) 4)) (fromNumber 5) (fromNumber 2) &kb)

;; Find Conjunctions of patterns, with minimum support
; !(ibc (: $prf (supportOf (, $ptrn1 $ptrn2) $cnt)) (fromNumber 4) (S Z) &kb)
; !(bc (: $prf (minsup $ptrn)) (fromNumber 4) &kb)

;; Test 2: Use the backward chainer
;; Given the support for the most abstract pattern,
;; find patterns with minimum support.
;; (Recursive backward chaining)
; !(let* (($aptrn (abstract-patterns))
;         ($cnt (count $aptrn)))
;     (add-atom &kb (: (supportwitness $aptrn) (supportOf $aptrn $cnt))))

; !(ibc (: $prf (minsup $ptrn)) (fromNumber 5) (S (S Z)) &kb)

; !(let (: $type (minsup $pattern)) (get-atoms &kb) (minsup $pattern))