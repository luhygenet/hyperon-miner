; helper functions
(= (is_var $v) (== (get-metatype $v) Variable))
(= (is_exp $v) (== (get-metatype $v) Expression))

; joins two expressions into one. e.g, (join ($a $b) ($c $d)) -> ($a $b $c $d)
(= (join $exp1 $exp2)(
      let* (
         ($h (car-atom $exp1))
         ($t (cdr-atom $exp1))
         ($x (if (== $t ()) $exp2 (join $t $exp2)))
      )
      (cons-atom $h $x)
))
; extracts variables from a nested expression and returns it
(= (extract_vars $exp)
   ( let* (
            ($h (car-atom $exp))
            ($t (cdr-atom $exp))
            ($x (if (is_var $h)
                     ($h)
                     (if (is_exp $h)
                        (if (== $h ())
                           ()
                           (extract_vars $h))
                        Nil )))
            ($y (if (== $t ()) () (extract_vars $t))))
         (if (or (== $x Nil) (== $x ()))
            $y
            (join $x $y))))

; finds existence of a variable on a list 
; returns a boolean
(= (find_var $list $var)(
   if (== $list ()) False
   (
      let ($head $tail)
          ((car-atom $list)(cdr-atom $list))
          (
            if (== $head $var)
               True
               (find_var $tail $var)
          )
   )
))


; finds a common variables between two variable lists
(= (common_vars $pattern1 $pattern2)(
   if (== $pattern1 ())()(
      let* (
         ($head (car-atom $pattern1))
         ($tail (cdr-atom $pattern1))
         ($x (
            if (find_var $pattern2 $head)
               $head
               Nil
         ))
         ($y (common_vars $tail $pattern2))
      ) (
         if (== $x Nil)
            $y
            (cons-atom $x $y)
      )
   )
))

; finds a common variables of the two expressions and return the expressions by removing those common variables
(= (remove_common_vars $exp1 $exp2)(
   let* (
      ($v1 (extract_vars $exp1))
      ($v2 (extract_vars $exp2))
      ($common (common_vars $v1 $v2))
      ($result ((_remove_common_vars $exp1 $common)(_remove_common_vars $exp2 $common)))
   ) 
   ( superpose $result)
))
(= (_remove_common_vars $exp $vars)(
   if (== $exp ())
      ()
      (
         let* (
            ($h (car-atom $exp))
            ($t (cdr-atom $exp))
            ($x (
               if (is_var $h)
                  (if (find_var $vars $h) Nil $h)
                  (if (is_exp $h) (_remove_common_vars $h $vars) $h)
            ))
            ($y (_remove_common_vars $t $vars))
         ) (
            if (or (== $x Nil) (== $x ()))
               $y
               (cons-atom $x $y)
         )
      )
))

; !(remove_common_vars (Inheritance $a ($b $x) $l) (Inheritance $b $c))   ; [(Inheritance $c), (Inheritance $a ($x) $l)]