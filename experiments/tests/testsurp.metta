! (register-module! ../../../hyperon-miner)
! (import! &database hyperon-miner:experiments:data:sample-data)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (import! &self hyperon-miner:experiments:tests:testUtils)
! (import! &self  hyperon-miner:experiments:tests:SurprisingnessUTest)

 ;; check if count-atom-element returns number childrens in the
! (tuple-count (abebe, abebe, abebe)) ;; 3
! (tuple-count (abebe abebe abebe))

! (tuple-count (abebe, abebe, abebe)) ;; 3
! (tuple-count (abebe abebe abebe))
 ;; check if the count function returns the number of instances of a given pattern
! (counter &database abebe) ;; 2

 ;; check if the sup-eval function returns True when a pattern's support is greater than minimum support
! (sup-eval $database abebe 1) ;; True

 ;; Test has-type
! (has-type lambda (lambda x y))
 ;; Test get-arity
! (get-arity (lambda  (Parent $x Nil)  (Parent $x Nil)))

 ;; TEST n_conjuncts
! (n_conjuncts (lambda   (Parent $x Nil) (Parent $x Nil)) )

 ;;test db size
! (add-reduct &self (= (get-space) (new-space)))
! (add-atom (get-space) (Inheritance Abe human))
! (add-atom (get-space) (Inheritance Rio human))
! (add-atom (get-space) (Inheritance Bob human))
! (add-atom (get-space) (Inheritance Mike human))
! (add-atom (get-space) (Inheritance Zac human))

! (db_size (get-space))

! (universe-count (lambda   (Parent $x Nil) (Parent $x Nil)) (get-space))

 ;;test pow
! (pow 5 3)
! (pow 100000 -7)
! (pow 5 3)
! (pow 1 0)
! (+ (abs -5) 10) ; 15
! (universe-count (lambda   (Parent $x Nil) (Parent $x Nil)) (get-space))
Pattern
(Pattern)
(lambda   (Parent $x Nil) (Parent $x Nil))
(Abebe)
! ("============ test_emp_prob_bs ============ ")
! (universe-count (Parent) (get-space))
! (sup Pattern &self)
! (sup (lambda   (Parent $x Nil) (Parent $x Nil)) &self)
! (universe-count (lambda   (Parent $x Nil) (Parent $x Nil)) (get-space))


! (emp-prob (lambda   (Parent $x Nil) (Parent $x Nil)) &self)
! (db_size &self)
! (subsmp  &self 2)
 ; ! (emp-prob (lambda   (Parent $x Nil) (Parent $x Nil)) &self)
 ; ! (emp_prob_bs  (lambda   (Parent $x Nil) (Parent $x Nil)) &self 1 2)
! (emp_prob_subsmp  (lambda   (Parent $x Nil) (Parent $x Nil)) &self 2)
! (emp-prob (lambda (Parent $x Nil) (Parent $x Nil)) &self)