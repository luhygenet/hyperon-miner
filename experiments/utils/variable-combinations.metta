; Check if a variable is in a list
(= (is-var-in-list $var $list) (if (== $list ()) False (let $head (car-atom $list) (if (== $var $head) True (is-var-in-list $var (cdr-atom $list))))))

