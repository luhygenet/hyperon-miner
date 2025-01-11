




(=(croaks-eats_flies-frog-rule) 
(-> (Evaluation croaks $x) 
     (Evaluation eats_flies $x) 
      (Inheritance $x frog)))

(=(chirps-sings-canary-rule) 
(-> (Evaluation chirps $x) 
      (Evaluation sings $x) 
        (Inheritance $x canary)))

(=(frog-green-rule)
   (-> (true)
        (Inheritance $x frog) 
         (Inheritance $x green)))

(=(canary-yellow-rule) 
(-> (true)
     (Inheritance $x canary)
      (Inheritance $x yellow)))

