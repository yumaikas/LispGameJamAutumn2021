(import jaylib :as j)
(use ./utils)
(use ./assets)
(use ./tilemap)


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

  # (def grid (assets :cell-grid))
  (var t (j/get-time))
  (while (not (j/window-should-close))
    (def t1 (j/get-time))
    (def dt (- t t1))
    (set t t1)

    (when (j/mouse-button-pressed? :left)
      (pp "YO!")
      (def [mx my] (j/get-mouse-position))
      (:click tilemap mx my))

    (j/begin-drawing)
    (j/clear-background [0 0 0])
    (:render tilemap)
    (j/end-drawing))

  (j/close-window))

(defn main [& args]
  (j/init-window 800 600 "Treats on a Healthy green railroad")
  (j/set-target-fps 60)
  (j/hide-cursor)
  (def assets (load-assets)) 
  (run-game assets))

