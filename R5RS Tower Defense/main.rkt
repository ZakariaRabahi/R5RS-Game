(#%require (only racket random))
(#%require "graphics.rkt")

(load "spel-adt.rkt")
(load "teken-adt.rkt")
(load "monster-adt.rkt")
(load "toren-adt.rkt")
(load "positie-adt.rkt")
(load "constanten.rkt")
(load "level-adt.rkt")
(load "tiles.rkt")
(load "tank-powerup.rkt")

((maak-spel) 'start)