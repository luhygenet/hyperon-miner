

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
!(add-atom &kb (Evaluation croaks Fritz))
!(add-atom &kb (Evaluation chirps Tweety))
!(add-atom &kb (Inheritance Tweety yellow))
!(add-atom &kb (Evaluation eats_flies Tweety))
!(add-atom &kb (Evaluation eats_flies Fritz))



;; Rule base
!(bind! &rb (new-space))
(=(croaks-eats_flies-frog-rule) 
    (-> (Evaluation croaks $x) 
       (-> (Evaluation eats_flies $x) 
              (Inheritance $x frog))))

(=(chirps-sings-canary-rule) 
    (-> (Evaluation chirps $x) 
         (-> (Evaluation sings $x) 
               (Inheritance $x canary))))

(=(frog-green-rule)
    (-> (Inheritance $x frog) 
          (Inheritance $x green)))

(=(canary-yellow-rule) 
    (-> (Inheritance $x canary)
          (Inheritance $x yellow)))

!(add-reduct &rb (croaks-eats_flies-frog-rule))
!(add-reduct &rb (chirps-sings-canary-rule))
!(add-reduct &rb (frog-green-rule))
!(add-reduct &rb (canary-yellow-rule))

;; Backward chainer
(: bc_bem (-> Atom Nat Atom))
;; Base case
(= (bc_bem $conclusion $depth)
   (match &kb $conclusion $conclusion))

;; Recursive step
(= (bc_bem $conclusion (S $k))
   (match &rb (-> $premise  $conclusion)
          (let* (($premise (bc_bem $premise $k)))
            $conclusion)))

(= (bc_bem $conclusion (S $k))
   (match &rb (-> $premise1  (-> $premise2 $conclusion))
          (let* (($premise1 (bc_bem $premise1 $k)) 
                  ($premise2 (bc_bem $premise2 $k)))
            $conclusion)))

;; run the backward chainer to find out "What is green?" by defining a target

!(bc_bem (Inheritance $what green) (fromNumber 2))