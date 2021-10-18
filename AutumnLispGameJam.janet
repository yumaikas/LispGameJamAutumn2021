(import jaylib :as j)
(use ./utils)
(use ./assets)
(use ./tilemap)
(use ./player)


(defn run-game [assets] 

  (def tileset (assets :tileset))
  (def tilemap 
    (init-tilemap 
      tileset 
      @{
        [0 0] true
        [0 1] true
        [1 0] true
        [1 1] true
        [2 1] true
        [2 2] true
        [2 3] true
        [2 4] true
        [2 5] true
        [3 5] true
        [4 5] true
        }))
  (def player (init-player assets 20 20))
  (def cursor (assets :cursor))

  # (def grid (assets :cell-grid))
  (var t (j/get-time))
  (while (not (j/window-should-close))
    (def t1 (j/get-time))
    (def dt (- t1 t))
    (set t t1)

    (def [mx my] (j/get-mouse-position))
    (when (j/mouse-button-pressed? :left)
      (:click tilemap mx my))
    (:update player dt)

    (j/begin-drawing)
    (j/clear-background [0 0 0])
    (:draw tilemap)
    (:draw player)
    (:draw cursor mx my)

    (j/end-drawing))

  (j/close-window))

(defn main [& args]
  (j/init-window 1200 800 "Seaweed Salad")
  (j/set-target-fps 60)
  (j/hide-cursor)
  (def assets (load-assets)) 
  (run-game assets))

