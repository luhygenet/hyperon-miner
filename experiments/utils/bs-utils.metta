!(import! &self  emp-tv-bs)

(= (subsample-py $db $subsize )
    (let* (
            
            ($db-content (collapse (get-atoms $db)))
            ($random-selected (generet_random_subsample $db-content $subsize))
            ($space (copy-db  (new-space) $random-selected))
        )
    $space
)
)

(= (avrg-tv-py $x) (mean-tv $x))



