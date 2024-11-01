! (register-module! ../../experiments)
 ; ! (import! &self experiments:rules:emp-tv)
 ; ! (register-module! ../../../hyperon-miner)
 ; ! (import! &database hyperon-miner:experiments:data:sample-data)
 ; ! (import! &self hyperon-miner:experiments:utils:common-utils)
 ; ! (import! &self experiments:tests:List)
! (import! &self  test-utils)
! (import! &self  experiments:tests:List)
 ; ! (import! &self  experiments:tests:testUtils)
! (import! &self experiments:rules:emp-tv)
! (register-module! ../../../hyperon-miner)
! (import! &database hyperon-miner:experiments:data:sample-data)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (import! &self experiments:tests:testUtils)
! (import! &self  experiments:tests:SurprisingnessUTest)

! (add-reduct &self (= (get-space) (new-space)))
! (add-atom (get-space) (Inheritance Abe human))
! (add-atom (get-space) (Inheritance Rio human))
! (add-atom (get-space) (Inheritance Bob human))
! (add-atom (get-space) (Inheritance Mike human))
! (add-atom (get-space) (Inheritance Zac human))
! (add-atom (get-space) (Inheritance Zac human))
! (add-atom (get-space) (Parent Abe Nil ))

 ; ! (emp-tv (abebe) (get-space))

 ; ! (sup abebe (get-space))

 ;;tests

! ("============ test_emp_prob_bs ============ ")
! (populate_uniform_inheritance_links 1 2)
 ; ! (emp-prob (Parent $x) (new-space))
 ; ! (sup Abebe (new-space))
! (test_emp_prob_bs_1 Nil (new-space))

! ("============ sum ============ ")
! (sum  (Cons 1 (Cons 1 (Cons 2 Nil))))
! (sum  (Cons 3 (Cons 1 (Cons 2 Nil))))
! (+ 1 (sum  (Cons 3 (Cons 1 (Cons 2 Nil)))))

! ("============ len ============ ")
! (len  (Cons 1 (Cons 1 (Cons 2 Nil))))
! (len  (Cons 3 (Cons 1 (Cons 2 Nil))))

! ("============ avrg ============ ")
! (avrg  (Cons 1 (Cons 1 (Cons 2 Nil))))
! (avrg  (Cons 3 (Cons 1 (Cons 2 Nil))))

! ("============ TS_ASSERT_DELTA ============ ")
! (TS_ASSERT_DELTA 1 2 0.1)

! (add_link_and_populate_uniform_inheritance_link 3 1 4 (py-list ( (''))))
! (populate_uniform_inheritance_links 1 2)
! (biased_randbool 100)
! (populate_uniform_inheritance_link 1 0 0)
! (out_of_index 3 4)
! (add_link_and_populate_uniform_inheritance_link 0 0 0 (py-list ( ( ''))))
