! (import! &self eq_prop)


!(eq-prob-py (
    ((Inheritance $X $y) (Inheritance $x ugly))
    ((Inheritance $x Human))
 ) 
    ((Inheritance $x Human) (Inheritance $x ugly) (Inheritance $x $y))
    
    65
)