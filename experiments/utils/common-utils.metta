;;;;;;;;;;;;;;;;;;
;; Common Utils ;;
;;;;;;;;;;;;;;;;;;

(= (pow-py $base $power) (pow-math $base $power)) 


(= (concatTuple $xs $ys)
    (if (== $xs ())
        $ys
        (let* ( (($head $tail) (decons-atom $xs))
                ($tailNew (concatTuple $tail $ys)))
                 (cons-atom $head $tailNew))  ))

(=(remove-parenthesis $x) (
    let ($head $tail) (decons-atom $x) (if (== $tail ()) (remove-parenthesis $head) $x)
))


(= (get-variables $pattern)
    (if (== $pattern ())
        ()
        (let* (
                ($head (car-atom $pattern))
                ($tail (cdr-atom $pattern)))

            (if (== (get-metatype $head) Expression)
                (concatTuple (get-variables $head)
                    (get-variables $tail))
                (if (== (get-metatype $head) Variable)
                    (concatTuple
                        ($head)
                        (get-variables $tail))

                    (get-variables $tail))))
    )
)


(=(is-symbol $var) 
   (== (get-metatype $var) Symbol)
)

(=(is-variable $var) 
   (== (get-metatype $var) Variable)
)

(=(is-expression $var) 
  (== (get-metatype $var) Expression)
)

(=(reverse-list ()) ())
(=(reverse-list $subparts)(
      let ($head $tail) (decons-atom $subparts) (push-back $head (reverse-list $tail))
))


(=(remove-element $element ())())
(=(remove-element $element $list) (
    let ($head $tail) (decons-atom $list) (
        if (== $element $head) (remove-element $element $tail) (
            let $dummy (remove-element $element $tail) (cons-atom $head $dummy)))))



(=(append-list $atom ()) ($atom))
(=(append-list $atom $list) (
    let* (
        (($head $tail) (decons-atom $list))
        ($dummy (append-list $head $tail))
    ) 
     (cons-atom $atom $dummy)))


(=(append-list-v2 $atom ()) ($atom))
(=(append-list-v2 $atom $list) (
    let* (
        (($head $tail) (decons-atom $list))
        ($dummy ((append-list $head $tail)))
    ) 
     (cons-atom $atom $dummy)))


(=(push-back $atom ()) ($atom))
(=(push-back $atom $list) (
    let* ((($head $tail) (decons-atom $list))
        ($dummy (push-back $atom $tail))) 
     (cons-atom $head $dummy)))


(=(insert () $res) $res)
(=(insert $subparts $res)(
      let ($head $tail) (decons-atom $subparts) (let $temp (push-back $head $res) (insert $tail $temp))))

(=(is-present $atom ()) False)
(=(is-present $atom $list) (
    if (is-expression $list) (
    let ($head $tail) (decons-atom $list) (
        if (== $atom $head) True  (or (is-present $atom $head) (is-present $atom $tail))
    )) (if (== $atom $head) True False)))


;; This function checks if a given expression is a pattern.
;; It takes an expression ($expr) as input and evaluates whether it matches

(=(is-pattern $expr) (
    collapse(
 or (unify $expr ($link $x $y) (
       and (is-symbol $link) (
        or (or (is-variable $x) (is-expression $x))
             (or (is-variable $y) (is-expression $y)))) False)
    (unify $expr ($link $x) 
       (and (is-symbol $link) 
        (or (is-variable $x) 
            (is-expression $x))) False ) )))

(=(is-valid () $partion) True)
(=(is-valid $clous $partion)(
    let ($head $tail) (decons-atom $clous)  (and (is-present $head $partion) (is-valid $tail $partion)) ))            

(=(comp $main_head ()) ())
(=(comp $main_head $list)(
    let* (
        (($x $tail) (decons-atom $list))
        ($rst (append-list (append-list $main_head  $x) (comp  $main_head $tail)))   
    ) $rst))


(=(get-clouses () ) ())
(= (get-clouses $pattern)
        (let* (
                (($head $tail) (decons-atom $pattern)))
            (if (== (get-metatype $head) Expression)
                (   let $result  (concatTuple ($head)
                    (get-clouses $tail)) (concatTuple $result (get-clouses $head)))
                    (get-clouses $tail))) )


