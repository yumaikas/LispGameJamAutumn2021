(import jaylib :as j)
(use ./utils)
(use ./assets)
(use ./tilemap)
(use ./player)
(import ./level1)
(import ./start-menu)

(var- state nil)

(defn switch-state [new-state] (set state new-state))

(defn run-game [assets] 
  (set state (start-menu/init assets))
  (math/seedrandom (os/time))
  (while (not (j/window-should-close))

    (:update state (j/get-frame-time) switch-state)
    (j/begin-drawing)
    (:draw state)
    (j/end-drawing))
  (j/close-window))

(defn main [& args]
  (j/init-window 1200 800 "Spark works")
  (j/set-target-fps 60)
  (j/hide-cursor)
  (def assets (load-assets)) 
  (run-game assets))

