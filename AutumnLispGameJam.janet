(import jaylib :as j)
(use ./utils)
(use ./assets)
(use ./tilemap)
(use ./player)


(defn run-game [assets] 
  (math/seedrandom (os/time))
  (def player (init-player assets 20 20))
  (def tileset (assets :tileset))
  (def tilemap 
    (init-tilemap 
      tileset (table ;(seq [x :in (range 0 37)
                           y :in (range 0 24)
                           phase :in [:key :value]] 
                        (match phase
                          :key [x y]
                          :value (or (> 0.24 (math/random)) nil))))))
  (:set-point tilemap 0 0)
  (:light-point tilemap 0 0)

  (def cursor (assets :cursor))

  # (def grid (assets :cell-grid))
  (var t (j/get-time))
  (while (not (j/window-should-close))
    (def t1 (j/get-time))
    (def dt (- t1 t))
    (set t t1)

    (def mpos (j/get-mouse-position))
    (def [mx my] mpos)
    (def dist (distance (player :position) mpos))

    (when (j/mouse-button-pressed? :left)
      # The tilemap needs to know if it's going to delete
      # from under the player or not
      (:click tilemap player mx my))
    (:update player dt tilemap)

    (j/begin-drawing)
    (j/clear-background [0 0 0])
    (:draw tilemap mpos (< dist 100))
    (:draw player)
    (:draw cursor mx my)
    (j/draw-text 
      (string (:unlit-remain tilemap) " Unlit rails remain")
      5 (- 800 32) 32 [1 1 1])
    #(j/draw-fps 0 0)
    (j/end-drawing))
  (j/close-window))

(defn main [& args]
  (j/init-window 1200 800 "Spark works")
  (j/set-target-fps 60)
  (j/hide-cursor)
  (def assets (load-assets)) 
  (run-game assets))

