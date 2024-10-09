! (register-module! ../../../hyperon-miner)
! (import! &self hyperon-miner:experiments:utils:gen_partition)

 ;;;;;;;;;;;;;;;;;;
 ;; gen-subsets ;;;
 ;;;;;;;;;;;;;;;;;;
 ;; input type
 ;;   (
 ;;      (Parent John Kalid)
 ;;      (Parent Jalid Beza)
 ;;      (Parent Nati Abis)
 ;;   )
 ;; ;;;;;;;;;;;;;;;
 ;;; output type ;;
 ;;;;;;;;;;;;;;;;;
 ; (
 ; ()
 ; ( (Parent John Kalid))
 ; ( (Parent Jalud Beza))
 ; ( (Parent Nati Abis))
 ; ( (Parent John Kalid) (Parent Jalud Beza))
 ; ( (Parent John Kalid) (Parent Nati Abis))
 ; ( (Parent Jalud Beza) (Parent Nati Abis))
 ; ( (Parent John Kalid) (Parent Jalud Beza) (Parent Nati Abis))
 ; )

! (gen-subsets ( (Parent John Kalid)
        (Parent Jalud Beza)
        (Parent Nati Abis)
    )
)

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;;;;                                 ;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;;;; generet-partion-without-pattern ;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 ;; input type
 ;;   (
 ;;      (Parent John Kalid)
 ;;      (Parent Jalid Beza)
 ;;      (Parent Nati Abis)
 ;;   )
 ;; ;;;;;;;;;;;;;;;
 ;;; output type ;;
 ;;;;;;;;;;;;;;;;;

 ; (
 ;     ( ( (Parent Jalud Beza) (Parent Nati Abis))
 ;         ( (Parent John Kalid))
 ;     )
 ; ( ( (Parent Jalud Beza))
 ;     ( (Parent John Kalid))
 ;     ( (Parent Nati Abis))
 ; )

 ; ( ( (Parent Jalud Beza) (Parent John Kalid))
 ;     ( (Parent Nati Abis))
 ; )

 ; ( ( (Parent Jalud Beza))
 ;     ( (Parent John Kalid) (Parent Nati Abis))
 ; )

 ; )

 ;;;;;;;;;;;;;;;;Simple Example from classic openCog ;;;;;;;;;;;;;;;
 ;;; input pattern = [A, B, C]
 ;; outPut
 ;	 *
 ;	 * [[[A],[C],[B]],
 ;	 *  [[C,A],[B]],
 ;	 *  [[C],[B,A]],
 ;	 *  [[A],[C,B]]]

! (generet-partition-without-pattern
    (
        (Parent John Kalid)
        (Parent Jalud Beza)
        (Parent Nati Abis)
    )
)
