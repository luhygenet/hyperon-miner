! (register-module! ../../experiments)
! (import! &self experiments:rules:emp-tv)
! (import! &self experiments:rules:est-tv)
! (register-module! ../../../hyperon-miner)
! (import! &database hyperon-miner:experiments:data:sample-data)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (import! &self hyperon-miner:experiments:utils:TruthValue)
! (bind! square (py-atom numpy.square (-> Number Number)))




! (add-reduct &self (= (get-space) (new-space)))
! (add-atom (get-space) (Inheritance Abe human))
! (add-atom (get-space) (Inheritance Rio human))
! (add-atom (get-space) (Inheritance Bob human))
! (add-atom (get-space) (Inheritance Mike human))
! (add-atom (get-space) (Inheritance Zac human))
! (add-atom (get-space) (Inheritance Zac human))
! (add-atom (get-space) (Parent Abe Nil ))

;! (emp-tv (Inheritance $x human) (get-space))





                
;;!(confidence->count 1.02)



;!(get_tv_conf (STV 12 34))








;; !(eq_prob (get-space) ((Inheritance Abe human) (Inheritance Rio human) (Inheritance Bob human)) )
;; !(emp_tv_mem   ((Inheritance Abe human) (Inheritance Rio human) (Inheritance Bob human)) (get-space))




;; !(est_tv (get-space)  ((Inheritance $x human) (Inheritance $y human) (Inheritance $x $y)) )
;; !(mk_distribution_list (((Inheritance $x human) (EMPTV 1.0 0.05)) ((Inheritance $y human) (EMPTV 1.0 0.05)) ((Inheritance $x human) (EMPTV 1.0 0.05))))



(=(test_avrg_tv_1)(
    let* (
       ($tv_1 ((Inheritance Abe $x) (STV 0 0.1)))
       ($tv_2 ((Inheritance John $x) (STV 0 0.1)))
       ($result (avrg_tv ($tv_1 $tv_2)))

    )
    $result 
))


(=(test_avrg_tv_2)(
    let* (
       ($tv_1 ((Inheritance Abe $x) (STV 0 0.1)))
       ($tv_2 ((Inheritance John $x) (STV 1 0.1)))
       ($result (avrg_tv ($tv_1 $tv_2)))

    )
    $result 
))

(=(test_avrg_tv_3)(
    let* (
       ($tv_1 ((Inheritance Abe $x) (STV 1 0.001248)))
       ($tv_2 ((Inheritance John $x) (STV 1 0.001248)))
       ($tv_3 ((Inheritance John $x) (STV 0 0.001248)))
       ($tv_4 ((Inheritance John $x) (STV 1 0.001248)))
       ($tv_5 ((Inheritance John $x) (STV 1 0.001248)))
       ($tv_6 ((Inheritance John $x) (STV 1 0.001248)))
       ($tv_7 ((Inheritance John $x) (STV 1 0.001248)))
       ($tv_8 ((Inheritance John $x) (STV 1 0.001248)))
       ($tv_9 ((Inheritance John $x) (STV 1 0.001248)))
       ($tv_10 ((Inheritance John $x) (STV 1 0.001248)))
        
       ($result (avrg_tv ($tv_1 $tv_2 $tv_3 $tv_4 $tv_5 )))

    )
    $result 
))

!(test_avrg_tv_1)

;;!(confidence->count 0.8)
;;!(default_k)


;; https://www.boost.org/doc/libs/1_86_0/libs/math/doc/html/math_toolkit/dist_ref/dists/beta_dist.html



;; (0.011002444987775062 0.00011841900934533786)




;;for test
;;!(find_beta 0.6 0.05) alpha 2.28 beta 1.52

;;!(mk_stv 0.6 0.05) (0.711111111111111 0.004727544165215228)