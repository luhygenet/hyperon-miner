! (register-module! ../../../hyperon-miner)
; ! (import! &dbspace hyperon-miner:experiments:data:sample-data)
! (import! &db hyperon-miner:experiments:data:ugly_man_sodaDrinker)
! (import! &self hyperon-miner:experiments:rules:build-specialization)
! (import! &self hyperon-miner:experiments:rules:candidate-patterns)
! (import! &self hyperon-miner:experiments:rules:conjunction-expansion)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (bind! &kb (new-space))
! (bind! &dbspace (new-space))
! (bind! &specspace (new-space))
! (bind! &cndpspace (new-space))
! (bind! &aptrnspace (new-space))
! (bind! &conjspace (new-space))
! (import! &self freq-pat)
! (import! &self conj-exp)

!(let ($link $x $y) (get-atoms &db) (add-atom &dbspace ($link $x $y)))
;steps 
; 1. get abstract patterns that have minimum support
; 2. specializa abstract patterns
; 3. get candidate patterns
; 4. store candidate patterns
(= (apriori $dbspace $minsup $aptrnspace)
            (let* (
                    ($linkunique (unique (match $dbspace ($link $x $y) $link)))
                    ($result (sup-eval $dbspace ($linkunique $z $t) $minsup))
                )
            (if (== $result True)
                (superpose (
                        (remove-atom $aptrnspace (AbstractPattern ($linkunique Z (S Z))))
                        (add-atom $aptrnspace (AbstractPattern ($linkunique Z (S Z))))
                    ))
            empty
        )
)

)



(= (do-conjunct $db $cndb $conjunct $ms Z)
    (let* (
        ($matches (match $cndb (CandidatePattern $pattern) (replacev $pattern)))
        ($listconj (expand_conjunction $conjunct $matches $db $ms 2 False))
        ($debconj (replace $listconj))
        ($fitlered (remove_conjuncts_with_redundant_clauses $debconj))
    )
    $fitlered
    )
)


(= (do-conjunct $db $cndb $conjunct $ms (S $K))
    (let* (
        ($matches (match $cndb (CandidatePattern $pattern) (replacev $pattern)))
        ($listconj (expand_conjunction $conjunct $matches $db $ms 2 False))
        ($debconj (replace $listconj))
        ($fitlered (remove_conjuncts_with_redundant_clauses $debconj))
        ($varconj (replacev $fitlered))
        ($conj (do-conjunct $db $cndb $varconj $ms $K))
    )
    $conj
    )
)

(= (formatter $kb $conjspace $dbspace) 
    (let* (
        ($sorted (unique (match $conjspace $pattern (sort_conj $pattern))))
        ($res (cons-atom , $sorted))
        
    )
    (add-atom $kb (supportOf $res (sup-num $dbspace (replacev $res))))
)
)
; miner
(= (frequency-pattern-miner $kb $dbspace $specspace $cndpspace $aptrnspace $conjspace $minsup $depth)
    (superpose (
            (apriori $dbspace $minsup $aptrnspace) ; prevent patterns that dont have a support from being speciallized
            (match $aptrnspace (AbstractPattern $pattern) (build-specialization $pattern $dbspace $specspace)) ; specializa abstract patterns
            (candidatePattern $dbspace $specspace $minsup $cndpspace); get candidate patterns
            (match $cndpspace (CandidatePattern $pattern) (let $conj (do-conjunct $dbspace $cndpspace (replacev $pattern) $minsup (fromNumber $depth)) (if (== $conj ()) () (add-atom $conjspace $conj)))) ; store candidate patterns
            ; (match &conjspace $pattern (superpose ((add-atom &conjspace (supportOf $pattern (sup-num $dbspace (replacev $pattern)))) (remove-atom &conjspace $pattern))))
            (formatter $kb $conjspace $dbspace)
        ))
)



;  ! (apriori &dbspace 2 &aptrnspace)
;  ! (match &aptrnspace (AbstractPattern $pattern) $pattern)


! (frequency-pattern-miner &kb &dbspace &specspace &cndpspace &aptrnspace &conjspace 5 0)
! (match &kb $pattern $pattern)
