 ;; load the following helper function
 ;;        map
 ;;        db-size
 ;;        sum
 ;;        sq
 ;;

! (register-module! ../../../hyperon-miner)
! (import! &self hyperon-miner:experiments:rules:emp-tv-bs)

! (bind! np-rnd (py-atom numpy.random))
(= (gen-random $max-value)  (
        (py-dot np-rnd randint) $max-value)
)

(= (get-element $index $list)
    (if (== $index 1)
        (car-atom $list) ; Return the first element if index is 0
        (get-element (- $index 1) (cdr-atom $list))))

(= (gen-random-subsample $db $subsize $space) ; must return a space which conteten the subsample only
    ( if (== (db_size $db) $subsize)
        $db
        (if (== $subsize 0)
            () ; Return an empty list if the sample size is 0
            (let* (
                    ($db-element (collapse (get-atom $db)))
                    ($random-index (gen-random $subsize)) ; Get a random index
                    ($element (get-element $random-index $db-element))
                    ($_ (println! $element))
                    ($_ (add-atom $space $element)) ; Get the element from the list
                    ($tail (gen-random-subsample $db (- $subsize 1)) $space) ; Recursively generate the rest of the subsample
                )
            $space))) ; Add the element to the subsample TODO: add the created subsample of the
)

(= (emp-tv-subsmp $pattern $db $subsize) (
        emp-tv $pattern (gen-random-subsample $db $subsize new-space)
    ))

 ; Helper function to repeatedly resample and collect empirical truth values
(= (emp-tv-bs-helper $pattern $db $n-resample $subsize)
    (if (= $n-resample 0)
        () ; Base case: no more resampling, return an empty list
        (let* (
                ($subsample-tv (emp-tv-subsmp $pattern $db $subsize)) ; Compute empirical truth value for subsample
                ($remaining-esstvs (emp-tv-bs-helper $pattern $db (- $n-resample 1) $subsize)) ; Recursive call
            )
        (cons-atom $subsample-tv $remaining-esstvs)))) ; Add the result to the list and continue

 ; Function to calculate empirical truth value with bootstrapping (resampling)
(= (emp-tv-bs $pattern $db $n-resample $subsize)
    (if (< $subsize (db_size $db))
        (let (
                ($esstvs (emp-tv-bs-helper $pattern $db $n-resample $subsize))
            )
        (avrg-tv $esstvs)) ; Return average of the empirical truth values
    (emp-tv $pattern $db))) ; If subsize >= db size, directly return empirical truth value

 ;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;;  avrg-tv     ;;;;;
 ;;;;;;;;;;;;;;;;;;;;;;;;;;

 ; Calculate the average of EMTV:
 ; 1. Convert each TV into a β distribution.
 ; 2. Calculate the mean of each β distribution.
 ; 3. Calculate the variance of each β distribution.
 ; 4. Calculate the average of the means of the β distributions.
 ; 5. Calculate the relative variance of each variance using the Mixture distribution.
 ; 6. Calculate the average of the relative variances.

 ; A function to get the beta distribution (α and β) from a truth value

(= (get-β-dis $emptv)
    (let* (
            ($value (cdr-atom $emptv))
            ($strength (car-atom $value))
            ($confidenceInter (cdr-atom $value))
            ($confidence (car-atom $confidenceInter))
            ($α (* $strength $confidence))
            ($β (* (- 1 $strength) $confidence))
            ($out ($α $β)) ; Store α and β as a list
        )
    $out
))

 ; Function to compute the mean of the Beta distribution
(= (mean-β-dis $betaDis)
    (let* (
            ($α (car-atom $betaDis))
            ($βInte (cdr-atom $betaDis))
            ($β (car-atom $βInte))
        )
    (/ $α (+ $α $β))
))

 ; Function to compute the variance of the Beta distribution
