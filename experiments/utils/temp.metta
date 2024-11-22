! (register-module! ../../../hyperon-miner)

! (register-module! ../../experiments)
! (import! &self experiments:rules:est-tv)
;;! (import! &self experiments:rules:emp-tv)

! (import! &database hyperon-miner:experiments:data:sample-data)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (import! &self hyperon-miner:experiments:utils:TruthValue)
! (import! &self hyperon-miner:experiments:utils:gen_partition)



! (bind! square (py-atom numpy.square (-> Number Number)))




! (add-reduct &self (= (get-space) (new-space)))
! (add-atom (get-space) (Inheritance Abe human))
! (add-atom (get-space) (Inheritance Abe human))
! (add-atom (get-space) (Inheritance Abe human))

! (add-atom (get-space) (Inheritance Rio human))
! (add-atom (get-space) (Inheritance Bob human))
! (add-atom (get-space) (Inheritance Mike human))
! (add-atom (get-space) (Inheritance Zac human))
! (add-atom (get-space) (Inheritance Zac human))
! (add-atom (get-space) (Parent Abe Nil ))
! (add-atom (get-space)  (Inheritance Bob (And human (Or zac))) ) 

;;! (emp-tv (Inheritance $x human) (get-space))

;!(estimate_v_xi (get-space) (Inheritanced Abe $y))



                
;;!(confidence->count 1.02)
;!(get_tv_conf (STV 12 34))
;;!(prod-etv (get-space)  ((Inheritance Abe human) (Inheritance Rio human) (Inheritance Bob human)) )
;;!(emp_tv_mem   ((Inheritance Abe human) (Inheritance Rio human) (Inheritance Bob human)) (get-space))
;; !(ji-est-tv (get-space)  ((Inheritance $x human) (Inheritance $y human) (Inheritance $x $y)) )
;; !(mk_distribution_list (((Inheritance $x human) (EMPTV 1.0 0.05)) ((Inheritance $y human) (EMPTV 1.0 0.05)) ((Inheritance $x human) (EMPTV 1.0 0.05))))
;;!(test_avrg_tv_1)
;;!(confidence->count 0.8)
;;!(default_k)
;; https://www.boost.org/doc/libs/1_86_0/libs/math/doc/html/math_toolkit/dist_ref/dists/beta_dist.html
;; (0.011002444987775062 0.00011841900934533786)
;;for test
;;!(find_beta 0.6 0.05) alpha 2.28 beta 1.52
;;!(mk_stv 0.6 0.05) (0.711111111111111 0.004727544165215228)
;;!(mk_stv 0.011002444987775062 0.00011841900934533786) 
;; !(get-clouses  (Inheritance (Human $X (And $x $y)) (Inheritance $Y (Human $Z))))
;;(Inheritance Bob (And human (Or zac Mike)))
;!(apend-list a (b c)) 
;;!(insert  (4 5 6) (1 2 3) )
;;!(push-back 4 (1 2 3))
;!(joint-variables-init (AND (Human $x $y) (OR (Man $x) (Inheritance $y $z))) ((Human $x $y) (Man $y (child $x $y)) (Inheritance $x $z)))
;!(get-variables (AND (Human $x $y) (OR (Man $x) (Inheritance $y $z))))
;;!(connected-subpatterns-with-var (((Inheritance $x $y) (Inheritance $z $a)) ((Inheritance $x $b) (Inheritance $z $y))) $y)
;;!(is-pattern ((Inheritance $x $y) (Inheritance $z $a)))
;!(let $pat_temp  (is-pattern (Inheritance $x $y)  ) (car-atom $pat_temp))


;!(ji-tv-est-init (get-space) (Inheritance (Or Bob $x) (Human $x $y)))
;;!(ji-tv-est-init (get-space) (Inheritance (Not $y) (Human $x (Or Bob $x))))
;!(ji-tv-est-init (get-space) (Inheritance Abe (Human $x (Or Bob $x))))