(=(list-patterns $x) (  
    if (== $x ()) () (  
      let* ( 
            ($head (car-atom $x))
            ($tail (cdr-atom $x))
            ($tail_new (superpose(list-patterns $tail))))   
        (cons-atom $head $tail_new ) )))


(=(find_max $num_list $max) (
    if (== $num_list ()) $max (
        let* ((($head $tail)(decons-atom $num_list))
            ($dummy (find_max $tail (if (> $head $max) $head $max)))) 
            $dummy  )))

(=(max $list) (find_max $list (car-atom $list)))

(=(find_min $num_list $min) (
    if (== $num_list ()) $min (
        let* ((($head $tail)(decons-atom $num_list))
            ($dummy (find_min $tail (if (< $head $min) $head $min)))) 
            $dummy  )))


(=(min $list) (find_min $list (car-atom $list)))

(=(get-cnj-clouses $pattern) (
  let ($head $tail) (decons-atom $pattern)  (if (== $head ,) $tail ())
))


(=(min-max $list) ((min $list) (max $list)))

(=(var-appers $var ()) ())
(=(var-appers $var $blk) (
     let* ((($head $tail) (decons-atom $blk))
           ($is_present (let $temp (collapse (is-present $var $head))  (car-atom $temp)) )
           )
           (if $is_present  (let $dummy (var-appers $var $tail) (cons-atom $var $dummy)) (var-appers $var $tail))
           ))


(=(connected-subpatterns-with-var () $var) ())
(=(connected-subpatterns-with-var $partion $var)(
    let* (
        (($head $tail) (decons-atom $partion) )
       ($is_pattern (let $pat_temp  (is-pattern $head) (car-atom $pat_temp)))
        ($is_connected (let $temp (collapse (is-present $var $head)) (car-atom $temp))))

        (  if  (and $is_pattern $is_connected)
               (let $dummy (connected-subpatterns-with-var $tail $var ) (cons-atom $head $dummy)) 
                (if $is_pattern (connected-subpatterns-with-var $tail $var) (concatTuple  (connected-subpatterns-with-var $head $var) (connected-subpatterns-with-var $tail $var)) ))))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Common Utils from prev file ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;; Declaration of List data type and constructors
(: List (-> $a Type))
(: Nil (List $a))
(: Cons (-> $a (List $a) (List $a)))

 ;; Define Nat
(: Nat Type)
(: Z Nat)
(: S (-> Nat Nat))

 ;; Define cast functions between Nat and Number
(: fromNumber (-> Number Nat))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))
(: fromNat (-> Nat Number))
(= (fromNat Z) 0)
(= (fromNat (S $k)) (+ 1 (fromNat $k)))


 ; this consider every thing as a pattern exept for symbole
(= (is-pattern-et $expr) (not (is-symbol $expr))

)
 ; Function: tuple-count
 ; Description: Calculates the tuple-count of a tuple.
 ; Parameters:
 ;   - $tuple: The tuple whose tuple-count is to be calculated.
 ; Returns:
 ;   - The tuple-count of the tuple as an integer.
 ;; Count the number elements in an expression


;; This is very slow, use the grounded python function instead

   (: tuple-count (-> %Undefined% Number))
   (= (tuple-count $atom) (size-atom $atom))

;; Tuple count grounded python function
; (import! &self  helper)
; ! (import! &self  helper)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ; Function: sum
 ; Description: Calculates the sum of elements in a list.
 ; Parameters:
 ;   - $list: The list of numbers to be summed.
 ; Returns:
 ;   - The sum of the elements in the list as an integer.

(= (sum $list) (
        if (== $list ())
        0
        (+ (car-atom $list) (sum (cdr-atom $list)))
    ))

 ; This function calculates the average of a tuple of numbers.
 ; It takes a tuple as input and returns the average value.
 ; The average is computed by dividing the sum of the tuple elements by the tuple-count of the tuple.

