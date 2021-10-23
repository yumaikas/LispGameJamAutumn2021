(use ./utils)
(use ./assets)
(use ./tilemap)
(use ./player)

(import jaylib :as j)
# (import ./pause-menu)
(import ./menu)
(import ./button)

(defn update-level [state dt switch-state]
  (def 
    {:state 
     {:player player 
      :pause-menu pause-menu
      :restart-menu restart-menu
      :tilemap tilemap}}
    state)

  (def mpos (j/get-mouse-position))
  (def [mx my] mpos)

  (def unlit-remain (:unlit-remain tilemap))
  (def restart-available (= 0 unlit-remain))

  (:update pause-menu dt switch-state)

  (def paused (pause-menu :shown))
  (when restart-available
    (put restart-menu :shown true)
    (:update restart-menu dt switch-state))

  (unless paused
    (when (j/mouse-button-pressed? :left)
      (:click tilemap player mx my))
    (:update player dt tilemap)))

(defn draw-level [state]
  (def {:state 
        {:player player 
         :tilemap tilemap 
         :cursor cursor
         :restart-menu restart-menu
         :pause-menu pause-menu }} state)

  (def mpos (j/get-mouse-position))
  (def [mx my] mpos)
  (def dist (distance (player :position) mpos))
  (j/clear-background [0 0 0])

  (def unlit-remain (:unlit-remain tilemap))
  (def restart-available (= 0 unlit-remain))

  (when (not restart-available)
    (:draw tilemap mpos (>= 100 dist))
    (:draw player)
    (j/draw-text (string (:unlit-remain tilemap) " Unlit rails remain")
                 5 (- 800 32) 32 [1 1 1]))
  
  (when restart-available
    (:draw restart-menu))
  (:draw cursor mx my)
  (def paused (pause-menu :shown))
  (when paused (:draw pause-menu))
  )

(defn init [assets] 
  (def tilemap 
    (init-tilemap 
      (assets :tileset) (table ;(seq [x :in (range 0 5) # 37
                           y :in (range 0 5) # 24
                           phase :in [:key :value]] 
                        (match phase
                          :key [x y]
                          :value (or (> 0.24 (math/random)) nil))))))
  (:set-point tilemap 0 0)
  (:light-point tilemap 0 0)

  (def cursor (assets :cursor))
  (def start-menu/init (assets :start-menu/init))
  (def pause-menu 
    (menu/init assets [
       (button/init "Resume game" [80 160] 80 [1 1 1] 
                    (fn [menu switch] 
                      (put menu :shown false)))
       (button/init "Back to Menu" [80 240] 80 [1 1 1] 
                    (fn [menu switch] (switch  (start-menu/init assets))))]
               {:toggle-key :p}
               ))
  (def restart-menu
    (menu/init 
      assets
      [
       (button/init "Play again!" [80 160] 80 [1 1 1]
                    (fn [menu switch] (switch (init assets))))
       (button/init "Go to Menu" [80 240] 80 [1 1 1]
                    (fn [menu switch] (switch (start-menu/init assets))))])) 


  {:state
   @{:player (init-player assets 20 20)
     :cursor cursor
     :pause-menu pause-menu
     :restart-menu  restart-menu
     :tilemap tilemap }
   :update update-level
   :draw draw-level })