;!(add-subpatterns ((((Or Bob $x)) ((Human $x (Or Bob $x))))) (get-space))

;!(unify (Human $x $y) ($link $z $w) True False)

;!(joint-variables-init  (Inheritance (Or Bob $x) (Human $x)) (remove-parenthesis (((Or Bob $x) (Human $x)))))

;!(joint-variables-init  (Inheritance Abe (Human $x (Or Bob $x)))  (remove-parenthesis (((Or Bob $x)) ((Human $x (Or Bob $x))))) )

;!(remove-parenthesis (((Or Bob $y) (Human $x))))

;!(partitions_without_pattern (Inheritance Bob (And human (Or $x))))
;!(get-clouses (Inheritance Bob (And human (Or $x))))

;!(partitions ((And human (Or $x)) (Or $x)))

;!(valid-partitions ((And human (Or $x)) (Or $x)) ((((And human (Or $x)))) ))
;!(is-valid ((And human (Or $x)) (Or $x)) (((And human (Or $x)))) )

;!(is-valid (((And human (Or $x)) (Or $x))) ((((And human (Or $x))))))
;!(is-pattern  ((((And human (Or $x))))))

;!(get-subpatterns (((Or $x)) ((And human (Or $x)))) (get-space))

((((And human (Or $x)))) (((And human (Or $x)) (Or $x))) (((Or $x)) ((And human (Or $x)))))

;!(avrg_tv(ji-est-tv (get-space) (db_size get-space) (Inheritance Bob (And human (Or $x))) ((((Or $x)) ((And human (Or $x)))))))


;!(remove-parenthesis  (Or $x))

;!(add-subpatterns (((Or $x) (And $y))) (get-space))

;!(partitions_without_pattern (get-clouses (Inheritance (Or Bob $y) (Human $x))))
;!(partitions_without_pattern (get-clouses (Inheritance Abe (Human $x (Or Bob $y)))))
;!(get-clouses (Inheritance (Or Bob $y) (Human $x)))

;!(partitions (get-clouses (Inheritance Abe (Human $x (Or Bob $y)))))
;!(get-clouses (Inheritance Abe (Human $x (Or Bob $y))))

;!(is-present (remove-parenthesis ((((Human $x (Or Bob $z)))))) ((Human $x (Or Bob $y)) (Or Bob $y)))

( (((Human $x)) ((Or Bob $y))))

;!(get-clouses (Inheritance (Or Bob $y) (Human $x)))








;!(ji-tv-est-init (get-space) (Inheritance (Boy $y) (Human $x (Human Bob $x))))


    
  ;; ! (get-clouses (Inheritance (Boy $y) (Human $x (Or Bob $x))))

     ((Boy $y) (Human $x (Or Bob $x)) (Or Bob $x))



   ;;!(partitions_without_pattern ((Boy $y) (Human $x (Or Bob $x)) (Or Bob $x)))

   (
    
   (((Boy $y) (Or Bob $x)) ((Human $x (Or Bob $x)))) 
   (((Or Bob $x)) ((Boy $y) (Human $x (Or Bob $x)))) 
   (((Or Bob $x)) ((Human $x (Or Bob $x))) ((Boy $y))) 
   (((Human $x (Or Bob $x)) (Or Bob $x)) ((Boy $y))) 

   ((Boy $y) (Human $x (Or Bob $x))) 
   (((Human $x (Or Bob $x))) ((Boy $y))))





  ((AND (AND (Boy $y) (Or Bob $x)) (Human $x (Or Bob $x))))


  (((AND (AND (Boy $y) (Or Bob $x)) (Human $x (Or Bob $x))) (EMPTV 0.8 0.45)))


  ((Beta (mean 0.7990861257269455) (variance 0.00024416181160985805)))


  ;;!(mk-body  (((Boy $y) (Or Bob $x)) ((Human $x (Or Bob $z)))))
  ;;!(add-subpatterns (((Boy $y) (Or Bob $x)) ((Human $x (Or Bob $x))))  (get-space))

