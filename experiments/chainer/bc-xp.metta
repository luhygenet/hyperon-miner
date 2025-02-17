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
!(bind! &kb_bem (new-space))
!(add-atom &kb_bem (→ A B))
!(add-atom &kb_bem (→ B C))
!(add-atom &kb_bem A)

;; Rule base
!(bind! &rb_bem (new-space))
!(add-atom &rb_bem (⊢
                    ;; Premises
                    (→ $p $q)
                    $p
                    ;; Conclusion
                    $q))
!(add-atom &rb_bem (⊢
                    ;; Premises
                    (→ $p $q)
                    (→ $q $r)
                    ;; Conclusion
                    (→ $p $r)))

;; Backward chainer
(: bc_bem (-> Atom Nat Atom))
;; Base case
(= (bc_bem $conclusion $depth)
   (match &kb_bem $conclusion $conclusion))
;; Recursive step
(= (bc_bem $conclusion (S $k))
   (match &rb_bem (⊢ $premise1 $premise2 $conclusion)
          (let* (($premise1 (bc_bem $premise1 $k))
                 ($premise2 (bc_bem $premise2 $k)))
            $conclusion)))