(= (avrg-tuple $tuple)
    (/ (sum $tuple) (tuple-count $tuple))
)

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 ;; Count the number of instances of a given pattern
(: counter (-> hyperon::space::DynSpace Atom Number))
(= (counter $db $ptrn)
    (let $result (collapse (match $db $ptrn $ptrn))
        (tuple-count $result)
    )
)

 ; Count the number of instances of a given pattern
(= (count $pattern $db)
    (let* ( ($dptrn (Debruijn2var $pattern (Cons $Xvar (Cons $Yvar Nil))))
            ($result (collapse (match $db $dptrn $dptrn))))
        (tuple-count $result)))

 ;; Evaluate if the pattern has enough support
 ;; Evaluate if the pattern has enough support
(: sup-eval (-> hyperon::space::DynSpace Atom Number Boolean))

(= (sup-eval $db $pattern $ms)
    (let $sup (counter $db $pattern)
        (if (>= $sup $ms) True False)
    )
)
;; returns the number of support of a pattern

(= (sup-num $db $pattern)
    (let $sup (counter $db $pattern)
        $sup
    )
)

 ;Check if expression is truth value or not
(: cog-tv? (-> Atom Boolean))
(= (cog-tv? $EXP)
    (if (== (match &self (stv $value $mean $conf) True) True)
        True
        False
    )
)

(= (has-type $x Nil) False)
(= (has-type $x $y) (== $x (car-atom $y)))

 ;;(: get-arity (-> $pattern) Number)
 ;; we substruct 1 since the get-arity count the all tuple and we don't want to count
 ;; the "AND LINK" as a part of the arity
(= (get-arity Nil ) 0 )
(= (get-arity $pattern)
    (- (tuple-count $pattern) 1) )

 ;; implmenting get-arity for tree structure pattern type
(= (get-arity-tree $pattern) (
        if (has-type AND $pattern)
        ( let* (
                ( ($link $first $second) $pattern)
                ($first_arity (get-arity-tree $first))
                ($second_arity (get-arity-tree $second))

            )
        (+ $first_arity $second_arity)
    )
1
)
)

 ;     for pattern type Nil will run both implmentation of  n_conjucts
(= (n_conjuncts Nil) 0)
 ; (= (n_conjuncts $pattern)
 ;     (if (not (has-type lambda $pattern))
 ;         0
 ;         (if (or (has-type and $pattern) (has-type Present $pattern))
 ;             (get-arity (cdr-atom $pattern))
 ;             1)))

(= (n_conjuncts $pattern) (
        if (not (is-pattern-et $pattern))
        0
        (if (has-type , $pattern)
            (get-arity $pattern)
            1
        )

)
)

;; Function: intilize
;; 
;; Description:
;;   Initializes the given database by performing the following steps:
;;     1. Retrieves all atoms from the database ($db) using get-atoms.
;;     2. Collapses the retrieved atoms to form a simplified representation.
;;     3. Counts the number of tuples present in the collapsed data.
;;     4. Adds a new atom to self with the computed tuple count.
;;
;; Parameters:
;;   $db - The database object containing the atoms to process.
;;
;; Returns:
;;   The modified self with the new atom added, encapsulating the tuple count.
(= (intilize $db) (add-atom &self (db-size $db (tuple-count (collapse (get-atoms $db))))))

;; Function: db_size
;;
;; Description:
;;   Computes the size of a dynamic space by counting the number of atoms present.
;;
;; Parameters:
;;   $db - An instance of hyperon::space::DynSpace representing the database.
;;
;; Returns:
;;   A Number indicating the total count of atoms in the database.
;;
;; Details:
;;   - Retrieves all atoms from the dynamic space using get-atoms.
;;   - Collapses the list of atoms to a simpler form.
;;   - Uses tuple-count to determine the number of atoms.
 ;;db size
(: db_size (-> hyperon::space::DynSpace  Number))
(= (db_size $db)
     (tuple-count (collapse (get-atoms $db)))
    
)

 ;;abs accepts a number and returns an absolute value of a number
(: abs (-> Number Number))
(= (abs $x)
    (if (>= $x 0)
        $x
        (* $x -1)
    )
)



 ;; equals-to-zero  accepts a Number and compares it with zero if it is equals to zero it returns a boolean value True else False
