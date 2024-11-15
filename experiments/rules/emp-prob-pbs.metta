 ; unsigned Surprisingness::subsmp_size (const Handle& pattern,
 ;     double db_size,
 ;     double support_estimate,
 ;     unsigned min_subsize)
 ; {
 ; double nc = MinerUtils:juncts (pattern) ;
 ; double alpha = support_estimate / std::pow (db_size, nc) ;
 ; double res = std::pow (db_size / (10*alpha), 1.0/nc) ;
 ; return std::max ( (unsigned)res, std::min (min_subsize, (unsigned)db_size)) ;
 ; }

(= (subsmp-size $pattern $db-size $support-estimate)
    (let* ( ($nc (n-conjuncts $pattern))
            ($min-subsize 10)
            ($alpha (/ $support-estimate (pow $db-size $nc)))
            ($res (pow (/ $db-size (* 10 $alpha)) (/ 1 $nc))))
        (max $res (min $min-subsize $db-size))
    )
)

 ; double Surprisingness::emp_prob_pbs (const Handle& pattern,
 ;     const HandleSeq& db,
 ;     double db_ratio)
 ; {
 ; if (1 < MinerUtils::n_conjuncts (pattern)) {
 ; // If there is more than one conjunct, calculate an estimate
 ; // first to subsample the db if necessary
 ; auto [emin, emax] = ji_prob_est_interval (pattern, db, db_ratio) ;
 ; return emp_prob_pbs (pattern, db, emax, db_ratio) ;
 ; } else {
 ; // Otherwise, no subsampling is necessary, should be tractable
 ; return emp_prob (pattern, db) ;
 ; }
 ; }

(= (emp-prob-pbs $pattern $db $db-ratio)
    (if (> 1 (n-conjuncts $pattern))
        (let ($emin $emax) (ji-prob-est-interval $pattern $db $db-ratio)

            (emp-prob-pbs $pattern $db $emax $db-ratio)
        )
    (emp-prob $pattern $db)
)
)

 ; double Surprisingness::emp_prob_pbs (const Handle& pattern,
 ;     const HandleSeq& db,
 ;     double prob_estimate,
 ;     double db_ratio)
 ; {
 ; // Calculate an estimate of the support of the pattern
 ; double support_estimate = prob_to_support (pattern, db, prob_estimate) ;
 ; double db_size = db.size () * db_ratio ;

 ; // If the support estimate is above the db size, then subsample
 ; if (db_size < support_estimate) {
 ; // Calculate the empirical probability of the pattern with downsampling
 ; unsigned subsize = subsmp_size (pattern, db_size, support_estimate) ;
 ; unsigned n_resample = 10 ;  // Number of resampling attempts
 ; double emp_prob = emp_prob_bs (pattern, db, n_resample, subsize) ;

 ; // Warn if empirical probability is zero, suggesting to increase db_ratio
 ; if (emp_prob == 0) {
 ; // Handle zero probability scenario (suggest increasing db_ratio)
 ; }

 ; return emp_prob ;
 ; } else {
 ; // Calculate empirical probability directly without subsampling
 ; return emp_prob (pattern, db) ;
 ; }
 ; }

(= (emp-prob-pbs $pattern $db $prob-estimate $db-ratio)
    (let* ( ($support-estimate (prob_to_support $pattern $db $prob-estimate))
            ($db-size (* (db-size $db) $db-ratio)))
        (if (< $db-size $support-estimate)
            (let* ( ($subsize (subsmp-size $pattern $db-size $support-estimate))
                    ($n-resample 10)
                    ($emp-prob (emp_prob_bs $pattern $db $n-resample $subsize)))

                (if (== $emp-prob 0)
                    (handle-zero-probability)
                )
            $emp-prob
        )
    (emp-prob $pattern $db)
)
)
)