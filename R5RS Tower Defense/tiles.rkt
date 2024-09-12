(#%require "graphics.rkt")


; menu tiles
(define start-menu (make-bitmap-tile "images/start-menu.png"))
(define win-menu (make-bitmap-tile "images/win-menu.png"))
(define go-menu (make-bitmap-tile "images/game-over-menu.png"))

;;level achtergronden
(define background-level1-tile (make-bitmap-tile "images/background.png"))
(define background-level2-tile (make-bitmap-tile "images/background-level2.png"))
(define background-level3-tile (make-bitmap-tile "images/background-level3.png"))


;; monster tiles
(define rood-monster "images/monster_rood.png")
(define paars-monster "images/monster_paars.png")
(define blauw-monster "images/monster_blauw.png")
(define dood-monster "images/monster_dood.png")
(define monster-mask "images/monster_mask.png")


;; torens
(define toren-mask "images/tower_mask.png")
(define toren-shoot-mask "images/tower_fire_mask.png")

(define standaard-toren "images/toren_standaard.png")
(define standaard-toren-shoot "images/toren_standaard_fire.png")

(define kanon-toren "images/toren_kanon.png")
(define kanon-toren-shoot "images/toren_kanon_fire.png")

(define acht-toren "images/toren_acht.png")


(define acht-toren-shoot "images/toren_acht_fire.png")
(define acht-toren-shoot-mask "images/toren_acht_fire_mask.png")



(define manueel-toren "images/toren_manueel.png")
(define manueel-toren-mask "images/toren_manueel_mask.png")

(define manueel-toren-shoot "images/toren_manueel_fire.png")
(define manueel-toren-shoot-mask "images/toren_manueel_fire_mask.png")

(define manueel-toren-projectiel (make-bitmap-tile "images/bom.png" "images/bom_mask.png"))


;; tank power-up
(define tank-tile "images/tank.png")
(define tank-mask "images/tank_mask.png")


