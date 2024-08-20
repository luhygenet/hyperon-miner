; implementation of i-surprisingness explained in https://wiki.opencog.org/w/Measuring_Surprisingness

; get max of two numbers
! (bind! max (
    py-atom max (
        -> Number Number Number
    )
))


; Define a function to calculate the total number of observations
(= (total-observations $data)
   (length $data))

; Define a function to calculate empirical probability of a combination
; count-occurrences yet to be implemented
(= (empirical-prob $combination $data)
   (/ (count-occurrences $combination $data) (total-observations $data)))

; Define a function to calculate the joint probability P(AB)
(= (joint-prob $A $B $data)
   (empirical-prob (list $A $B) $data))

; Define a function to calculate the joint probability P(ABC)
; list yet to be implemented
(= (joint-prob $A $B $C $data)
   (empirical-prob (list $A $B $C) $data))

; Define the maxP calculation function
(= (maxP $A $B $C $data)
   (max (* (joint-prob $A $B $data) (empirical-prob $C $data))
        (* (joint-prob $A $C $data) (empirical-prob $B $data))
        (* (joint-prob $B $C $data) (empirical-prob $A $data))
        (* (empirical-prob $A $data) (empirical-prob $B $data) (empirical-prob $C $data))))

; Define the minP calculation function
(= (minP $A $B $C $data)
   (min (* (joint-prob $A $B $data) (empirical-prob $C $data))
        (* (joint-prob $A $C $data) (empirical-prob $B $data))
        (* (joint-prob $B $C $data) (empirical-prob $A $data))
        (* (empirical-prob $A $data) (empirical-prob $B $data) (empirical-prob $C $data))))

; Define the I-Surprisingness function
(= (i-surprisingness $A $B $C $data)
   (max (- (joint-prob $A $B $C $data) (maxP $A $B $C $data))
        (- (minP $A $B $C $data) (joint-prob $A $B $C $data))))

; Define the normalized I-Surprisingness function
(= (normalized-i-surprisingness $A $B $C $data)
   (/ (i-surprisingness $A $B $C $data) (joint-prob $A $B $C $data)))
