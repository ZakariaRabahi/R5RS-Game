(define (maak-spel)

  (let*
      
      (

       ;; window
       (teken-adt (maak-tekening venster-breedte-px venster-hoogte-px))
       (level-adt (maak-level-adt))
       (vector-of-levels (level-adt 'vector-of-levels))

       ;; level map en paden
       (level-map (level-adt 'level-map))
       (pad1 (level-adt 'pad1))
       (pad2 (level-adt 'pad2))

       
       ;; vectors bijhouden spel-elementen
       (monster-vector 'vec)
       (toren-vector (make-vector 99))

       ;; ctrs voor manuele toren
       (manueel-toren-gekozen? #f)
       (manueel-toren-pos 'none) ;; positie van de m-toren bijhouden bij aanmaken toren
       (manueel-toren-shot 'none) ;; plaats van de projectiel
       (manueel-toren-shot? #f)

       ;; tank powerup
       (tank #f)
       (tank-timer 10000)
       
       (tank-object 'none)

       ;; counters
       (monster-ctr 0)
       (toren-ctr 0)
       (te-bewegen-monsters 1)
       (wave-ctr 1)
       
       (level 0)
       (timer 0)
       (geld 40)
       (levens 10)

       (toren-gekozen? #f)
       (manueel-toren? #f)
       (gekozen-toren-type 2)

       ;; level die nu bezig is

       (huidige-level (vector-ref vector-of-levels level))

       
       ;; ctrs voor laden nextlevel of wave
       (next-wave-ctr #f)
       (next-wave-timer 0)

       (next-level-ctr #f)
       (next-level-timer 0)

       (main-menu #t)
       (game-loop #f)
       (game-over #f)
       (win #f)
       (start-wave? #f)
       (end-game #f)
       )

    ;; procedure om elementen te zoeken in de spel-matrix
    (define (zoek-matrix x y matrix)
      (vector-ref (vector-ref matrix y) x))

    ;; later nodig om torens te plaatsen in de map
    (define (set-matrix! x y matrix new)
      (vector-set! (vector-ref matrix y) x new))

    ;; laden nieuwe level
    (define (load-next-level)
      (if (< level (level-adt 'level-ctr))
          (begin
            (set! huidige-level (vector-ref vector-of-levels level))
            (set! next-level-ctr #t)
            )
          (begin
          (set! win #t)
          )
          )
      )


    (define (reset-level) ;; level reset gebeurt door alle level elementen up-te-daten, spelelementen te wissen (torens, monsters, ...)
      ((teken-adt 'update-level!) (+ level 1))
      ((teken-adt 'update-wave!) 1)
      (set! tank #f)
      (teken-adt 'verwijder-alle-torens!)
      (set! toren-vector (make-vector 99))
      (set! toren-ctr 0)

      (set! manueel-toren-gekozen? #f)
      (set! manueel-toren-pos 'none)
      (set! manueel-toren-shot 'none)
      (set! manueel-toren-shot? #f)

      (teken-adt 'remove-background!)
      ((teken-adt 'teken-background!) (+ level 1))
          
          
      (set! wave-ctr 1)
      (set! start-wave? #f)
      ;(set! game-loop #f)
      ((level-adt 'next-level!) (+ level 1))
      (set! level-map (level-adt 'level-map))
      (set! pad1 (level-adt 'pad1))
      (set! pad2 (level-adt 'pad2))
         
      (load-next-level)
      )

       (define (load-next-wave) ;; next wave loaden
      (if (not (null? (cdr huidige-level))) ;; als er geen andere wqves zijn, dan pas nieuwe level andsers gwn next wave
          (begin
            (set! huidige-level (cdr huidige-level))
            (set! wave-ctr (+ wave-ctr 1))
            ((teken-adt 'update-wave!) wave-ctr)
            (set! next-wave-ctr #t)
            (set! start-wave? #f)
            ;(set! game-loop #f)
            
            )
          (if (< level (level-adt 'level-ctr))
              (begin
                (set! level (+ level 1))
                (reset-level)
                )
              (begin
                (set! level 0)
                (reset-level)
                )
              )
          )
         )


    (define (check-end-wave vector) ;; procedure check als wave gedaan is, dit is wanneer de monster-vector enkel nullen bevat

      (define end #t)

      (define (iter ctr max)
        (if (< ctr max)
            (if (eq? 0 (vector-ref vector ctr))
                (iter (+ ctr 1) max)
                (set! end #f)
                )
            )
        )

      (iter 0 monster-ctr)
      (if end
          (load-next-wave)
          
          )
      )


    ;; monster aanmaken

    (define (maak-monsters)
      (let* (
             (huidige-wave (car huidige-level))
             (aantal-monsters (car huidige-wave))
             (te-tekenen-monsters (cadr huidige-wave))
             )
        
        (set! monster-vector (make-vector aantal-monsters)) ;; vector die alle monsters van de wave bijhoudt
        (set! monster-ctr 0) ;; met welke monster we bezig zijn
        (set! te-bewegen-monsters 1) ;; hoeveel monsters we aan het bewegen zijn

        (define (maak-monster-object lijst) ;; procedure om monsters aan te maken vanuit gegeven level-lijst
          (if (not (null? lijst))
              (begin
                (let* (
                       (monsters (car lijst))
                       (kleur (car monsters))
                       (aantal-keren (cadr monsters))
                       (levens 1)
                       (snelheid 800)
                       (monster-type 'none)
                       )
                  
                  (define (iter aantal)
                    (if (eq? aantal 0)
                        (maak-monster-object (cdr lijst))
                        (begin
                          (cond  ;; checken voor kleur voor aanamaken juiste monster
                            ((eq? kleur "paars") (set! kleur paars-monster)
                                                 (set! levens 4)
                                                 (set! monster-type 3)
                                                 )
                            ((eq? kleur "blauw") (set! kleur blauw-monster)
                                                 (set! levens 3)
                                                 (set! snelheid 500)
                                                 (set! monster-type 2)
                                                 )
                            ((eq? kleur "rood") (set! kleur rood-monster)
                                                (set! monster-type 1)
                                                )
                            )
                          
                          (vector-set! monster-vector monster-ctr (maak-monster-adt (make-bitmap-tile kleur "images/monster_mask.png")
                                                                                    (maak-positie -1 2)
                                                                                    (random 1 3)
                                                                                    levens
                                                                                    snelheid
                                                                                    monster-type
                                                                                    ))
                          (set! monster-ctr (+ monster-ctr 1))
                          (iter (- aantal 1)))))
                  
                  
                  (iter aantal-keren)
                  )
                )
              )
          )
        
        (maak-monster-object te-tekenen-monsters)))

    
                          
    ;; monsters bewegen

    (define (update-pad monsters) ;; geven van het juiste pad aan de monsters, ofwel pad 1 ofwel pad 2
      (let loop (
            (ctr 0)
            )
        (if (not (eq? ctr monster-ctr))
            (begin
              (cond
                ((eq? ((vector-ref monster-vector ctr) 'pad) 1) (((vector-ref monster-vector ctr) 'pad!) pad1)
                                                                (((vector-ref monster-vector ctr) 'pad-lengte!) (- (vector-length ((vector-ref monster-vector ctr) 'pad)) 1))
                                                                )            
                ((eq? ((vector-ref monster-vector ctr) 'pad) 2) (((vector-ref monster-vector ctr) 'initial-pos!) (maak-positie 3 10))
                                                                (((vector-ref monster-vector ctr) 'pad!) pad2)
                                                                (((vector-ref monster-vector ctr) 'pad-lengte!) (- (vector-length ((vector-ref monster-vector ctr) 'pad)) 1))                                                             
                                                                )
                )
              (loop (+ ctr 1))))
      ))

    ;; procedure om monsters te bewegen
      
    (define (beweeg-monsters monsters)
      
      (define (iter-monsters aantal ctr)
        (if (< ctr aantal)
            (begin
            (if (not (eq? 0 (vector-ref monster-vector ctr)))
                (let* (
                       (monster (vector-ref monster-vector ctr))
                       (pad-ctr (monster 'pad-ctr))
                       (pad-lengte (monster 'pad-lengte))
                       (pad (monster 'pad))
                       (richting (vector-ref pad pad-ctr))
                       (timer (monster 'timer))
                       (snelheid (* (+ ctr 1) (monster 'snelheid))) ;; hun snelheid * hun plaats in de rij om te zorgen dat ze achter elkaar spawnen
                       (movement? (monster 'movement?))
                       )

                  (if movement? ;; checken als de monster aan het bewegen is, in dit geval monsters goede snelheid geven
                      (set! snelheid (monster 'snelheid))
                      )
                  
                  (if (not (eq? pad-ctr pad-lengte)) ;; als monster het einde van de pad nog niet heeft behaald
                      (if (>= timer snelheid) ;; als timer in orde, beweeg monster
                          (begin
                            ((monster 'positie!) richting)
                            ((monster 'pad-ctr!) 1)
                            (monster 'initialize-time!)
                            (monster 'movement!)
                            (iter-monsters aantal (+ ctr 1))
                      
                            )
                          (iter-monsters aantal (+ ctr 1)) ;; anders gewoon andere monsters checken
                          )
                      (begin
                        (vector-set! monster-vector ctr 0) ;; bij eeinde van pad, monster omzetten naar 0 om te wissen van spel
                        (cond ;; levens updaten
                          ((eq? (monster 'monster-type) 1) (set! levens (- levens 1)))
                          ((eq? (monster 'monster-type) 2) (set! levens (- levens 2)))
                          ((eq? (monster 'monster-type) 3) (set! levens (- levens 3)))
                          )
                        ((teken-adt 'update-leven!) levens)
                        (check-end-wave monster-vector)
                      )
                      )
                  )
                (iter-monsters aantal (+ ctr 1))
                )
            )
            (begin ;; bij einde loop, check voor dode monsters, en teken alle monsters
              (kill-monsters monster-vector)
              (beweeg-tiles monster-vector 0 monster-ctr)                  
              )
            )
        )
      ;;;;;;;;;
      
      (if (not (eq? te-bewegen-monsters monster-ctr))
          (begin
            (if start-wave?
            (iter-monsters te-bewegen-monsters 0)
            )
            (set! te-bewegen-monsters (+ te-bewegen-monsters 1))
            )
          (if start-wave?
          (iter-monsters te-bewegen-monsters 0)
          )
          )
      )
        
   
    (define (teken-monsters monsters ctr max)
      (if (not (> ctr (- max 1)))
          (let* (
                 (monster-obj (vector-ref monster-vector ctr))
                 (monster-tile (monster-obj 'tile))
                 (monster-positie (monster-obj 'positie))
                 )
                  ((teken-adt 'teken-monster) monster-tile)
                  ((teken-adt 'teken-object!) monster-obj monster-tile)
                  (teken-monsters monsters (+ ctr 1) max)
            )
          )   
      )

    (define (beweeg-tiles monsters ctr max)
      (if (not (> ctr (- max 1)))
          (if (not (eq? (vector-ref monster-vector ctr) 0))
              (let* (
                     (monster-obj (vector-ref monster-vector ctr))
                     (monster-tile (monster-obj 'tile))
                     (monster-positie (monster-obj 'positie))
                     )
                ((teken-adt 'teken-object!) monster-obj monster-tile)
                (beweeg-tiles monsters (+ ctr 1) max)
                )
              (beweeg-tiles monsters (+ ctr 1) max)
              )   
          )
      )


    (define (update-timers monsters tijd) ;; updaten timers voor monsters

  
      (define (iter ctr max)
        (if (not (eq? ctr max))
            (if (not (eq? 0 (vector-ref monsters ctr)))
                (let* (
                       (monster (vector-ref monsters ctr))
                       )
                  ((monster 'timer!) tijd)
                  (iter (+ ctr 1) max)
                  )
                (iter (+ ctr 1) max))
            )
        )
      (iter 0 monster-ctr)
      )

    (define (geef-levens) ;;extra leven voor monsters op het pad bij sterven paars monster

      (define (iter ctr max)
        (if (not (eq? ctr max))
            (if (not (eq? 0 (vector-ref monster-vector ctr)))
                (let* (
                       (monster (vector-ref monster-vector ctr))
                       (bewegend? (monster 'movement?))
                       (levens (monster 'levens))
                       )
                  (if bewegend?
                      ((monster 'levens!) (+ levens 1))
                      (iter (+ ctr 1) max)
                      )
                  (iter (+ ctr 1) max)
                  )
                (iter (+ ctr 1) max)
                )
            )
        )
      (iter 0 monster-ctr)
      
      ) 

    
    ;; code voor aanmaken torens

    (define (maak-toren-object x y type-toren) 
      (let* (
            (toren (maak-toren (make-bitmap-tile standaard-toren "images/tower_mask.png") (maak-positie x y) type-toren))
            )

       

        (if (eq? 1 (zoek-matrix x y level-map))
            (begin
              (cond
                ((eq? type-toren 3) ((toren 'tile!) (make-bitmap-tile kanon-toren toren-mask))                          
                                    ((toren 'verander-ladingstijd!) 2500)  ;; elke toren heeft zijn eigen ladings-tijd
 
                                    )

                ((eq? type-toren 4) ((toren 'tile!) (make-bitmap-tile acht-toren toren-mask))                          
                                    ((toren 'verander-ladingstijd!) 3500)
                                    )

                ((eq? type-toren 5) ((toren 'tile!) (make-bitmap-tile manueel-toren manueel-toren-mask))                          
                                    ((toren 'verander-ladingstijd!) 5000)
                                    (set! manueel-toren-pos (cons ((toren 'positie) 'x) ((toren 'positie) 'y)))
                                    )
                )
              (vector-set! toren-vector toren-ctr (cons x y)) ;; bijhouden positie van torens voor later gebruik
              (set-matrix! x y level-map toren)
              (set! toren-ctr (+ toren-ctr 1))
              ((teken-adt 'teken-toren) (toren 'tile))
              ((teken-adt 'teken-object!) toren (toren 'tile))
              )
            )
         
     ))

    (define (teken-manueel-toren-shot manueel-toren-projectiel)
      (let* (
             (projectiel-x (car manueel-toren-shot))
             (projectiel-y (cdr manueel-toren-shot))

             (toren-x (car manueel-toren-pos))
             (toren-y (cdr manueel-toren-pos))
             
             (toren (zoek-matrix toren-x toren-y level-map))
             )
        (if (and (toren 'loaded?) (eq? 0 (zoek-matrix projectiel-x projectiel-y level-map)))
            (begin
              ((teken-adt 'teken-toren) manueel-toren-projectiel)
              ((manueel-toren-projectiel 'set-x!) (* cel-breedte-px projectiel-x) )
              ((manueel-toren-projectiel 'set-y!) (* cel-hoogte-px projectiel-y) )
              (set! manueel-toren-gekozen? #f)
              )
            )
        )
      )
          
    
    (define kies-knop  ;; knoppen van het spel
      (lambda (knop status x y)
        (if (and (eq? knop 'left)
                 (eq? status 'pressed))
            (begin

              (if end-game  ;; eindknop bij win menu of game over menu
                  (if (and (> x 350) (< x 650) (> y 400) (< y 500))
                      (begin
                        (reset-level)
                        (set! levens 10)
                        (set! main-menu #f)
                        (set! end-game #f)
                        (set! game-loop #t)
                        (set! level 0)
                        (set! win #f)
                        (set! game-over #f)
                        ((level-adt 'next-level!) (+ level 1))
                        (set! level-map (level-adt 'level-map))
                        (set! pad1 (level-adt 'pad1))
                        (set! pad2 (level-adt 'pad2))
                        (load-next-level)
                        (start-game)
                        )
                      )
                  )
                  

              (if main-menu  ;; main menu startknop
                  (if (and (> x 340) (< x 650) (> y 470) (< y 550))
                      (begin
                        (set! main-menu #f)
                        (set! game-loop #t)
                        (start-game)
                        )
                      )
                  )

              (if game-loop ;; wanneer spel geladen is
                  (begin

              (if (and (not start-wave?) (eq? (zoek-matrix (floor (/ x cel-breedte-px)) (floor (/ y cel-hoogte-px)) level-map) 7)) ;; start knop voor wave te starten
                  (begin
                    (set! start-wave? #t) ;; wave starten
                    )
                  )
                
            
            (if (and manueel-toren-gekozen? (not manueel-toren-shot?)) ;; als manueel toren gekozen is en nog niet heeft geschoten
                (begin
                  (set! manueel-toren-shot (cons (floor (/ x cel-breedte-px)) (floor (/ y cel-hoogte-px))))
                  (set! manueel-toren-shot? #t)
                  (teken-manueel-toren-shot manueel-toren-projectiel)
                  
                  )
                (if (not (number? (zoek-matrix (floor (/ x cel-breedte-px)) (floor (/ y cel-hoogte-px)) level-map))) ;; als er op de manuele toren wordt geklikt
                    (if (eq? 5 ((zoek-matrix (floor (/ x cel-breedte-px)) (floor (/ y cel-hoogte-px)) level-map) 'type))
                        (set! manueel-toren-gekozen? #t)
                        )
                    
                    )
                )
                    
            
            (if toren-gekozen? 
                (begin ;; als er een toren gekocht is deze plaatsen
                (maak-toren-object (floor (/ x cel-breedte-px)) (floor (/ y cel-hoogte-px)) gekozen-toren-type)
                (set! toren-gekozen? #f)
                )
                (cond ;; als toren niet gekozen is, toren kopen en bij tweede click op spelwereld deze plaatsen
                  
                  (  (and (eq? (zoek-matrix (floor (/ x cel-breedte-px)) (floor (/ y cel-hoogte-px)) level-map) 2) (>= geld 20))
                     (set! toren-gekozen? #t)
                     (set! gekozen-toren-type 2)
                     (set! geld (- geld 20))
                     ((teken-adt 'update-geld!) geld)
                     )

                  ((and (eq? (zoek-matrix (floor (/ x cel-breedte-px)) (floor (/ y cel-hoogte-px)) level-map) 3) (>= geld 40))
                   (set! toren-gekozen? #t)
                   (set! gekozen-toren-type 3)
                   (set! geld (- geld 40))
                   ((teken-adt 'update-geld!) geld)
                   )

                  ((and (eq? (zoek-matrix (floor (/ x cel-breedte-px)) (floor (/ y cel-hoogte-px)) level-map) 4) (>= geld 80))
                   (set! toren-gekozen? #t)
                   (set! gekozen-toren-type 4)
                   (set! geld (- geld 80))
                   ((teken-adt 'update-geld!) geld)
                   )

                  ((and (not manueel-toren?)
                        (eq? (zoek-matrix (floor (/ x cel-breedte-px)) (floor (/ y cel-hoogte-px)) level-map) 5) (>= geld 120))
                   (set! toren-gekozen? #t)
                   (set! gekozen-toren-type 5)
                   (set! manueel-toren? #t)
                   (set! manueel-toren-pos (cons (floor (/ x cel-breedte-px))
                                                 (floor (/ y cel-hoogte-px)))))
                  

                  ((and (eq? (zoek-matrix (floor (/ x cel-breedte-px)) (floor (/ y cel-hoogte-px)) level-map) 6) (<= tank-timer 0))
                   (set! tank #t)
                   (set! tank-object (maak-tank (maak-positie -1 2)
                                                (make-bitmap-tile tank-tile tank-mask)
                                                pad1
                                                pad2
                                                ))
                   )
                                                                                                                    

                  )
              )
            )

            )))))

    ;; code voor shoot torens

    (define (kill-monsters monsters)

      (define (check-afstand monster monster-ctr trn-ctr) ;; checken voor als monsters in range zitten

        (define (bereken-afstand x1 y1 x2 y2)  ;; afstand berekenen
          (sqrt (+ (expt (- x2 x1) 2) (expt (- y2 y1) 2) ))
          )
  
        (if (< trn-ctr toren-ctr) ;; doorlopen torens en zien of er monsters in de buurt zitten
            (let* (
                   (positie (vector-ref toren-vector trn-ctr))
                   (toren-x (car positie))
                   (toren-y (cdr positie))
                   (toren (zoek-matrix toren-x toren-y level-map))
                   (type (toren 'type))
                   (afstand 0)

                   (monster-positie (monster 'positie))
                   (monster-x (monster-positie 'x))
                   (monster-y (monster-positie 'y))
                   
                   )
              (set! afstand (bereken-afstand monster-x monster-y toren-x toren-y))
              (cond
                ((and (eq? type 2) (<= (floor afstand) 1))  (shoot monster-ctr toren-x toren-y))
                ((and (eq? type 3) (<= (floor afstand) 2))  (shoot monster-ctr toren-x toren-y))
                ((and (eq? type 4) (<= (floor afstand) 3))  (shoot monster-ctr toren-x toren-y))
                )
              (check-afstand monster monster-ctr (+ trn-ctr 1))
              )
            )
        )
      
      
      (define (check-omgeving monster monster-ctr) ;; deze procedure gaat alle monsters doorlopen, kijken of er een manueel projectiel in de weg staat of niet
        ;; daarnaast gaat deze ook 'check-afstand' oproepen met torens om te zien of er een toren in de weg staat)
        (if (not (eq? (vector-ref monster-vector monster-ctr) 0))
            (begin
              (if (and manueel-toren-shot? (eq? ((monster 'positie) 'x) (car manueel-toren-shot)) (eq? ((monster 'positie) 'y) (cdr manueel-toren-shot)))
                  (begin
                    (shoot monster-ctr (car manueel-toren-pos) (cdr manueel-toren-pos))
                    (set! manueel-toren-shot? #f)
                    ((teken-adt 'verwijder-toren!) manueel-toren-projectiel)
                  )
                  )
              (check-afstand monster monster-ctr 0)                                    
              )
            )
        )

      
      (define (shoot ctr x y) ;; shooting procedure
        (let* (
              (toren (zoek-matrix x y level-map))
              (loaded? (toren 'loaded?))
              (monster (vector-ref monster-vector ctr))
              )
          (if loaded? ;; als toren die op afstand is geladen is, dan schieten en leven aftrekken van monster dankzij 'dood! procedure
              (begin
                ((monster 'dood!) (toren 'type))
                (if (monster 'dood?)
                    (begin

                      (cond
                        
                        ((eq? 3 (monster 'monster-type)) (geef-levens)
                                                         (set! geld (+ geld 15))
                                                         ((teken-adt 'update-geld!) geld)
                                                         )
                        )
                      
                    
                      ((teken-adt 'verwijder-monster!) (monster 'tile))
                      ((monster 'tile!) (make-bitmap-tile dood-monster monster-mask))               
                      ((teken-adt 'teken-monster) (monster 'tile))
                      ((teken-adt 'teken-object!) monster (monster 'tile))
                      )
                    )

                ;; hier wordt de tile van een toren omgezet naar een toren dat schiet
                ((teken-adt 'verwijder-toren!) (toren 'tile))
                (cond
                  ((eq? (toren 'type) 2) ((toren 'tile!) (make-bitmap-tile standaard-toren-shoot toren-shoot-mask)))
                  ((eq? (toren 'type) 3) ((toren 'tile!) (make-bitmap-tile kanon-toren-shoot toren-shoot-mask)))
                  ((eq? (toren 'type) 4) ((toren 'tile!) (make-bitmap-tile acht-toren-shoot acht-toren-shoot-mask)))
                  )
                
                ((teken-adt 'teken-toren) (toren 'tile)) 
                ((teken-adt 'teken-object!) toren (toren 'tile))
                (if (not (eq? (toren 'type) 4))
                    (toren 'initialize-tijd!)
                    )
                (toren 'geschoten!) ;; aanduiden dat toren heeft geschoten om beginnen met ladigstijd
                )
              )
          )
        )


      (define (check-acht-torens ctr) ;; check voor toren die acht kogels schiet
        (if (not (eq? ctr toren-ctr))
            (begin
              (let* (
                     (positie (vector-ref toren-vector ctr))
                     (x (car positie))
                     (y (cdr positie))
                     (toren (zoek-matrix x y level-map))
                     (type (toren 'type))
                     )

                (if (and (eq? type 4) (toren 'geschoten?))
                    (begin
                      (toren 'geschoten!)
                      (toren 'initialize-tijd!)
                      (check-acht-torens (+ ctr 1))
                      )
                    (check-acht-torens (+ ctr 1))
                    )
                )
              )
            )
        )
      

      (define (iter ctr)
        (if (not (eq? ctr monster-ctr))
            (let* (
                   (monster (vector-ref monster-vector ctr))
                   )
              (check-omgeving monster ctr)
              (iter (+ ctr 1))
              )
            )
        (check-acht-torens 0)
        )
      (iter 0)                
      )


    (define (update-shooting-tijd! timer) ;; updaten van alle timers van alle torens
      
      (define (iter ctr max)
        (if (not (eq? ctr max))
            (begin
              (let* (
                     (positie (vector-ref toren-vector ctr))
                     (x (car positie))
                     (y (cdr positie))
                     (toren (zoek-matrix x y level-map))
                     )

                ((toren 'ladings-tijd!) timer)
                
                (if (eq? (toren 'type) 5)
                    (if (not (toren 'loaded?))
                        ((teken-adt 'update-manueel-timer!) (ceiling (/ (- (toren 'ladings-tijd) (toren 'timer)) 1000)))
                        ((teken-adt 'update-manueel-timer!) 0)
                        )
                    )
                
                (iter (+ ctr 1) max)
                
                )
              )
            )
        )
     
      (iter 0 toren-ctr)               
      )

    (define (after-shoot monsters torens monster-ctr toren-ctr) ;; nadat er geschoten wordt, checken voor dode monsters, geld en monster-tiles
      (define (iter ctr max)
        (if (not (eq? ctr max))
            (if (not (eq? 0 (vector-ref monsters ctr)))
                (begin
                  (let* (
                         (monster (vector-ref monsters ctr))
                         (dood? (monster 'dood?))
                         )
                    (if dood?
                        (begin
                          (cond
                            ((eq? 1 (monster 'monster-type))
                             (set! geld (+ geld 5))
                             ((teken-adt 'update-geld!) geld)
                             )
                        
                            ((eq? 2 (monster 'monster-type))
                             (set! geld (+ geld 10))
                             ((teken-adt 'update-geld!) geld)
                             )
                        
                            ((eq? 3 (monster 'monster-type))
                             (set! geld (+ geld 15))
                             ((teken-adt 'update-geld!) geld)
                             )
                            )
  
                          ((teken-adt 'verwijder-monster!) (monster 'tile))
                          (vector-set! monsters ctr 0)
                          (check-end-wave monster-vector)
     
                          ))
                    (iter (+ ctr 1) max)
                    )
                  )
                (iter (+ ctr 1) max)
                ))
        )

      (define (iter-tiles ctr max)
        (if (not (eq? ctr max))
            (begin
              (let* (
                     (positie (vector-ref torens ctr))
                     (x (car positie))
                     (y (cdr positie))
                     (toren (zoek-matrix x y level-map))
                     )
                (if (not (number? toren))
                    (begin
                      ((teken-adt 'verwijder-toren!) (toren 'tile))  ;;; tiles terug normaal zetten van torens
                      (cond
                        ((eq? (toren 'type) 2) ((toren 'tile!) (make-bitmap-tile standaard-toren toren-mask)))
                        ((eq? (toren 'type) 3) ((toren 'tile!) (make-bitmap-tile kanon-toren toren-mask)))
                        ((eq? (toren 'type) 4) ((toren 'tile!) (make-bitmap-tile acht-toren toren-mask))
                                         
                                               )
                        )
                      ((teken-adt 'teken-toren) (toren 'tile))
                      ((teken-adt 'teken-object!) toren (toren 'tile))
                      (iter-tiles (+ ctr 1) max)
                      )
                    (iter-tiles (+ ctr 1) max)
                    )

              )
            )
        )
        )
      
      (iter 0 monster-ctr)
      (iter-tiles 0 toren-ctr)
      )

    ;; powerups

    (define (load-tank delta-tijd)  ;; tank procedure

      (define (check-monsters-tank)
        
        (define (iter ctr max)  ;; lopen over pad van tank, deze laten bewegen op een bepaald snelheid en checken voor als er werd gereden op een monster
          (if (< ctr max)
              (if (not (eq? 0 (vector-ref monster-vector ctr)))
                  (let* (
                         (monster (vector-ref monster-vector ctr))
                         (monster-x ((monster 'positie) 'x))
                         (monster-y ((monster 'positie) 'y))
                         (tank-x ((tank-object 'positie) 'x))
                         (tank-y ((tank-object 'positie) 'y))
                         )
                    (if (and (eq? tank-x monster-x) (eq? tank-y monster-y))
                        (begin
                          (monster 'tank!)
                          ((teken-adt 'verwijder-monster!) (monster 'tile))
                          ((monster 'tile!) (make-bitmap-tile dood-monster "images/monster_mask.png"))               
                          ((teken-adt 'teken-monster) (monster 'tile))
                          ((teken-adt 'teken-object!) monster (monster 'tile))
                          )
                        (iter (+ ctr 1) max)
                    )
                    )
                  (iter (+ ctr 1) max)
                  )
              )
          )
        (iter 0 te-bewegen-monsters)
        (set! tank-timer 10000)
        )
        

      (if (< (tank-object 'pad-ctr) (tank-object 'pad-lengte)) ;; als tank niet einde van pad heeft behaald

          (let* (
                 (positie (tank-object 'positie))
                 (x (positie 'x))
                 (y (positie 'y))
                 (tank-tile (tank-object 'tile))
                 (timer (tank-object 'timer))
                 (snelheid (tank-object 'snelheid))
                 (pad-ctr (tank-object 'pad-ctr))
                 (pad-lengte (tank-object 'pad-lengte))
                 (pad (tank-object 'pad))
                 (richting (vector-ref pad pad-ctr))
                 )
       
            (if (>= timer snelheid) ;; als tank mag bewegen, deze bewegen
                (begin
                  ((tank-object 'positie!) richting)
                  ((tank-object 'pad-ctr!) 1)
                  (tank-object 'initialize-time!)
                  (check-monsters-tank)
                  ((teken-adt 'teken-toren) tank-tile)
                  ((teken-adt 'teken-object!) tank-object tank-tile)
                  )
                (begin
                ((tank-object 'timer!) delta-tijd) ;; anders timer updaten
                )
                )
            )
          (if (not (eq? (tank-object 'pad-lengte) (vector-length pad2)))
                (tank-object 'next-pad!)
                (set! tank #f)
                )
          )                                                   
      )


         


    ;; gameloop

    (define (boot delta-tijd) ;; gameloop

      (if (<= levens 0)  ;; checken voor leven
          (begin
            (set! game-loop #f)
            (set! start-wave? #f)
            (set! game-over #t)
            )
          )

      (if win  ;; check win
          (begin
            (set! end-game #t)
            (teken-adt 'verwijder-alle-torens!)
            (teken-adt 'verwijder-alle-monsters!)
            (teken-adt 'verwijder-alle-elementen!)
            (teken-adt 'teken-win-menu)
            )
          )

      (if game-over ;; check game-over
          (begin
            (set! game-loop #f)
            (set! end-game #t)
            (teken-adt 'verwijder-alle-torens!)
            (teken-adt 'verwijder-alle-monsters!)
            (teken-adt 'verwijder-alle-elementen!)
            (teken-adt 'teken-go-menu)
            )
          )
      
      (if tank
          (load-tank delta-tijd)
          )
      
      (if game-loop
          (begin
            (set! timer (+ timer delta-tijd)) ;; speltimer update
            (update-shooting-tijd! delta-tijd) ;; updaten torens voor hun ladingstijd

            (if next-level-ctr ;; als nieuwe level moet geladen worden, level lading tijd updaten
                               ;; (zodat monsters niet direct spawnen wanneer je je wave start of level start)
                (set! next-level-timer (+ next-level-timer delta-tijd))
                )

            (if (> next-level-timer 1500)  ;; als level "geladen"
                (begin
                  (maak-monsters)
                  (update-pad monster-vector)
                  (teken-monsters monster-vector 0 monster-ctr)
                  (set! next-level-ctr #f)
                  (set! next-level-timer 0)
                  )
                )

            (if next-wave-ctr ;; zelfde idee met wave als voor level
                (set! next-wave-timer (+ next-wave-timer delta-tijd))
                )

            (if (> next-wave-timer 1000)
                (begin
                  (maak-monsters)
                  (update-pad monster-vector)
                  (teken-monsters monster-vector 0 monster-ctr)
                  (set! next-wave-ctr #f)
                  (set! next-wave-timer 0)
                  )
                )

            (if (>= tank-timer 0) ;; als tank cooldown gedaan is
                (begin
                  (set! tank-timer (- tank-timer delta-tijd))
                  ((teken-adt 'update-tank-timer!) (ceiling (/ tank-timer 1000)))
                  )
                ((teken-adt 'update-tank-timer!) 0)
                )

     
            (if (> timer 600) ;; gewoon voor animatie van torens en monsters bij het schooten en sterven, dat je dan terug je tiles initialiseert
                (begin
                  (after-shoot monster-vector toren-vector monster-ctr toren-ctr)
                  (set! timer 0)
                  )
                )
      
            (update-timers monster-vector delta-tijd) ;; timers voor monsters updaten en monsters bewegen 
            (beweeg-monsters monster-vector)
            )
          )
      )
                                      
    (define (start) ;; bij starten van spel, enkel knoppen voor main menu
      ((teken-adt 'set-click-functie!) kies-knop)
      )

    (define (start-game) ;; spel starten => alles tekenen en alles initialiseren
      (newline)
      ((teken-adt 'teken-background!) 1)
      (teken-adt 'draw-all-elements)
      ((teken-adt 'update-level!) (+ level 1))
      ((teken-adt 'update-tank-timer!) (ceiling (/ tank-timer 1000)))
      ((teken-adt 'update-leven!) levens)
      ((teken-adt 'update-geld!) geld)
      (maak-monsters)
      (update-pad monster-vector)
      (teken-monsters monster-vector 0 monster-ctr)
      ((teken-adt 'set-spel-lus-functie!) boot)
      )
      
              
          
    (define (dispatch msg)
      (cond
       ((eq? msg 'start) (start))))
    
    dispatch))
         