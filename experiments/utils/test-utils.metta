! (register-module! ../../../hyperon-miner)
! (import! &database hyperon-miner:experiments:data:sample-data)
! (import! &self hyperon-miner:experiments:utils:common-utils)

 ;; check if count-atom-element returns number childrens in the
! (count-atom-element (abebe, abebe, abebe)) ;; 3

 ;; check if the count function returns the number of instances of a given pattern
! (count &database abebe) ;; 2

 ;; check if the sup-eval function returns True when a pattern's support is greater than minimum support
! (sup-eval $database abebe 1) ;; True