;; Standalone backward chaining experiments.

;;;;;;;;;
;; Nat ;;
;;;;;;;;;

;; Define Nat
(: Nat Type)
(: Z Nat)
(: S (-> Nat Nat))

;; Define <=
(: <= (-> $a $a Bool))
(= (<= $x $y) (or (< $x $y) (== $x $y)))

;; Define cast functions between Nat and Number
(: fromNumber (-> Number Nat))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))
(: fromNat (-> Nat Number))
(= (fromNat Z) 0)
(= (fromNat (S $k)) (+ 1 (fromNat $k)))


! "=== Bare Entail Match ==="



;; Knowledge base
!(bind! &kb (new-space))
!(add-atom &kb (: ECF (Evaluation croaks Fritz)))
!(add-atom &kb (: ECHT(Evaluation chirps Tweety)))
!(add-atom &kb (: ITY (Inheritance Tweety yellow)))
!(add-atom &kb (: EEFT (Evaluation eats_flies Tweety)))
!(add-atom &kb (: EEFF (Evaluation eats_flies Fritz)))


!(add-atom &kb (: croaks_eats_flies_frog_rule 
    (-> (Evaluation croaks $x) 
       (-> (Evaluation eats_flies $x) 
              (Inheritance $x frog)))))

!(add-atom &kb (: chirps_sings_canary_rule 
    (-> (Evaluation chirps $x) 
         (-> (Evaluation sings $x) 
               (Inheritance $x canary)))))

!(add-atom &kb (: frog_green_rule
    (-> (Inheritance $x frog) 
          (Inheritance $x green))))

!(add-atom &kb (: canary_yellow_rule 
    (-> (Inheritance $x canary)
          (Inheritance $x yellow))))

;; Base case
(= (bc $kb $_ (: $prf $ccln)) (match $kb (: $prf $ccln) (: $prf $ccln)))
;; Recursive step
(= (bc $kb (S $k) (: ($prfabs $prfarg) $ccln))
   (let* (((: $prfabs (-> $prms $ccln)) (bc $kb $k (: $prfabs (-> $prms $ccln))))
          ((: $prfarg $prms) (bc $kb $k (: $prfarg $prms))))
     (: ($prfabs $prfarg) $ccln)))


!(bc &kb (fromNumber 5) (: $prf (Inheritance $what green)))
;;(: (frog_green_rule ((croaks_eats_flies_frog_rule ECF) EEFF)) (Inheritance Fritz green))  