(= (variance-β-dis $betaDis)
    (let* (
            ($α (car-atom $betaDis))
            ($βInte (cdr-atom $betaDis))
            ($β (car-atom $βInte))
        )
    (/ (* $α $β)
        (*
            (* (+ $α $β) (+ $α $β))
            (+ (+ $α $β) 1)
        )
)
))

 ; Function to calculate the average mean
(= (avrg-means $means)
    (/ (sum $means) (length $means))
)

 ; Function to calculate the average variance
(= (avrg-variances $variances)
    (/ (sum $variances) (length $variances))
)

 ; Function to compute the relative variances

(= (relative-variance $means $variances $mean)
    (let
         ; Use map to iterate over means and variances simultaneously
        $adjusted-variances
        (relateive-varaince-helper
            $means
            $variances
            $mean
        )
     ; Return the adjusted variances
    $adjusted-variances
)
)

(= (relateive-varaince-helper $means $variances $mean)
    (if (or (== $means ()) (== $variances ())) ()
        (let* ( ($meanHead (car-atom $means))
                ($meanTail (cdr-atom $means))
                ($varianceHead (car-atom $variances))
                ($varianceTail (cdr-atom $variances))
                ($head-new  (+ $varianceHead (* (- $meanHead $mean) (- $meanHead $mean))))
                ($tail-new (relateive-varaince-helper $meanTail $varianceTail $mean))
            )
        (cons-atom $head-new $tail-new)
    )
)
)

(= (combine-varaince $variances $relateive-varaince)
    (if (or (== $relateive-varaince ()) (== $variances ())) ()
        (let* ( ($varianceHead (car-atom $variances))
                ($varianceTail (cdr-atom $variances))
                ($reVarHead (car-atom $relateive-varaince))
                ($reVarTail (cdr-atom $relateive-varaince))

                ($head-new  (+ $varianceHead $reVarHead))
                ($tail-new (combine-varaince $varianceTail $reVarTail))
            )
        (cons-atom $head-new $tail-new)
    )
)
)

 ; Orchestrating the overall process to calculate the average truth value
(= (avrg-tv $tvs)
    (let* (
             ; Extract Beta distributions from truth values
            ($beta-dists (map get-β-dis $tvs))

             ; Calculate the mean for each Beta distribution
            ($means (map mean-β-dis $beta-dists))

             ; Calculate the variances for each Beta distribution
            ($variances (map variance-β-dis $beta-dists))

             ; Calculate the overall average mean
            ($mean (avrg-means $means))

             ; Calculate relative variances
            ($relative-variances (relative-variance $means $variances $mean))

             ; Add relative variances to the variances
            ($combined-variances (combine-varaince $variances $relative-variances))
             ; Calculate the average variance
            ($variance (avrg-variances $combined-variances))

             ; Create the final truth value with the average mean and variance
            ($final-tv (EMPTV $mean $variance))
        )
    $final-tv
))
 ; ! (mean-tv ( (EMPTV 0.6 0.3) (EMPTV 0.5 0.2) (EMPTV 0.7 0.2) (EMPTV 0.4 1)))
 ;   (EMPTV 0.5499999999999999 0.356474358974359)

 ; ! (map variance-β-dis ( (0.18 0.12) (0.1 0.1) (0.13999999999999999 0.06000000000000001) (0.4 0.6)))
 ; ! (variance-β-dis (0.18 0.12))

! (add-atom &self (Parent Eyob Derese))
! (add-atom &self (Parent Meti Derese))
! (add-atom &self (Parent Zeni Derese))
! (add-atom &self (Parent Zeni Bekele))
! (add-atom &self (Parent babi Derese))

 ;!(collapse (get-atoms &self))

 ; ! (generet_random_subsample ( (Parent Eyob Derese)
 ;         (Parent Meti Derese)
 ;         (Parent Zeni Derese)
 ;         (Parent Zeni Bekele)
 ;         (Parent babi Derese)) 4)

! (match (gen-random-subsample &self 2 (new-space)) (Parent Zeni $x) $x)