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
! (import! &self experiments:surprisingness:isurp-old)
! (import! &db experiments:data:ugly_man_sodaDrinker)



; (= (sup $pattern $db)
;     (tuple-count 
;         (collapse 
;             (match $db $x (let $pattern $x $pattern)))))
; (= (map $f ()) ())
; (= (map $f (:: $x $xs))
    
;    (:: ($f $x) (map $f $xs)))

(= (unwrap (($inner...))) ($inner...))


; !(unwrap ((((Inheritance John human) (Inheritance Rio sodaDrinker) (Inheritance Bob man)))))
; (= (support $pattern $db) (
;     let $patterns (get-clouses $pattern) 
    
;     (if (== $patterns ())
;         1
;         (let* (
;                 ($head (car-atom $patterns))
;                 ($tail (cdr-atom $patterns))
;                 (() (println!("here")))
;                 (() (println!($head $tail)))
;                 ($sup (sup $head $db))
;                 (() (println!($sup)))
;                 (() (println!("above was the number")))

;             )
            
;             (* $sup (support $tail $db))
;         )
;     )  
; ))

; (= (support $pattern $db) 
;     (let*(
;       ($gottenclouses  (get-clouses $pattern))
;       (() (println!("gottenclouses")))
;       (() (println!($gottenclouses)))
;       ($unwrapped (unwrap($gottenclouses)))
;       (() (println!("justunwrapped")))
;       (() (println!($unwrapped)))
;       )
;       (sup(superpose($unwrapped)) $db)
;     )
    
; )
; !(sup (((Inheritance John human) (Inheritance Rio sodaDrinker) (Inheritance Bob man))) &db)
 !(support (, (Inheritance John human) (Inheritance Rio sodaDrinker) (Inheritance Bob man)) &db)

; !(sup (A B) hyperon::space::DynSpace)
