(use ./utils)
(import jaylib :as j)
(import ./level1)

(defn- hover-rect [entry] 
  (def [text [x y h] color] entry)
  (def text-width (j/measure-text text h))
  [ x y (+ text-width 10) h])

(defn- update-menu-entry [entry [mx my]]
  (def [text [x y h] color state] entry)
  (def hovered (j/check-collision-recs [mx my 1 1] (hover-rect entry)))
  (put entry 3 hovered)
  (and (j/mouse-button-pressed? :left) hovered))

(defn- draw-menu-entry [entry] 
  (def [text [x y h] color hovered] entry)
  (def text-width (j/measure-text text h))

  (j/draw-text text (+ x 10) (+ y 4) (- h 3) color)
  (when hovered
    (j/draw-rectangle-lines ;(hover-rect entry) color))
  )

(defn- menu-entry-callback [entry]
  (def [_ _ _ _ callback] entry)
  callback)

(defn- update-menu [state dt switch-state]
  (def mpos (j/get-mouse-position))

  (def {:state {:new-game new-game :menu-entries menu }} state)
  (each entry menu
    (def clicked? (update-menu-entry entry mpos))
    (when clicked?
      ((menu-entry-callback entry) state switch-state))))

(defn- draw-menu [{:state state :cursor cursor}]
  (j/clear-background [0 0 0])
  (def [mx my] (j/get-mouse-position))
  (def {:new-game new-game } state)
  (each entry (state :menu-entries) 
    (draw-menu-entry entry))
  (:draw cursor mx my))

(defn start-game [state switch]
  (switch (level1/init (state :assets))))

(defn exit-game [&]
  (j/close-window))

(defn init [assets]
  {:update update-menu
   :draw draw-menu
   :cursor (assets :cursor)
   :assets assets
   :state {
           :menu-entries [
           @["Start Game" [40 40 80] [1 1 1] false start-game]
           @["Exit" [40 120 80] [1 1 1] false exit-game] 
           ]
           }
   })
