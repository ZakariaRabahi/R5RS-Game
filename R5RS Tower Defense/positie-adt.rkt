(define (maak-positie x y)

  ;; beweeg function, richting => positie
  (define (beweeg! richting)
    (cond
      ((eq? richting "rechts") (maak-positie (+ x 1) y))
      ((eq? richting "links") (maak-positie (- x 1) y))
      ((eq? richting "boven") (maak-positie x (- y 1)))
      ((eq? richting "onder") (maak-positie x (+ y 1)))
      ))

  (define (dispatch-positie msg)
    (cond 
      ((eq? msg 'x) x)
      ((eq? msg 'y) y)
      ((eq? msg 'beweeg!) beweeg!)
      ))
  dispatch-positie)