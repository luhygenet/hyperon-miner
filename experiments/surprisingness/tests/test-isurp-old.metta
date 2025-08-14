! (register-module! ../../../../hyperon-miner/experiments)
! (import! &self experiments:utils:common-utils)
! (import! &self experiments:utils:binomialMetta)
! (import! &self experiments:utils:beta-dist)
! (import! &self experiments:utils:constants)
! (import! &self experiments:utils:TruthValue)
! (import! &self experiments:utils:surp-utils)
! (import! &self experiments:utils:miner-utils)
! (import! &self experiments:utils:gen_partition)
! (import! &self experiments:truth-values:est-tv)
! (import! &self experiments:truth-values:emp-tv)
! (import! &self experiments:surprisingness:isurp-old)
! (import! &db experiments:data:ugly_man_sodaDrinker)

;;;;;;;;;;;
;; Tests ;;
;;;;;;;;;;;
;; Test old normalized I-Surprisingess for the ugly male soda drinker
;!(isurp-old (, (Inheritance $x human) (Inheritance $x sodaDrinker) (Inheritance $x man)) &db  True)
;!(isurp-old (,(Inheritance $x man) (Inheritance $x ugly)) &db  True)




; !(sup (((Inheritance John human) (Inheritance Rio sodaDrinker))) &db)
(=(sqrr $x) ( * $x $x))
; !(sqrr (superpose (1 2 3 4)))

; (= (sup $pattern $db)
;     (tuple-count 
;         (collapse 
;             (match $db $x (let $pattern $x $pattern)))))
; multiply all elements in a list
                     ; empty list → 1
(= (product $lists)
    (if(== $lists ())
        1 
        (let* (
            (() (println!("eziga" $lists)))
            (($head $tail) (decons-atom $lists))
        )

        (* $head (product $tail))
        )
    )
    
)           ; multiply head by product of tail
; !(product (1 2 3))

; NO MATTER WHAT EXPRESSION I PUT IN ALWAYS 144?
; !(collapse (sup ((superpose (A 2 3 4))) &db))
;PRODUCT WORKS WITH (1,2,3)
;PRODUCT DOESN'T WORK WITH WHAT'S RETURNED FROM SUP? [144,144,144,144,1,1]

(= (support2 $pattern $db) (
    let*( 
        ($patterns (get-clouses $pattern))
        (() (println!("support2" $patterns)))
        ($superposed (collapse ( sup (superpose $patterns) $db)))
        ($product (product $superposed))
     ) 
     $product
    )
)


(= (cons-atom-support $pattern $db) (
    (if(== $lists ()) 
      ()
        (let*(
            ($patterns (get-clouses $pattern))
            (($head $tail) (decons-atom($pattern)))
            ($head-pat (sup ($head) &db))
            ($next (cons-atom-support $tail $db))
        )
        (cons-atom ($head $head-pat) ($next))
        )
    )

))
; !(support (, (Inheritance John human) (Inheritance Rio sodaDrinker) (Inheritance Bob man)) &db)
!(support2 (, (Inheritance John human) (Inheritance Rio sodaDrinker) (Inheritance Bob man)) &db)



; a function that takes a bunch of patterns and returns the support 
; study the recursive nature of cons atoms
;  ((pt r1) (p2 s2))

; ((, (Inheritance John (woman)) (Inheritance Rio sodaDrinker) (Inheritance Bob man))
; (, (Inheritance John  man) (Inheritance Rio sodaDrinker) (Inheritance Bob man))
; ((, (Inheritance John human) (Inheritance Rio sodaDrinker) (Inheritance Bob man)) 204566))

;; hiht cons-atom 
; !(get-clouses (, (Inheritance John human) (Inheritance Rio sodaDrinker) (Inheritance Bob man)))
; !(get-clouses (A (B (C F)) D))
; !(collapse(get-clouses (, (Inheritance John human) (Inheritance Rio sodaDrinker) (Inheritance Bob man))))
; !(concatTuple (A B) (C (E F) D))