(: equals-to-zero (-> Number Boolean))
(= (equals-to-zero $x) (== $x 0))

 ;; classify_integer_position function accepts a Number and returns a strings that tells if a number is Greater than zero equal to zero or less than zero
(: classify_integer_position (-> Number String))
(= (classify_integer_position $x)
    (if (> $x 0)
        ("Greater than zero")
        (case (equals-to-zero $x)
            (
                (False "Less than zero")
                (True "Equal to zero")))))
 ;; pow is a function that calculates a to the power of b where a and b are numbers
(: pow (-> Number Number Number))
(= (pow $a $b)
    (case (classify_integer_position $b)
        (
            ("Equal to zero" 1)
            ("Less than zero" (/ 1 (pow $a (abs $b))))
            ($_ (* $a (pow $a (- $b 1))))
        )
)
)

 ;; universe count
(= (universe-count $pattern $db)
    (pow-math (db_size $db) (n_conjuncts $pattern))

)

 ;Check if atom is member of list or not
(= (is-member $y ()) False)
(= (is-member $y ($x $xs))
    (if (== $y $x)
        True
        (is-member $y $xs)
    )
)


 ;check if atom is variable or not


 ; THIS IMPLEMENTATION CONSIDERS THE VARIABLE NAMES
 ; THIS WILL REMOVE REDUNDANT CLAUSES ALONG WITH THE ABSTRACTS
(= (is_more_abstract ($link1 $x1 $y1) ($link2 $x2 $y2))
    (if (== $link1 $link2)
        (if
            (and
                (or
                     ; Check if x1 and x2 are equal, or x1 is more abstract (a variable)
                    (== $x1 $x2)
                    (and
                        (== (get-metatype $x1) Variable)
                        (== (get-metatype $x2) Symbol)))
                (or
                     ; Check if y1 and y2 are equal, or y1 is more abstract (a variable)
                    (== $y1 $y2)
                    (and
                        (== (get-metatype $y1) Variable)
                        (== (get-metatype $y2) Symbol))))
            True
            False )
        False
    )
)



 ; Recursive function to check if the given clause is more abstract than any clause in the rest
(= (is_more_abstract_in_list $clause $clauses)
    (if (== $clauses ()) ; Base case: no more clauses to compare
        False
        (if (and (not (== $clause (car-atom $clauses))) (is_more_abstract $clause (car-atom $clauses))) ; Compare with the first clause
            True
            (is_more_abstract_in_list $clause (cdr-atom $clauses)) ; Recurse through the rest
        ))
)

 ; Function to remove abstract clauses from a list of patterns
(= (remove_abstract_clauses $clauses $original_clauses)
    (if (== $clauses ())
        ()
        (let* (
                ($clause (car-atom $clauses))
                ($is_abstract (is_more_abstract_in_list $clause $original_clauses)) ; Check if clause is abstract
            )
         ; If the clause is abstract, skip it; otherwise, keep it
        (if $is_abstract
            (remove_abstract_clauses (cdr-atom $clauses) $original_clauses) ; Skip the clause and continue
            ($clause (remove_abstract_clauses (cdr-atom $clauses) $original_clauses)) ; Keep the clause and continue
        )))
)

 ; Initial function to call to remove abstract clauses
(= (remove_abstract_clauses_initial $clauses)
    (remove_abstract_clauses $clauses $clauses) ; Start with original clauses
)


 ; Function: get_variables
 ; This function extracts all the variables from a given pattern (Expression).
 ; It works recursively by checking each element of the pattern to see if it is of the metatype "Variable".

(= (get_variables $pattern)
    (if (== $pattern ())
        ()
        (if (== (let* (
                        ($var (car-atom $pattern)))
                    (get-metatype $var)) Variable)
            ( (car-atom $pattern) (get_variables (cdr-atom $pattern)))
            (get_variables (cdr-atom $pattern))
        ))
)

 ; Helper function to check if a variable is in a nested list
(= (is_variable_in_list $variable $list)
    (if (== $list ())
        False ; If list is empty, return False
        (if (== $variable (car-atom $list))
            True ; If the variable matches the first item, return True
            (is_variable_in_list $variable (cdr-atom $list)) ; Check the rest of the list
        )
)
)

 ; Helper function to check if a variable is joint with any clause
