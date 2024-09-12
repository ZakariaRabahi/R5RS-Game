(define (maak-tekening pixels-horizontaal pixels-verticaal)
  (let ((venster (make-window pixels-horizontaal pixels-verticaal "tower defense")))

;;;;;;;;;;;; code voor het aanmaken van layers en tiles ;;;;;;;;;;;;
    
    ; achtergrond en alle lagen
    (define background-laag ((venster 'new-layer!)))
    (define monster-laag ((venster 'new-layer!)))
    (define toren-laag ((venster 'new-layer!)))
    (define background-tile start-menu)
    ((background-laag 'add-drawable!) background-tile)


     ;; tekenen van win en game-over menu
    (define (teken-win-menu)
      (remove-background!)
      (set! background-tile win-menu)
      ((background-laag 'add-drawable!) background-tile)
      )

    
    (define (teken-go-menu)
      (remove-background!)
      (set! background-tile go-menu)
      ((background-laag 'add-drawable!) background-tile)
      )
      
   
    
    ;((background-laag 'add-drawable!) background-tile)

    (define (remove-background!)
      ((background-laag 'remove-drawable!) background-tile)
      )

    ;; tekenen van nieuwe levels
    (define (teken-background! lvl)
      (cond
        
        ((eq? lvl 1) (remove-background!)
                     (set! background-tile background-level1-tile)
                     ((background-laag 'add-drawable!) background-tile)
                     )

        ((eq? lvl 2) (remove-background!)
                     (set! background-tile background-level2-tile)
                     ((background-laag 'add-drawable!) background-tile)
                     )

        ((eq? lvl 3) (remove-background!)
                     (set! background-tile background-level3-tile)
                     ((background-laag 'add-drawable!) background-tile)
                     )

        
        )
      )
    

    ; monsters

    
    (define (teken-monster tile)
      ((monster-laag 'add-drawable!) tile))

    (define (verwijder-monster! tile)
      ((monster-laag 'remove-drawable!) tile)
      )

    (define verwijder-alle-monsters!
      (monster-laag 'empty!))
      


    ; torens
    
    (define (teken-toren tile)
      ((toren-laag 'add-drawable!) tile))

    (define (verwijder-toren! tile)
      ((toren-laag 'remove-drawable!) tile)
      )

    (define verwijder-alle-torens!
      (toren-laag 'empty!)
      )


    ;; ellementen-laag voor timer, levels-tile, geld, ...

    (define elementen-laag ((venster 'new-layer!)))
    (define levels-tile (make-tile cel-breedte-px cel-hoogte-px))
    (define wave-tile (make-tile cel-breedte-px cel-hoogte-px))
    (define geld-tile (make-tile cel-breedte-px cel-hoogte-px))
    (define leven-tile (make-tile cel-breedte-px cel-hoogte-px))
    (define timer-tile (make-tile cel-breedte-px cel-hoogte-px))
    (define manueel-tile (make-tile cel-breedte-px cel-hoogte-px))


    ;; bij updaten level en wave, getallen van level, wave, geld, timers, ... updaten

    (define (update-level! level)
      ((elementen-laag 'remove-drawable!) levels-tile)
      
      (set! levels-tile (make-tile cel-breedte-px cel-hoogte-px))
      ((elementen-laag 'add-drawable!) levels-tile)
      ((levels-tile 'set-x!) (* cel-breedte-px 15))
      ((levels-tile 'set-y!) 0)
      ((levels-tile 'draw-text!) (number->string level) 14 5 0 "white")
      )

    (define (update-wave! wave)
      ((elementen-laag 'remove-drawable!) wave-tile)
      (set! wave-tile (make-tile cel-breedte-px cel-hoogte-px))
      ((elementen-laag 'add-drawable!) wave-tile)
      ((wave-tile 'set-x!) (* cel-breedte-px 14))
      ((wave-tile 'set-y!) 0)
      ((wave-tile 'draw-text!) (number->string wave) 14 55 28 "white")
      )


    (define (update-geld! geld)
      ((elementen-laag 'remove-drawable!) geld-tile)
      (set! geld-tile (make-tile cel-breedte-px cel-hoogte-px))
      ((elementen-laag 'add-drawable!) geld-tile)
      ((geld-tile 'set-x!) (* cel-breedte-px 14))
      ((geld-tile 'set-y!) (* cel-hoogte-px 9))
      ((geld-tile 'draw-text!) (number->string geld) 14 24 20 "white")
      )


    (define (update-leven! leven)
      ((elementen-laag 'remove-drawable!) leven-tile)
      (set! leven-tile (make-tile cel-breedte-px cel-hoogte-px))
      ((elementen-laag 'add-drawable!) leven-tile)
      ((leven-tile 'set-x!) (* cel-breedte-px 14))
      ((leven-tile 'set-y!) (* cel-hoogte-px 8))
      ((leven-tile 'draw-text!) (number->string leven) 14 18 27 "white")
      )

    ;;;;

    (define (draw-all-elements)  ;; procedure dat alles tekent in het begin van onze spel
      (verwijder-alle-elementen!)
      ((elementen-laag 'add-drawable!) levels-tile)
      ((levels-tile 'set-x!) (* cel-breedte-px 15))
      ((levels-tile 'set-y!) 0)
      ((levels-tile 'draw-text!) "1" 14 5 0 "white")
      ((elementen-laag 'add-drawable!) wave-tile)
      ((wave-tile 'set-x!) (* cel-breedte-px 14))
      ((wave-tile 'set-y!) 0)
      ((wave-tile 'draw-text!) "1" 14 55 28 "white")

      ((elementen-laag 'add-drawable!) geld-tile)
      ((geld-tile 'set-x!) (* cel-breedte-px 14))
      ((geld-tile 'set-y!) (* cel-hoogte-px 9))
      ((geld-tile 'draw-text!) "40" 14 24 20 "white")

      ((elementen-laag 'add-drawable!) leven-tile)
      ((leven-tile 'set-x!) (* cel-breedte-px 14))
      ((leven-tile 'set-y!) (* cel-hoogte-px 8))
      ((leven-tile 'draw-text!) "10" 14 18 27 "white")

      ((elementen-laag 'add-drawable!) timer-tile)
      ((timer-tile 'set-x!) (* cel-breedte-px 15))
      ((timer-tile 'set-y!) (* cel-hoogte-px 7))
      ((timer-tile 'draw-text!) "10" 14 18 27 "white")
    

      ((elementen-laag 'add-drawable!) manueel-tile)
      ((manueel-tile 'set-x!) (* cel-breedte-px 15))
      ((manueel-tile 'set-y!) (* cel-hoogte-px 5.5))
      ((manueel-tile 'draw-text!) "10" 14 18 15 "white")
      )

    (define verwijder-alle-elementen!  ;;; leeg-maken van alle elementen
      (elementen-laag 'empty!)
      )

    ;; toren timer

    (define (update-manueel-timer! timer)
      ((elementen-laag 'remove-drawable!) manueel-tile)
      (set! manueel-tile (make-tile cel-breedte-px cel-hoogte-px))
      ((elementen-laag 'add-drawable!) manueel-tile)
      ((manueel-tile 'set-x!) (* cel-breedte-px 15))
      ((manueel-tile 'set-y!) (* cel-hoogte-px 5.5))
      ((manueel-tile 'draw-text!) (number->string timer) 14 18 15 "white")
      )



    ;; tank timer

    (define (update-tank-timer! timer)
      ((elementen-laag 'remove-drawable!) timer-tile)
      (set! timer-tile (make-tile cel-breedte-px cel-hoogte-px))
      ((elementen-laag 'add-drawable!) timer-tile)
      ((timer-tile 'set-x!) (* cel-breedte-px 15))
      ((timer-tile 'set-y!) (* cel-hoogte-px 7))
      ((timer-tile 'draw-text!) (number->string timer) 14 18 27 "white")
      )



    
    ; teken-object-functie
      (define (teken-object! obj tile)
      (let* ((obj-x ((obj 'positie) 'x))
             (obj-y ((obj 'positie) 'y))
             (screen-x (* cel-breedte-px obj-x))
             (screen-y (* cel-hoogte-px obj-y)))
        ((tile 'set-x!) screen-x)
        ((tile 'set-y!) screen-y)))
    
    ;; game-loop
    ;; set-spel-lus-functie! :: (number -> /) -> /
    (define (set-spel-lus-functie! fun)
      ((venster 'set-update-callback!) fun))
    
    ;; set-toets-functie! :: (symbol, any -> /) -> /
    (define (set-toets-functie! fun)
      ((venster 'set-key-callback!) fun))

    ;; set-volg-functie

    (define (set-volg-functie! fun)
      ((venster 'set-mouse-move-callback!) fun))

    ;; set-click-functie! :: (number, number -> /) -> /
    (define (set-click-functie! fun)
      ((venster 'set-mouse-click-callback!) fun))

       

    (define (dispatch-tekening msg)
      (cond

        ; game loop functies
        ((eq? msg 'set-spel-lus-functie!) set-spel-lus-functie!)
        ((eq? msg 'set-toets-functie!) set-toets-functie!)
        ((eq? msg 'set-click-functie!) set-click-functie!)
        ((eq? msg 'set-volg-functie!) set-volg-functie!)

        ; teken elementen
        ((eq? msg 'teken-monster) teken-monster)
        ((eq? msg 'teken-toren) teken-toren)
        ((eq? msg 'draw-all-elements) (draw-all-elements))

        ;update teken elementen
        ((eq? msg 'teken-object!) teken-object!)
        ((eq? msg 'verwijder-monster!) verwijder-monster!)
        ((eq? msg 'verwijder-alle-monsters!) (verwijder-alle-monsters!))
        ((eq? msg 'verwijder-toren!) verwijder-toren!)
        ((eq? msg 'update-level!) update-level!)
        ((eq? msg 'update-wave!) update-wave!)
        ((eq? msg 'update-geld!) update-geld!)
        ((eq? msg 'update-leven!) update-leven!)
        ((eq? msg 'update-tank-timer!) update-tank-timer!)
        ((eq? msg 'update-manueel-timer!) update-manueel-timer!)
        ((eq? msg 'verwijder-alle-torens!) (verwijder-alle-torens!))
        ((eq? msg 'remove-background!) (remove-background!))
        ((eq? msg 'teken-background!) teken-background!)
        ((eq? msg 'teken-win-menu) (teken-win-menu))
        ((eq? msg 'teken-go-menu) (teken-go-menu))
        ((eq? msg 'verwijder-alle-elementen!) (verwijder-alle-elementen!))
        ))
        


    dispatch-tekening))