;;((Or Bob $x) (Human $x (Or Bob $x))) (Human $x (Or Bob $x))



(Inheritance $X $Y) 
(match &self (Inheritance C1 C2))

(Inheritance $X $Y) (Inheritance C1 $Y) 


;;!(generet-partition-without-pattern (,(Inheritance Zac $y) (Inheritance Bob $x) (Inheritance Abe $x)))


(((Boy $y)) ((Human $x (Human Bob $x))) ((Human Bob $x))) 
(((Boy $y) (Human Bob $x)) ((Human $x (Human Bob $x)))) 
(((Boy $y)) ((Human $x (Human Bob $x)) (Human Bob $x))) 
(((Boy $y) (Human $x (Human Bob $x))) ((Human Bob $x)))



(((Boy $y)) ((Child $x)))

;;!(do-ji-tv-est (get-space)  (Inheritance (Boy $y) (Human $x (Human Bob $x))))
;!(do-ji-tv-est (get-space)  (,(Inheritance Zac $y) (Inheritance Bob $x) (Inheritance Abe $x)))


;;!(get-variables (, (Inheritance $a $b) (Inheritance $b $c)))



;;!(get-cnj-clouses (,(Inheritance $a $b) (Inheritance $b $c) (Inheritance $d $e) (Inheritance $f $g)))



(=(emp_prob_pbs_mem $subpattern $db  $db_ratio) 0.7)


















(=(pro-prob-wout-joint $subpatterns $db $db_ratio $p) (
  if (== $subpatterns ()) $p (
    let* ((($subpattern $tail) (decons-atom $subpatterns))
           ($empr (emp_prob_pbs_mem $subpattern $db  $db_ratio))
           ($new_prob (* $p $empr)))
       (pro-prob-wout-joint $tail $db $db_ratio $new_prob)
  )
))



(=(ji-prob-est  $partition $pattern $db $db_ratio) (
     let $p (pro-prob-wout-joint $partition $db $db_ratio 1)
             (let $eq_prob (prob-with-joint $db (db_size $db) (remove-parenthesis $partition) (joint-variables-init $pattern (remove-parenthesis $partition)) 1)  
             (* $p $eq_prob)))
             )



(=(do-ji-prob $partitions $pattern $db $db_ratio) (
  if (== $partitions ()) () (
     let* ((($partition $tail) (decons-atom $partitions))
            ($jip (ji-prob-est $partition $pattern $db $db_ratio))
             ($dummy (do-ji-prob $tail $pattern $db $db_ratio)))
             (cons-atom $jip $dummy) ))
)



(=(ji_prob_est_interval $pattern $db $db_ratio) (
   let ($emin $emax) (min-max(do-ji-prob (generet-partition-without-pattern $pattern) $pattern $db $db_ratio))
        ($emin $emax)
))


;!(ji_prob_est_interval (,(Inheritance $x $y)  (Inheritance Abe $y)) (get-space) 2)







(=(isurp $pattern $db $normalize $db_ratio) (
    let* ((($emin $emax) (ji_prob_est_interval $pattern $db $db_ratio))
           ($emp (emp_prob_pbs_mem $subpattern $db  $db_ratio))
            ($dst (dst_from_interval $emin $emax $emp))
             ($maxprb (max ($emp $emax))))
               (min ((if $normalize (/ $dst $maxprb) $dst) 1.0))
))





;!(isurp (,(Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)) (get-space) True 2)

;[0.6455555555555555]


;;!(generet-partition-without-pattern (,(Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $x)))

($x $y $z)

(((Inheritance $x $y) (Inheritance Zac $x)) ((Inheritance Abe $y))) 
(((Inheritance $x $y)) ((Inheritance Abe $y)) ((Inheritance Zac $x))) 
(((Inheritance $x $y)) ((Inheritance Abe $y) (Inheritance Zac $x))) 
(((Inheritance $x $y) (Inheritance Abe $y)) ((Inheritance Zac $x)))