(= (is_variable_joint_with_clauses $variable $clauses)
    (if (== $clauses ())
        False ; If no clauses are left, return False
        (let* (
                ($clause_vars (let $temp (car-atom $clauses) (get_variables $temp))) ; Extract variables from the current clause
            )
         ; Check if the variable is in the current clause's variables
        (if (is_variable_in_list $variable $clause_vars) ; ismember
            True ; If found, return True
            (is_variable_joint_with_clauses $variable (cdr-atom $clauses)) ; Otherwise, check the next clause
        )
)
))

 ; Recursive function to check all variables in the clause
(= (are_all_variables_joint () $clauses) True)
(= (are_all_variables_joint ($v $vs) $clauses)
    (if (is_variable_joint_with_clauses $v $clauses)
        (are_all_variables_joint $vs $clauses) ; Check the next variable
        False ; If one variable is not joint, return False
    )
)

 ; Main function: check if all variables in the clause are joint with other clauses
(= (has_only_joint_variables $clause $clauses)
    (let* (
            ($clause_vars (get_variables $clause)) ; Extract variables from the clause
        )
     ; Check if each variable in the clause is joint with the other clauses
    (are_all_variables_joint $clause_vars $clauses)
)
)

 ; Test: Check if all variables in the first clause are joint with others
 ; ! (has_only_joint_variables (Inheritance $X $Z $Y)
 ;     ( (Inheritance $X pet)
 ;         (Inheritance cat $Y)
 ;         (Inheritance $Z $X)))

 ;########################
 ; General function to remove redundant patterns if they are in
 ; list format
 ;########################

(: remove_redundant_clauses (-> (List Clause) (List Clause)))
(= (remove_redundant_clauses ())
    ()
)
(= (remove_redundant_clauses ( $clause $rest))
    (setInsert $clause (remove_redundant_clauses $rest))
)

(: setInsert (-> $t (List $t) (List $t)))
(= (setInsert $item ())
    ( $item ())
)
(= (setInsert $item ( $head $tail))
    (if (== $item $head)
        ( $head $tail)
        ( $head (setInsert $item $tail))
    )
)

 ; Test: Remove redundant clauses
 ; ! (remove_redundant_clauses
 ;     ( (Inheritance $X $Y)
 ;         ( (Inheritance $X $Y)
 ;             ( (Inheritance $X $Y)
 ;                 ( (Inheritance $X W) ())
 ;             )
 ;     )
 ; ))

 ;helper function to concat two tuples

 ;! (concatTuple (A B C) (D E F))

(= (is_subclause_helper $head $pattern)
    (if (== $pattern ())
        ()
        (let* (
                ($headP (car-atom $pattern))
                ($tail (cdr-atom $pattern)))

            (if (== (get-metatype $headP) Expression)
                (if (== $head $headP)
                    (True)
                    (concatTuple (is_subclause_helper $head $headP)
                        (is_subclause_helper $head $tail)))
                (is_subclause_helper $head $tail)
            ))

)
)
(= (is_subclause $pattern1 $pattern2)
    (let $flag (is_subclause_helper $pattern1 $pattern2)
        (if (== $flag ())
            False
            True)
    )
)

(= (remove_current $current_clause $original_expr)
    (if (== $original_expr ())
        ()
        (let* (
                ($head (car-atom $original_expr))
                ($tail (cdr-atom $original_expr)))
            (if (== $head $current_clause)
                (remove_current $current_clause $tail)
                (concatTuple ($head) (remove_current $current_clause $tail))))
    )
)

(= (remove_redundant_subclauses $exp)
    (remove_redundant_subclauses_helper $exp $exp)
)

