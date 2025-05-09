!(import! &self  emp-tv-bs)

(= (subsample-py $db $new-space $subsize )
    (let* (
            
            ($db-content (collapse (get-atoms $db)))
            ($random-selected (generet_random_subsample $db-content $subsize))
            (() (println! (Here $random-selected)))
           ; ($space (copy-db  $new-space $random-selected))
            (() (println! (space $space)))
        )
        (add-atom $new-space (superpose $random-selected))
)
)

(= (avrg-tv-py $x) (mean-tv $x))



