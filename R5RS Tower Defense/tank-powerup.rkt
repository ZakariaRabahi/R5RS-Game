(define (maak-tank positie tile pad1 pad2)

  (define timer 0) ;; tank heeft een beweginssnelheid, timer zorgt ervoor dat deze wordt gerespecteerd
  (define snelheid 200) ;; snelheid waarmee tank zich verplaatst

  (define (initialize-time!)  ;; procedure om timer te initialiseren
    (set! timer 0))

  (define pad-lengte (vector-length pad1)) ;; lengte van aantal staps
  (define pad-ctr 0)  ;; hvl staps er worden afgelegd
 
  (define (pad-counter! step) ;; update pad-ctr
    (set! pad-ctr (+ pad-ctr step)))
  
  (define pad pad1)  ;; onze pad begint in pad1 en eindigt in pad2, hier zetten we onze pad eerst op pad1
  (define pad1-finished? #f) ;; check voor als we pad 1 hebben afgelegd

  (define (next-pad!) ;; init next pad
    (set! pad pad2)
    (set! pad-lengte (vector-length pad2))
    (set! pad-ctr 0)
    (set! positie (maak-positie 3 10))
    )

  (define (timer! time)
    (set! timer (+ timer time))) ;; update timer

  (define (positie! richting) ;; update positie
    (set! positie ((positie 'beweeg!) richting)))


  (define (dispatch msg)
    (cond 
      ((eq? msg 'positie) positie)
      ((eq? msg 'positie!) positie!)
      ((eq? msg 'tile) tile)
      ((eq? msg 'timer) timer)
      ((eq? msg 'timer!) timer!)
      ((eq? msg 'snelheid) snelheid)
      ((eq? msg 'initialize-time!) (initialize-time!))
      ((eq? msg 'pad-lengte) pad-lengte)

      ((eq? msg 'pad) pad)
      ((eq? msg 'pad-ctr) pad-ctr)
      ((eq? msg 'pad-ctr!) pad-counter!)
      ((eq? msg 'next-pad!) (next-pad!))

      ))
  dispatch)