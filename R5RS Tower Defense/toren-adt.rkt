(define (maak-toren tile positie type)


    ;; verander tile
  (define (tile! nieuwe-tile)
    (set! tile nieuwe-tile))


  ;;; timer en ladingstijd
  (define timer 0)
  (define ladings-tijd 2000)
  (define loaded? #t) ;; tonen als toren geladen is
  
  (define geschoten? #f) ;; als toren geschoten heeft
  

  (define (ladings-tijd! sec) ;; updaten van de timer
    (set! timer (+ timer sec))
    (if (>= timer ladings-tijd) ;; als gelaten
        (set! loaded? #t)
        )
    )

  (define (verander-ladingstijd! nieuw-tijd) ;; veranderen van de ladingstijd 
    (set! ladings-tijd nieuw-tijd))

  (define (initialize-tijd!) ;; init van de timer
    (set! timer 0)
    (set! loaded? #f)
    )
 
  (define (positie! nieuwe-positie) ;; update positie
    (set! positie nieuwe-positie))

  (define (geschoten!) ;; upadten van de shoot
    (if geschoten?
        (set! geschoten? #f)
        (set! geschoten? #t)
        )
    )
  
  
  (define (dispatch-speler msg)
    (cond ((eq? msg 'positie) positie)
          ((eq? msg 'positie!) positie!)
          ((eq? msg 'prijs) prijs)
          ((eq? msg 'timer) timer)
          
          ((eq? msg 'tile) tile)
          ((eq? msg 'tile!) tile!)
          ((eq? msg 'type) type)
          ((eq? msg 'ladings-tijd) ladings-tijd)
          ((eq? msg 'ladings-tijd!) ladings-tijd!)
          ((eq? msg 'verander-ladingstijd!) verander-ladingstijd!)
          ((eq? msg 'initialize-tijd!) (initialize-tijd!))
          ((eq? msg 'loaded?) loaded?)
          ((eq? msg 'geschoten?) geschoten?)
          ((eq? msg 'geschoten!) (geschoten!))
          ((eq? msg 'prijs!) prijs!)
          ))
  dispatch-speler)