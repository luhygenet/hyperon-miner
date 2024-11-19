
 ; This file contains utility functions for checking the metatype of a given variable.
 ; - (is-expression $var): Returns true if the metatype of $var is Expression.
 ; - (is-variable $var): Returns true if the metatype of $var is Variable.
 ; - (is-symbol $var): Returns true if the metatype of $var is Symbol.

(= (is-expression $var) (== Expression (get-metatype $var)))
(= (is-variable $var) (== Variable (get-metatype $var)))
(= (is-symbol $var) (== Symbol (get-metatype $var)))

 ; This function checks if a given expression is a pattern.
 ; It takes an expression ($expr) as input and evaluates whether it matches
 ; specific structures involving symbols, variables, and expressions.
 ; The function returns True if the expression is a pattern, otherwise False.
(= (is-pattern $expr) (

        or (unify $expr ($link $x $y) (
                and (is-symbol $link) (
                    or (or (is-variable $x) (is-expression $x))
                    (or (is-variable $y) (is-expression $y)))) False)
        (unify $expr ($link $x)
            (and (is-symbol $link)
                (or (is-variable $x)
                    (is-expression $x))) False )))

 ; this consider every thing as a pattern exept for symbole

(= (is-pattern-et $expr) (not (is-symbol $expr))

)
 ; Function: length
 ; Description: Calculates the length of a tuple.
 ; Parameters:
 ;   - $tuple: The tuple whose length is to be calculated.
 ; Returns:
 ;   - The length of the tuple as an integer.

(= (length $tuple) (
        if (== () $tuple)
        0
        (+ 1 (length (cdr-atom $tuple)))
    ))

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
 ; The average is computed by dividing the sum of the tuple elements by the length of the tuple.

(= (avrg-tuple $tuple)
    (/ (sum $tuple) (length $tuple))
)
