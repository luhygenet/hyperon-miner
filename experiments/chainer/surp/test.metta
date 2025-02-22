; ============================
; 1️⃣ MAX VALUE IN A LIST
; ============================
(= (max-value []) 0)  
(= (max-value (cons $x [])) $x)
(= (max-value (cons $x (cons $y $rest)))
    (if (> $x (max-value (cons $y $rest))) $x (max-value (cons $y $rest))))

; ============================
; 2️⃣ MIN VALUE IN A LIST
; ============================
(= (min-value []) 99999)  ; Assume a very high value for empty lists
(= (min-value (cons $x [])) $x)
(= (min-value (cons $x (cons $y $rest)))
    (if (< $x (min-value (cons $y $rest))) $x (min-value (cons $y $rest))))

; ============================
; 3️⃣ PUSH ELEMENT TO LIST
; ============================
(= (push $x $list) (cons $x $list))

; ============================
; 4️⃣ POP ELEMENT FROM LIST
; ============================
(= (pop []) [])
(= (pop (cons $x $rest)) $rest)

; ============================
; 5️⃣ REMOVE ELEMENT FROM LIST
; ============================
(= (remove-element $x []) [])
(= (remove-element $x (cons $x $rest)) (remove-element $x $rest))
(= (remove-element $x (cons $y $rest)) (cons $y (remove-element $x $rest)))

; ============================
; 6️⃣ REMOVE DUPLICATES
; ============================
(= (remove-duplicate []) [])
(= (remove-duplicate (cons $x $rest))
    (cons $x (remove-element $x (remove-duplicate $rest))))

; ============================
; 7️⃣ REVERSE LIST
; ============================
(= (reverse []) [])
(= (reverse (cons $x $rest)) 
    (append (reverse $rest) (cons $x [])))

; ============================
; 8️⃣ SORT LIST (Bubble Sort)
; ============================
(= (sort []) [])
(= (sort (cons $x [])) (cons $x []))
(= (sort (cons $x (cons $y $rest)))
    (if (> $x $y) (cons $y (sort (cons $x $rest))) (cons $x (sort (cons $y $rest)))))


;!(max-value (cons 3 (cons 5 (cons 2 []))))

!(sort (cons 4 (cons 1 (cons 5 []) )))
