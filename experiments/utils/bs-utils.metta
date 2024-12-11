! (import! &self  emp-tv-bs)

(= (subsample-py $db $subsize )
    (let* (
            ($_ (println! (Started)))
            ($db-content (collapse (get-atoms $db)))
            ($random-selected (generet_random_subsample $db-content $subsize))
            ($_ (println! (here $random-selected)))
            ($space (copy-db  (new-space) $random-selected))
        )
    $space
)
)

(= (avrg-tv-py $x) (mean-tv $x))

(= (min $x $y) (if (> $y $x) $x $y))
(= (max $x $y) (if (> $y $x) $y $x))