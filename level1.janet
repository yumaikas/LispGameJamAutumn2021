(use ./utils)
(use ./assets)
(use ./tilemap)
(use ./player)
(import jaylib :as j)


(defn update-level [state dt switch-state]
  (def {:state { :player player :tilemap tilemap}} state)

  (def mpos (j/get-mouse-position))
  (def [mx my] mpos)

  (def unilt-remain (:unlit-remain tilemap))
  (def restart-available (= 0 unlit-remain))

  (when (j/mouse-button-pressed? :left)
    (:click tilemap player mx my))
  (:update player dt tilemap))

(defn draw-level [state]
  (def {:state { :player player :tilemap tilemap :cursor cursor} } state)

  (def mpos (j/get-mouse-position))
  (def [mx my] mpos)
  (def dist (distance (player :position) mpos))
  (j/clear-background [0 0 0])

  (def unilt-remain (:unlit-remain tilemap))
  (def restart-available (= 0 unlit-remain))
  (when (not restart-available)
    (:draw tilemap mpos (>= 100 dist))
    (:draw player)
    (:draw cursor mx my)
    (j/draw-text (string (:unlit-remain tilemap) " Unlit rails remain")
                 5 (- 800 32) 32 [1 1 1])
    )

  )

(defn init [assets] 
  (def tilemap 
    (init-tilemap 
      (assets :tileset) (table ;(seq [x :in (range 0 37)
                           y :in (range 0 24)
                           phase :in [:key :value]] 
                        (match phase
                          :key [x y]
                          :value (or (> 0.24 (math/random)) nil))))))
  (:set-point tilemap 0 0)
  (:light-point tilemap 0 0)

  (def cursor (assets :cursor))

  {:state
   @{:player (init-player assets 20 20)
     :cursor cursor
     :tilemap tilemap }
   :update update-level
   :draw draw-level })
