(import jaylib :as j)
(use ./utils)
(use ./assets)


(defn run-game [assets] 
  (def tm (assets :tilemap))
  (def grid (assets :cell-grid))
  (prin "1")
  (var t (j/get-time))
  (while (not (j/window-should-close))
    (def t1 (j/get-time))
    (def dt (- t t1))
    (set t t1)
    (j/begin-drawing)
    (j/clear-background [0 0 0])
    # (draw-named-tile tm :railroad-vert [0 0 32 32])
    (draw-named-tile tm :railroad-horiz (place-tile grid 1 1))
    (draw-named-tile tm :railroad-down-left (place-tile grid 2 1))
    (draw-named-tile tm :railroad-vert (place-tile grid 2 2))
    (draw-named-tile tm :railroad-vert (place-tile grid 2 3))
    (draw-named-tile tm :railroad-vert (place-tile grid 2 4))
    (j/end-drawing))
  (j/close-window))

(defn main [& args]
  (j/init-window 800 600 "Treats on a Healthy green railroad")
  (j/set-target-fps 60)
  (j/hide-cursor)
  (def assets (load-assets)) 
  (prin ".")
  (run-game assets))

