; Python integration for max and min functions
! (bind! max (
    py-atom max (
        -> Number Number Number
    )
))

! (bind! min (
    py-atom min (
        -> Number Number Number
    )
))

; Function to count occurrences of a combination in the dataset
(= (count-occurrences $combination $data)
   (foldl (lambda ($count $item)
            (if (subset? $combination $item)
                (+ $count 1)
                $count))
          0 $data))

; Function to calculate the total number of observations
(= (total-observations $data)
   (length $data))

; Function to calculate empirical probability of a combination
(= (empirical-prob $combination $data)
   (/ (count-occurrences $combination $data) (total-observations $data)))

; Generalized function to calculate joint probability for any number of variables
(= (joint-prob $variables $data)
   (empirical-prob $variables $data))

; Generalized maxP function for any number of variables
(= (maxP $variables $data)
   (foldl max 0
          (map (lambda ($subset)
                 (* (empirical-prob $subset $data)
                    (empirical-prob (difference $variables $subset) $data)))
               (subsets $variables))))

; Generalized minP function for any number of variables
(= (minP $variables $data)
   (foldl min 1
          (map (lambda ($subset)
                 (* (empirical-prob $subset $data)
                    (empirical-prob (difference $variables $subset) $data)))
               (subsets $variables))))

; Generalized I-Surprisingness function
(= (i-surprisingness $variables $data)
   (let (($joint-prob (joint-prob $variables $data))
         ($maxP (maxP $variables $data))
         ($minP (minP $variables $data)))
     (max (- $joint-prob $maxP)
          (- $minP $joint-prob))))

; Generalized Normalized I-Surprisingness function
(= (normalized-i-surprisingness $variables $data)
   (/ (i-surprisingness $variables $data) (joint-prob $variables $data)))

; Helper functions

; Generates all non-empty subsets of a list (for maxP and minP)
(= (subsets $variables)
   (filter (lambda ($subset) (not (empty? $subset)))
           (powerset $variables)))

; Generates the power set (all subsets) of a list
(= (powerset $lst)
   (if (empty? $lst)
       (list '())
       (let (($rest (powerset (cdr $lst))))
         (append $rest (map (lambda ($subset) (cons (car $lst) $subset)) $rest)))))

; Calculates the difference between two sets
(= (difference $set1 $set2)
   (filter (lambda ($item) (not (member? $item $set2)))
           $set1))

; Checks if an item is a member of a list
(= (member? $item $lst)
   (if (empty? $lst)
       false
       (or (= $item (car $lst))
           (member? $item (cdr $lst)))))

; Checks if a list is empty
(= (empty? $lst)
   (match $lst
      ('() true)
      (_ false)))

; Calculates the length of a list
(= (length $lst)
   (if (empty? $lst)
       0
       (+ 1 (length (cdr $lst)))))

; Fold left function to accumulate a value across a list
(= (foldl $fn $init $lst)
   (if (empty? $lst)
       $init
       (foldl $fn ($fn $init (car $lst)) (cdr $lst))))
