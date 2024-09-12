(define (maak-level-adt)

  (define level-ctr 0) ;; aantal levels aagemaakt
  (define vector-of-levels (make-vector 3)) ;; ;; vecot die levels bijhoudt


  (define (maak-level . waves) ;; aanmaken level die bestaat uit waves
    (vector-set! vector-of-levels level-ctr waves)
    (set! level-ctr (+ level-ctr 1))
    )

  (define (maak-wave aantal . monsters) ;; aanmaken van een wave
    (append (list aantal) monsters))


  ;; maken van de levels 

  (maak-level (maak-wave 6 '(("rood" 6))) (maak-wave 7 '(("rood" 6) ("blauw" 1))) (maak-wave 7 '(("rood" 4) ("blauw" 2) ("paars" 1))))

  (maak-level (maak-wave 7 '(("rood" 6) ("blauw" 1))) (maak-wave 11 '(("rood" 5) ("blauw" 4) ("paars" 2))) (maak-wave 9 '(("rood" 3) ("blauw" 3) ("paars" 3))))

  (maak-level (maak-wave 14 '(("rood" 5) ("blauw" 5) ("paars" 4))) (maak-wave 10 '(("rood" 4) ("blauw" 2) ("paars" 4))) (maak-wave 9 '(("rood" 3) ("blauw" 3) ("paars" 3))))


  ;; pad lvl 1

  (define pad1-level1 (vector "rechts" "rechts" "rechts" "rechts"
                        "onder" "onder" "onder"
                        "rechts"  "rechts" "rechts"
                        "boven" "boven" "boven"
                        "rechts"  "rechts"
                        "onder"
                        "rechts" "rechts"
                        "boven" "boven" "boven" "boven" "boven"
                        ))

  (define pad2-level1 (vector "boven" "boven"
                     "rechts"  "rechts"  "rechts"  "rechts"  "rechts"  "rechts"
                     "boven"
                     "rechts"  "rechts"
                     "onder" "onder" "onder" "onder"))


  ;; pad lvl 2
  (define pad1-level2 (vector "rechts" "rechts" "rechts" "rechts" "rechts" "rechts"
                              "onder"
                              "rechts"
                              "onder" "onder" "onder"
                              "rechts"
                              "onder" "onder" "onder" "onder" "onder"))

  (define pad2-level2 (vector  "boven" "boven" "boven"
                               "rechts" "rechts"
                               "onder"
                               "rechts" "rechts" "rechts" "rechts" "rechts"
                               "boven" "boven" "boven" "boven" "boven"
                               "rechts"
                               "boven" "boven" "boven" "boven" "boven"))

  ;; pad lvl 3

    (define pad1-level3 (vector "rechts" "rechts" "rechts" "rechts"
                                "boven"
                                "rechts" "rechts" "rechts" "rechts" "rechts"
                                "onder" "onder" "onder"
                                "links" "links" "onder"
                                "onder" "onder" "onder" "onder" "onder" "onder"))

  (define pad2-level3 (vector  "boven" "boven" "boven" "boven" "boven" "boven"
                               "rechts"
                               "boven"
                               "rechts" "rechts" "rechts" "rechts" "rechts" "rechts" "rechts"
                               "onder" "onder" "onder" "onder" "onder" "onder" "onder" "onder"))




  ;; maps van levels
  (define level1 (vector (vector 1 1 1 1 1 1 1 1 1 1 0 1 1 1 8 8)      ;; 0 = map
                         (vector 1 1 1 1 1 1 1 1 1 1 0 1 1 1 8 8)      ;; 1 = leeg
                         (vector 0 0 0 0 1 1 0 0 0 1 0 1 1 1 2 2)      ;; 2 - 5 = torens verschillende type
                         (vector 1 1 1 0 1 1 0 1 0 0 0 1 1 1 3 3)      ;; 6 = tank
                         (vector 1 1 1 0 1 1 0 1 1 1 1 1 1 1 4 4)      ;; 7 = start-knop
                         (vector 1 1 1 0 0 0 0 1 1 1 1 1 1 1 5 5)
                         (vector 1 1 1 1 1 1 1 1 1 1 1 1 1 1 7 7)
                         (vector 1 1 1 1 1 1 1 1 1 0 0 0 1 1 6 6)
                         (vector 1 1 1 0 0 0 0 0 0 0 1 0 1 1 8 7)
                         (vector 1 1 1 0 1 1 1 1 1 1 1 0 1 1 8 8)))

  (define level2 (vector (vector 1 1 1 1 1 1 1 1 1 1 1 0 1 1 8 8)     
                         (vector 1 1 1 1 1 1 1 1 1 1 1 0 1 1 8 8)      
                         (vector 0 0 0 0 0 0 1 1 1 1 1 0 1 1 2 2)      
                         (vector 1 1 1 1 1 0 0 1 1 1 0 0 1 1 3 3)     
                         (vector 1 1 1 1 1 1 0 1 1 1 0 1 1 1 4 4)     
                         (vector 1 1 1 1 1 1 0 1 1 1 0 1 1 1 5 5)
                         (vector 1 1 1 1 1 1 0 0 1 1 0 1 1 1 7 7)
                         (vector 1 1 1 0 0 0 1 0 1 1 0 1 1 1 6 6)
                         (vector 1 1 1 0 1 0 0 0 0 0 0 1 1 1 8 7)
                         (vector 1 1 1 0 1 1 1 0 1 1 1 1 1 1 8 8)))


  (define level3 (vector (vector 1 1 1 1 1 1 1 1 1 1 1 1 1 1 8 8)     
                         (vector 1 1 1 0 0 0 0 0 0 1 1 1 1 1 8 8)   
                         (vector 0 0 0 0 1 1 1 1 0 1 1 1 1 1 2 2)    
                         (vector 1 1 1 1 0 0 0 0 0 0 0 0 1 1 3 3)   
                         (vector 1 1 1 0 0 1 0 0 0 1 1 0 1 1 4 4)      
                         (vector 1 1 1 0 1 1 0 1 1 1 1 0 1 1 5 5)
                         (vector 1 1 1 0 1 1 0 1 1 1 1 0 1 1 7 7)
                         (vector 1 1 1 0 1 1 0 1 1 1 1 0 1 1 6 6)
                         (vector 1 1 1 0 1 1 0 1 1 1 1 0 1 1 8 7)
                         (vector 1 1 1 0 1 1 0 1 1 1 1 0 1 1 8 8)))


  ;; actuele level bijhouden en paden
  (define level-map level1) 
  (define pad1 pad1-level1)
  (define pad2 pad2-level1)

  ;; loaden van volgende level
  (define (next-level! level)
    (cond

      
      ((eq? level 1) (set! level-map level1)
                     (set! pad1 pad1-level1)
                     (set! pad2 pad2-level1)
                     )
      
      ((eq? level 2) (set! level-map level2)
                     (set! pad1 pad1-level2)
                     (set! pad2 pad2-level2)
                     )

      ((eq? level 3) (set! level-map level3)
                     (set! pad1 pad1-level3)
                     (set! pad2 pad2-level3)
                     )      
      )
    )
  
                    
  (define (dispatch msg)
    (cond
      ((eq? msg 'vector-of-levels) vector-of-levels)
      ((eq? msg 'level-ctr) level-ctr)
      ((eq? msg 'level-map) level-map)
      ((eq? msg 'pad1) pad1)
      ((eq? msg 'pad2) pad2)
      ((eq? msg 'restart!) (restart!))

      ((eq? msg 'next-level!) next-level!)
      
      ))

  dispatch)

  


  

