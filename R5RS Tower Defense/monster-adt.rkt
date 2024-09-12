(define (maak-monster-adt tile positie pad levens snelheid monster-type)

  (define timer 0) ;; timer bijhouden
  (define dood? #f) ;; levend of dood
  (define pad-counter 0) ;; aantal stappen
  (define pad-lengte 'te-definieren) ;; lengte pad
  (define movement? #f) ;; beweegt de monster of niet

  
  (define (monster-type! nummer) ;; monster-type veranderen 
    (set! monster-type nummer))


  (define (movement!) 
    (set! movement? #t))


  ;; update pad
  (define (pad-counter! step) ;; toevoegen step aan pad-ctr
    (set! pad-counter (+ pad-counter step)))

  (define (pad-lengte! lengte)
    (set! pad-lengte lengte))


  ;; update timer
  (define (timer! time)
    (set! timer (+ timer time)))

  (define (initialize-time!)
    (set! timer 0))
  
  ;; als er op monster word geschoten

  (define (rollback)

    (define (update-positie-terug richting)
      (cond
        ;; bekijken van de vorige richtingen, en omgekeerde doen
        ((eq? richting "rechts") (positie! "links"))
        ((eq? richting "links") (positie! "rechts"))
        ((eq? richting "boven") (positie! "onder"))
        ((eq? richting "onder") (positie! "boven"))
        ))

    
    (let* (
           (x (positie 'x))
           (y (positie 'y))
           )

      (if (or (eq? x 0) (eq? y 0))
          (set! positie (maak-positie x y))
          )      
      ;;;;;;

      (if (and (> x 0)(< x 2)) ;; zorgen dat je niet buiten het speelveld rollbackt
          (let (
                (step-1 (vector-ref pad (- pad-counter 1)))
                )
            (update-positie-terug step-1)
            (pad-counter! -1)
            )
          (let
              (
               (step-1 (vector-ref pad (- pad-counter 1))) 
               (step-2 (vector-ref pad (- pad-counter 2)))
               (step-3 (vector-ref pad (- pad-counter 3)))
               )            
            (update-positie-terug step-1)
            (update-positie-terug step-2)
            (update-positie-terug step-3)
            (pad-counter! -3)
            )
          )
      )
    )
      
          

  (define (dood! type) ;; bij sterven updaten levens
    (set! levens (- levens 1))
    
    (if (and (eq? monster-type 2) (eq? levens 1))
        (set! snelheid (+ snelheid 450))
        )
    
    (if (< levens 1)
        (set! dood? #t)
        (cond                  
          ((eq? type 3) (rollback))               
          )
        )
    )

  (define (tank!)
    (set! levens 0)
    (set! dood? #t)
    )
    

  ;; verander tile
  (define (tile! nieuwe-tile)
    (set! tile nieuwe-tile))

  
  ;; verander positie
  (define (positie! richting)
    (set! positie ((positie 'beweeg!) richting)))

  ;; verander initeel pos
  (define (initial-pos! pos)
    (set! positie pos))

  ; verander levens
  (define (levens! nieuw-leven)
    (set! levens nieuw-leven)
    )

  ; verander pad
  (define (pad! nieuw-pad)
    (set! pad nieuw-pad))

  ; verander snelheid

  (define (snelheid! nieuwe-snelheid)
    (set! snelheid nieuwe-snelheid))
 
  (define (dispatch-vijand msg)
    (cond

      ; code om elementen terug te krijgen
      ((eq? msg 'positie) positie)
      ((eq? msg 'levens) levens)
      ((eq? msg 'snelheid) snelheid)
      ((eq? msg 'tile) tile)
      ((eq? msg 'pad) pad)
      ((eq? msg 'dood?) dood?)
      ((eq? msg 'timer) timer)
      ((eq? msg 'pad-ctr) pad-counter)
      ((eq? msg 'pad-lengte) pad-lengte)
      ((eq? msg 'movement?) movement?)
      ((eq? msg 'monster-type) monster-type)

      ; code veranderen elementen
      ((eq? msg 'positie!) positie!)
      ((eq? msg 'initial-pos!) initial-pos!)
      ((eq? msg 'levens!) levens!)
      ((eq? msg 'snelheid!) snelheid!)
      ((eq? msg 'tile!) tile!)
      ((eq? msg 'pad!) pad!)
      ((eq? msg 'dood!) dood!)
      ((eq? msg 'timer!) timer!)
      ((eq? msg 'initialize-time!) (initialize-time!))
      ((eq? msg 'pad-ctr!) pad-counter!)
      ((eq? msg 'pad-lengte!) pad-lengte!)
      ((eq? msg 'movement!) (movement!))
      ((eq? msg 'monster-type!) monster-type!)
      ((eq? msg 'tank!) (tank!))
      ))

  dispatch-vijand)