
;steps 
; 1. get abstract patterns that have minimum support
; 2. specializa abstract patterns
; 3. get candidate patterns
; 4. store candidate patterns
(= (apriori $dbspace $minsup $aptrnspace)
            (let* (
                    (() (println! (here)))
                    ($linkunique (unique (match $dbspace ($link $x $y) $link)))
                    ($result (sup-eval $dbspace ($linkunique $z $t) $minsup))
                    (() (println! (result $result)))
                )
            (if $result 
                (let* (
                        (() (remove-atom $aptrnspace (AbstractPattern ($linkunique Z (S Z)))))
                        (() (add-atom $aptrnspace (AbstractPattern ($linkunique Z (S Z)))))
                    ) ())
            (empty)
        )
)

)




(= (do-conjunct $db $cndb $conjunct $ms Z)
    (let* (
        ($matches (match $cndb (CandidatePattern $pattern)  $pattern))
        ($listconj (expand_conjunction $conjunct $matches $db $ms 2 False))
          (() (println! (It here $listconj)))
        ($debconj (replace $listconj))
        ($fitlered (remove_conjuncts_with_redundant_clauses $debconj))
    )
    $fitlered
    )
)


(= (do-conjunct $db $cndb $conjunct $ms (S $K))
    (let* (
         (() (println! (It here 1)))
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
(= (frequency-pattern-miner-old $kb $dbspace $specspace $cndpspace $aptrnspace $conjspace $minsup $depth)
    (superpose (
            (apriori $dbspace $minsup $aptrnspace) ; prevent patterns that dont have a support from being speciallized
            (match $aptrnspace (AbstractPattern $pattern) (build-specialization $pattern $dbspace $specspace)) ; specializa abstract patterns
            (candidatePattern $dbspace $specspace $minsup $cndpspace); get candidate patterns
            (match $cndpspace (CandidatePattern $pattern) (let $conj (do-conjunct $dbspace $cndpspace (replacev $pattern) $minsup (fromNumber $depth)) (if (== $conj ()) () (add-atom $conjspace $conj)))) ; store candidate patterns
            ; (match $conjspace $pattern (superpose ((add-atom &conjspace (supportOf $pattern (sup-num $dbspace (replacev $pattern)))) (remove-atom &conjspace $pattern))))
            (formatter $kb $conjspace $dbspace)
        ))
)

(= (frequency-pattern-miner $kb $dbspace $specspace $cndpspace $aptrnspace $conjspace $minsup $depth) (

    let* (  (() (println! (start)))
           (() (apriori $dbspace $minsup $aptrnspace)) ; prevent patterns that dont have a support from being speciallized
           ( $res  (match $aptrnspace (AbstractPattern $pattern) $pattern)) ; specializa abstract patterns
          ; (() (println! (pass 1 $res)))
           ($res2  (build-specialization (Inheritance Z (S Z)) $dbspace $specspace))
            (() (println! (pass 2 $res2)))
          
            ($res3  (candidatePattern $dbspace $specspace $minsup $cndpspace)); get candidate patterns
            (() (println! (pass 3 $res3)))
               
            ($res4  (match $cndpspace (CandidatePattern $pattern) $pattern)) ; store candidate patterns
            ($res7 (let $conj (do-conjunct $dbspace $cndpspace $res4 $minsup (fromNumber $depth))
                                 (if (== $conj ()) () (add-atom $conjspace $conj))))
            (() (println! (pass 4)))
           ;; ($res5 (match $conjspace $pattern (superpose ((add-atom $conjspace (supportOf $pattern (sup-num $dbspace (replacev $pattern)))) (remove-atom $conjspace $pattern)))))
            (() (println! (pass 5)))

          ; ($res6 (collapse (formatter $kb $conjspace $dbspace)))
            (() (println! (pass 6)))

            ) (Completed) 

))

(= (frequency-pattern-miner-old $kb $dbspace $specspace $cndpspace $aptrnspace $conjspace $minsup $depth) (
    let* ( ($res (call-me))
            (() (apriori $dbspace $minsup $aptrnspace)) )  $res
))


;  ! (apriori &dbspace 2 &aptrnspace)
;  ! (match &aptrnspace (AbstractPattern $pattern) $pattern)



