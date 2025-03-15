! (register-module! ../../../hyperon-miner/experiments)
! (import! &self experiments:utils:common-utils)
! (import! &self experiments:utils:beta-dist)
! (import! &self experiments:utils:constants)
! (import! &self experiments:utils:TruthValue)
! (import! &self experiments:utils:surp-utils)
! (import! &self experiments:utils:miner-utils)
! (import! &self experiments:utils:gen_partition)
! (import! &self experiments:rules:est-tv)
! (import! &self experiments:rules:emp-tv)
! (import! &kb experiments:data:ugly_man_sodaDrinker)







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


!(do-ji-tv-est  &kb (,(Inheritance $x sodaDrinker) (Inheritance $x human) (Inheritance $x woman)))


;;dummy
;; Emperical truth value for partitions of the pattern (,(Inheritance $x sodaDrinker) (Inheritance $x human) (Inheritance $x woman))
(EMPTV 0.018867924528301886 0.09814814814814815)   ;; comment out some of the facts
(EMPTV 0.016666666666666666 0.09836065573770492)   ;;full db

partitions
(
(
(((Inheritance $x human)) ((Inheritance $x sodaDrinker)) ((Inheritance $x woman))) 
(((Inheritance $x human) (Inheritance $x woman)) ((Inheritance $x sodaDrinker))) 
(((Inheritance $x human) (Inheritance $x sodaDrinker)) ((Inheritance $x woman))) 
(((Inheritance $x human)) ((Inheritance $x sodaDrinker) (Inheritance $x woman)))
)
)

;; result of each components 
(((((Inheritance $x human) (EMPTV 0.016666666666666666 0.09836065573770492)) 
((Inheritance $x sodaDrinker) (EMPTV 0.016666666666666666 0.09836065573770492)) 
((Inheritance $x woman) (EMPTV 0.016666666666666666 0.09836065573770492)))

 ((((Inheritance $x human) (Inheritance $x sodaDrinker)) (EMPTV 0.0002687449610319806 0.09997313272434176)) ;; 10
 ((Inheritance $x woman) (EMPTV 0.01639344262295082 0.09838709677419355))) ;;
 
 (((Inheritance $x human) (EMPTV 0.01639344262295082 0.09838709677419355)) 
 (((Inheritance $x sodaDrinker) (Inheritance $x woman)) (EMPTV 0.00026014568158168577 0.0999739921976593))) 
 
 ((((Inheritance $x human) (Inheritance $x woman)) (EMPTV 0.0002519526329050139 0.09997481108312344)) 
 ((Inheritance $x sodaDrinker) (EMPTV 0.015873015873015872 0.09843750000000001)))))

;; connected patterns
(
    (((Inheritance $x human) (Inheritance $x sodaDrinker) (Inheritance $x woman)) 
     ((Inheritance $x human) (Inheritance $x woman) (Inheritance $x sodaDrinker)) 
     ((Inheritance $x human) (Inheritance $x sodaDrinker) (Inheritance $x woman)) 
     ((Inheritance $x human) (Inheritance $x sodaDrinker) (Inheritance $x woman))))


((((Inheritance $x human) (Inheritance $x sodaDrinker)) ((Inheritance $x woman))) is 
   ((Inheritance $x human) (Inheritance $x sodaDrinker) (Inheritance $x woman))) 

;!(sup-num &kb (Inheritance $x woman))

;!(emp-tv (, (Inheritance $x sodaDrinker) (Inheritance $x woman)) &kb)

;!(conjunct-pattern ((Inheritance $x sodaDrinker) (Inheritance $x woman)) &kb)


;!(do-ji-tv-est (get-space) (,(Inheritance $x $y)  (Inheritance Abe $y) (Inheritance Zac $y)))
;(((Inheritance $x man) (Inheritance $x sodaDrinker)) ((Inheritance $x ugly)))
;[((((Inheritance $x man)) ((Inheritance $x sodaDrinker) (Inheritance $x ugly))) ((EMPTV 0.16129032258064516 0.09841269841269841) (EMPTV 0.0 0.09841269841269841)))]

;;!(emp-tv  (remove-parenthesis (, (Inheritance $x sodaDrinker) (Inheritance $x ugly))) &kb)


;!(flatten (, (, (Inheritance $x human) (Inheritance $x sodaDrinker)) (Inheritance $x man)))