
 ;; Rule to calculate the empirical truth value of a pattern.

 ;;;;;;;;;;
 ;; Type ;;
 ;;;;;;;;;;

(: TruthValue Type)

 ;;;;;;;;;;;;;;;;;;
 ;; Constructor ;;
 ;;;;;;;;;;;;;;;;;;

 ;; Takes pattern and db_ratio to form an
 ;; empirical truth value.
(: EMPTV (-> $a $b TruthValue))

(= (Default_k) 1)

 ;The count_to_confidence function calculates the confidence value based on a given count ($x).
 ;The confidence value is determined using a formula that incorporates a default constant (Default_k).
(= (count_to_confidence $x) (/ $x (+ $x (Default_k))))

 ;; calculate the empirical truth value of a pattern.
(= (emp-tv $pattern $db)
    (let*
        ( ( ($ucount ) ( (universe-count $pattern $db)))
            ( ($ms) ($ucount))
            ( ($sup) ( (sup $pattern $db)))
            ( ($conf) ( (count_to_confidence $ucount)) )
            ($mean (/ $sup $ucount))
            ($confidence   (* 1e-1 $conf))
        )
    (EMPTV $mean  $confidence)))

 ; The prob_to_support function calculates the support of a given pattern in a database based on a provided probability estimate.
 ;The support is determined by multiplying the probability estimate by the universe count of the pattern in the database.
 ; Parameters
 ; $pattern: The pattern for which the support is to be calculated. This is typically a data structure or identifier representing the pattern.
 ; $db: The database in which the pattern's support is to be calculated. This is typically a collection or sequence of data.
 ; $prob: The probability estimate of the pattern. This is a numeric value representing the likelihood of the pattern.
(= (prob_to_support $pattern $db $prob)
    (* $prob (universe-count $pattern $db))
)

 ; The support_estimate_calculator function calculates the support estimate for a given pattern in a database and then uses this estimate to compute the empirical truth value with bootstrapping if necessary.
 ;  It combines the probability estimate and database ratio to determine the effective database size and support estimate.
 ; Parameters
 ; $pattern: The pattern for which the support estimate and empirical truth value are to be calculated.
 ; $db: The database in which the pattern's support is to be calculated.
 ; $prob_estimate: The probability estimate of the pattern.
 ; $db_ratio: The ratio used to scale the database size.
(= (support_estimate_calculator $pattern $db $prob_estimate $db_ratio )

    (let* ( ($support_estimate (prob_to_support $pattern $db $prob_estimate ))
            ($database_size (* (db_size $db) $db_ratio)))
        (emp_tv_pbs $pattern $db $prob_estimate $db_ratio $database_size $support_estimate)))

 ;
 ;
 ; The categorize_subsize function categorizes the subsample size based on the comparison between the database size and the support estimate.
 ;  It returns a category identifier based on whether the support estimate is greater than or equal to the database size.
 ; Parameters
 ; $db_size: The size of the database.
 ; $support_estimate: The estimated support of a pattern in the database.
 ; Return Values
 ; 1: Returned if the support estimate is greater than or equal to the database size.
 ; 2: Returned if the support estimate is less than the database size.
(= (categorize_subsize $db_size $support_estimate)
    (if   (>= $support_estimate $db_size)
        1
        2)

)
 ;
 ;
 ;
 ;
 ; The emp_tv_pbs function calculates the empirical truth value of a pattern in a database, using bootstrapping if necessary.
 ; It categorizes the support estimate to decide the method for calculating the empirical truth value.

 ; Parameters
 ; $pattern: The pattern for which the empirical truth value is to be calculated.
 ; $db: The database in which the pattern's empirical truth value is to be calculated.
 ; $prob_estimate: The probability estimate of the pattern.
 ; $db_ratio: The ratio used to scale the database size.
 ; $db_size: The effective size of the database.
 ; $support_estimate: The estimated support of the pattern in the database.
 ; Return Values
 ; emp_tv_bs: Called if the support estimate is greater than or equal to the database size, using bootstrapping to calculate the empirical truth value.
 ; emp_tv: Called if the support estimate is less than the database size, directly calculating the empirical truth value.
 ; emp_tv: Default case, directly calculating the empirical truth value.
(= (emp_tv_pbs $pattern $db $prob_estimate $db_ratio $db_size $support_estimate)

    (case (categorize_by_support_estimate  $db_size $support_estimate)
        (
            (1 (emp_tv_bs $pattern $db))
            (2 (emp-tv $pattern $db))
            ($_ (emp-tv $pattern $db))
        )))

 ;;Support: number of data trees matching a given pattern.
(= (sup $pattern $db)
    (tuple-count (collapse (match $db $pattern $pattern))))

 ;;ji_tv_est_mem this function is used to estimate the joint probability of a pattern.
 ;;ji_tv_est_mem is going to implemented in est-tv rule.
(= (ji_tv_est_mem) (1 1))

 ;;TODO: it should be updated.
