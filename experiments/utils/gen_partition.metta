! (import! &self  partition)



 ;  This function `get-clauses` takes an `Expression` as input and returns an `Expression`.
 ;  It checks if the first element (link) of the input expression is `And`.
 ;  If the link is `And`, it returns the rest of the elements (body) of the expression.
 ;  Otherwise, it returns the input expression itself.

(:get-clauses (-> Expression Expression))
(= (get-clauses $element)
    (let $link (car-atom $element)
        (if (== $link And)
            (cdr-atom $element)
            $element )))
 ; Function: add-to-subsets
 ; Description: Adds an element to each subset in a list of subsets.
 ; Parameters:
 ;   $element - The element to be added to each subset.
 ;   $subsets - The list of subsets to which the element will be added.
 ; Returns: A new list of subsets with the element added to each subset.
 ; Notes:
 ;   - If the list of subsets is empty, it returns an empty list.
 ;   - Uses recursion to process each subset in the list.

(: add-to-subsets (-> Expression Expression))

(= (add-to-subsets $element $subsets)
    (if (== $subsets ())
        () ; If the subsets list is empty, return an empty list

        (let* (
                ($head-sub (car-atom $subsets))
                ($tail-sub (cdr-atom $subsets))
                ($current (cons-atom $element $head-sub))
                ($rest (add-to-subsets $element $tail-sub))

            )
        (cons-atom $current $rest)
    )

)
)

 ; Function: concat-atom
 ; Concatenates two lists, $list1 and $list2, into a single list.
 ;
 ; Parameters:
 ; - $list1: The first list to concatenate. If this list is empty, the function returns $list2.
 ; - $list2: The second list to concatenate.
 ;
 ; Returns:
 ; - A new list that is the result of appending all elements of $list1 to the front of $list2.
 ;
 ; The function works recursively by taking the head of $list1 and attaching it to the result of
 ; concatenating the tail of $list1 with $list2. If $list1 is empty, it simply returns $list2.

(= (concat-atom $list1 $list2)
    (if (== $list1 ())
        $list2 ; If the first list is empty, return the second list
        (let* (
                ($head (car-atom $list1))
                ($tail (concat-atom (cdr-atom $list1) $list2))
            )
        (cons-atom $head $tail)
    ) ; Recursively attach elements of list1 to list2
)
)

 ;Function: powerset
 ;Description: Computes the powerset of a given list. The powerset is the set of all subsets of the list.
 ;Signature: (-> Expression Expression)
 ;Parameters:
 ;  - $lst: The input list for which the powerset is to be computed.
 ;Returns: The powerset of the input list, which is a list of all subsets of the input list.
 ;Base Case: If the input list is empty, the powerset is a list containing one empty set.
 ;Recursive Case:
 ;  1. Recursively compute the powerset of the rest of the list (excluding the first element).
 ;  2. Add the first element to each subset in the powerset of the rest of the list.
 ;  3. Combine the subsets with and without the first element to form the final powerset.

 ;;  for example
 ;;;;;;  input: ('A' 'B' 'C')
 ;;;;;;  output: (('A') ('B') ('C') ('A' 'B') ('A' 'C')  ('B' 'C') ('A' 'B' 'C'))

(: powerset (-> Expression Expression))
(= (powerset $lst)
    (if (== $lst ())
        (cons-atom () ()) ; Base case: the powerset of an empty list is a list with one empty set
        (let* (
                ($rest (powerset (cdr-atom $lst))) ; Recursive call to get powerset of the rest of the list
                ($with-current (add-to-subsets (car-atom $lst) $rest)) ; Add the first element to each subset in the powerset of the rest
            )
        (concat-atom $rest $with-current)) ; Combine the subsets with and without the current element
)
)

 ;;; generet-partition-without-pattern generates a partition using a Python implementation of gen-partition.
 ;;;
 ;;; Input:
 ;;; - $pattern: The original pattern to partition.
 ;;; - $subsets: A list of subsets derived from the original pattern.
 ;;;   Example: (('A') ('B') ('C') ('A' 'B') ('A' 'C') ('B' 'C') ('A' 'B' 'C'))
 ;;;
 ;;; Output:
 ;;; - A list of partitions generated from the subsets and the original pattern.
 ;;;   Example: ((('A') ('B') ('C')) ('A' 'B') ('C')) (('A' 'C') ('B'))
 ;;;
 ;;; Usage:
 ;;; (generet-partition-without-pattern $pattern)
 ;;; - This function calls gen-partition with the subsets and the original pattern.
 ;;; generet-partition-without-pattern is genrete aa partition using python implmentation of gen-partion

(: generet-partition-without-pattern (-> Expression Expression))
(= (generet-partition-without-pattern $pattern)
    (let* (
            ($clause (get-cnj-clouses $pattern))
            ($subsets (gen-subsets $clause))
        )
        
    (gen-partition $subsets $clause)
  
   ) ; gen-partition is registered

)