(= (remove_redundant_subclauses_helper $expr $original_expr)
    (if (== $expr ())
        ()
        (let* (
                ($current_clause (car-atom $expr))
                ($remaining_expr (cdr-atom $expr))
                ($ori_exp_without_current (remove_current $current_clause $original_expr)))
            (if (is_subclause $current_clause $ori_exp_without_current)
                (remove_redundant_subclauses_helper $remaining_expr $original_expr)
                (concatTuple ($current_clause ) (remove_redundant_subclauses_helper $remaining_expr $original_expr))))
    )
)

 ; ! (is_subclause (Implies $x $y) (Implies (Human (Implies $x $y)) (Mortal $X)))
 ; ! (remove_redundant_subclauses (, (Implies $x $W) (Implies (Human (Implies $x $y) (Mortal $X))) (Mortal $X) ))

 ; ##############################


(= (is_pat_more_abstract $l_pat $r_pat $relative_var)
    (if (== (car-atom $l_pat) ,)
        (if (== (car-atom $r_pat) ,)
            (process_input_for_check (cdr-atom $l_pat) (cdr-atom $r_pat) $relative_var)
            (process_input_for_check (cdr-atom $l_pat) ($r_pat) $relative_var))
        (if (== (car-atom $r_pat) ,)
            (process_input_for_check ($l_pat) (cdr-atom $r_pat) $relative_var)
            (process_input_for_check ($l_pat) ($r_pat) $relative_var))
    )
)

(= (process_input_for_check $l_pat $r_pat $relative_var)
    (if (== $l_pat ())
        False
        (check_pattern_match (car-atom $l_pat) $r_pat $relative_var $l_pat $r_pat)
    )
)

(= (check_pattern_match $l_pat $r_pat $relative_var $ori_l_pat $ori_r_pat)
    (if (== $r_pat ())
        (process_input_for_check (cdr-atom $ori_l_pat) $ori_r_pat $relative_var)
        (if (is_more_abstract $l_pat  (car-atom $r_pat) $relative_var)
            True
            (check_pattern_match $l_pat (cdr-atom $r_pat) $relative_var $ori_l_pat $ori_r_pat))
    )
)


;; ------------------------------------------------------------------
;; Function: support
;;
;; Description:
;;   Computes the support value for a given pattern in relation to a
;;   database. The function recursively evaluates the support for each
;;   component (or "clouse") within the pattern.
;;
;; Parameters:
;;   $pattern - The pattern for which support is calculated. It can 
;;              consist of multiple sub-patterns obtained via get-clouses.
;;   $db      - The database context against which the pattern support
;;              is computed.
;;
;; Behavior:
;;   1. Retrieves the list of sub-patterns (clouses) using get-clouses.
;;   2. If the sub-pattern list is empty, returns a support value of 1,
;;      representing a base or trivial support.
;;   3. Otherwise, the function:
;;         - Decomposes the sub-pattern list into the head and tail.
;;         - Computes the support of the head using a separate
;;           support evaluation function (sup).
;;         - Recursively computes the support for the tail.
;;         - Multiplies the results to generate the overall support.
;;
;; Returns:
;;   A numeric value representing the cumulative support for the pattern.
;; ------------------------------------------------------------------
(= (support $pattern $db) (
    let $patterns (get-clouses $pattern) 
    
    (if (== $patterns ())
        1
        (let* (
                ($head (car-atom $patterns))
                ($tail (cdr-atom $patterns))
                ($sup (sup $head $db))

            )
            (* $sup (support $tail $db))
        )
    )
      
)
)
 


;; Documentation for add-conjunct:
;; 
;; Description:
;;   This function ensures that a given pattern starts with a comma.
;;   - If the input pattern is empty, it simply returns an empty pattern.
;;   - If the pattern is non-empty, the function checks its first element.
;;   - If the first element is already a comma, the pattern is returned unchanged.
;;   - Otherwise, it prepends a comma to the pattern and returns the new pattern.
;;
;; Parameters:
;;   $pattern - The list or pattern to which a comma may need to be added.
;;
;; Returns:
;;   A pattern that either remains unchanged (if it already starts with a comma or is empty)
;;   or has a comma prepended if the first element is not a comma.
( = (add-conjunct $pattern)
    (if (== $pattern ()) 
        () 
        (let $front-link (car-atom $pattern) 
            (if (== $front-link ,) 
            $pattern 
            (cons-atom , $pattern)
            )
        )
    )
)

