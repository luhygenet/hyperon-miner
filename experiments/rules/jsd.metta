;; =============================================================================
;; Function: do-jsd
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Computes a modified Jensen-Shannon Divergence (JSD) between two probability 
;;   distributions. This is a symmetric measure of similarity between distributions 
;;   with custom logarithmic scaling.
;;
;; Parameters:
;;   - $empirical_distribution: Observed distribution (TruthValue type)
;;   - $estimated_distribution: Predicted distribution (TruthValue type)
;;
;; Internal Computation:
;;   1. Extract strength components from both distributions
;;   2. Calculate midpoint distribution average
;;   3. Compute logarithmic ratios (base 10):
;;      a. log(empirical/midpoint)
;;      b. log(estimated/midpoint)
;;   4. Calculate entropy contributions:
;;      a. (empirical_strength * log_ratio_empirical) / 2
;;      b. (estimated_strength * log_ratio_estimated) / 2
;;   5. Sum contributions and take square root
;;
;; Returns:
;;   - Non-negative float representing distribution divergence

;; =============================================================================

(= (do-jsd $empirical_distribution $estimated_distribution)
    (let* (
            ($empirical_strength (strength $empirical_distribution))
            ($estimated_strength (strength $estimated_distribution))
            ($midpoint_distribution (// (+ $empirical_strength $estimated_strength) 2))
            ($log_empirical_over_midpoint (log-math 10 (// $empirical_strength $midpoint_distribution)))
            ($log_estimated_over_midpoint (log-math 10 (// $estimated_strength $midpoint_distribution)))
            ($empirical_entropy_contribution (// (* $empirical_strength $log_empirical_over_midpoint) 2))
            ($estimated_entropy_contribution (// (* $estimated_strength $log_estimated_over_midpoint) 2))

        )
    (sqrt-math (+ $empirical_entropy_contribution $estimated_entropy_contribution))
)
)