(= (emp_tv_bs $pattern $db)
    ( emp_tv $pattern $db)

)

 ;The categorize_subsize function categorizes a given subset size ($subsize) based on a threshold size ($ts).
 ;Parameters
 ;$subsize: The size of the subset to be categorized.
 ;$ts: The threshold size.
 ;Return Value
 ;Returns 2 if $subsize is greater than half of $ts.
 ;Returns 1 otherwise.
(= (categorize_subsize $subsize $ts)
    (if   (> $subsize (/ $ts 2))
        2
        1)

)

 ;; The copyDatabase function is designed to create a copy of the given database and return the new database.
 ;;This function ensures that all the contents of the original database are duplicated into a new database instance
 ;;copy-db function is designed to create a copy of the given database and return the new database.
(= (copy-db $db $old-db-content)
    (if (== $old-db-content ()) $db
        (let* ( ($_ (add-atom $db (car-atom $old-db-content)))

            )
        (copy-db $db (cdr-atom $old-db-content))
    )

))

 ; The add_n_atoms_to_db function is designed to add a specified number of atoms to a given database. This function recursively adds atoms until the specified number is reached.
 ; Parameters
 ; $db: The database to which atoms will be added.
 ; $n: The number of atoms to add to the database.
(= (add_n_atoms_to_db $db $n)
    (if (<= $n 0) $db
        (let* ( ($_ (add-atom $db Pattern))

            )
        (add_n_atoms_to_db $db (- $n 1))
    )

)

)

 ; The copy-and-add-atom function is designed to create a copy of the given database and add a specified number of atoms to the new database. This function ensures that the contents of the original database are duplicated into a new database instance, and then a specified number of atoms are added to the new database.
 ; Parameters
 ; $db: The original database to be copied.
 ; $n: The number of atoms to add to the new database.
(= (copy-and-add-atom $db $n)

    (if (<= $n 0) $db
        (let* ( ($new-db (copy-db (new-space) ( (collapse (get-atoms $db)) ))))

        )
    (add_n_atoms_to_db $db $n)
)

)

 ; The duplicate-and-expand-space function is designed to create a copy of the given space and add a specified number of atoms to the new space. This function ensures that all the contents of the original space are duplicated into a new space instance, and then a specified number of atoms are added to the new space.
 ; Parameters
 ; $space: The original space to be copied.
 ; $n: The number of atoms to add to the new space.
(= (duplicate-and-expand-space $space $n)
    (let $new-db (copy-db  (new-space) (collapse (get-atoms $space) ) )
        (add_n_atoms_to_db $new-db $n)

    )
)
! (duplicate-and-expand-space (get-space))
 ;

 ; The copy-db-by-size function is designed to create a copy of the given database up to a specified size. This function ensures that the contents of the original database are duplicated into a new database instance until the specified size is reached.
 ; Parameters
 ; $db: The new database instance where the contents of the original database will be copied.
 ; $old-db-content: The contents of the original database that need to be copied.
 ; $n: The current count of atoms added to the new database.
 ; $size: The maximum number of atoms to be copied to the new database.
(= (copy-db-by-size $db $old-db-content $n $size)
    (if (or (== $old-db-content ()) (>= $n $size)) $db
        (let* ( ($_ (add-atom $db (car-atom $old-db-content))))
            (copy-db-by-size $db (cdr-atom $old-db-content) (+ $n 1) $size)
        )

)
)

 ; The subsample function adjusts the size of a given database to match a specified subset size ($subsize). If the current size of the database is greater than or equal to the subset size, it returns the original database. Otherwise, it categorizes the database and either adds or removes atoms to achieve the desired subset size.
 ; Parameters
 ; $db: The database to be subsampled.
 ; $subsize: The target subset size for the database.
(= (subsample $db $subsize)
    (if (>= (db_size $db) $subsize)
        $db
        (case (categorize_subsize  $subsize (db_size $db))
            (
                (1 (duplicate-and-expand-space $db (- (* $subsize 2) (db_size $db)))) ; if it is in group 1 add atoms to the database
                (2 (copy-db-by-size (new-space) (collapse (get-atoms $db ) ) 0 (- (* $subsize 2) (db_size $db))))
                ($_ (copy-db-by-size (new-space) (collapse (get-atoms $db ) ) 0 (- (* $subsize 2) (db_size $db))))
            )))) ; if it is in group 2 remove atoms from the database

 ; The do_emp_tv function calculates the empirical truth value for a given pattern in a database.
 ; It first processes the database to obtain a sequence of atoms, estimates the joint truth value, and then uses the support estimate calculator to compute the final empirical truth value.
 ; Parameters
 ; $pattern: The pattern for which the empirical truth value is to be calculated.
 ; $db: The database in which the pattern's empirical truth value is to be calculated.
 ; $db_ratio: The ratio used to scale the database size.
(= (do_emp_tv $pattern $db $db_ratio )
    (let* ( ($db_sequence (collapse (get-atoms $db) ))
            ($jte  (ji_tv_est_mem $pattern $db_sequence)))
        (support_estimate_calculator  $pattern $db $jte $db_ratio))
)
