(import jaylib :as j)
(use ./utils)
(use ./assets)
(use ./tilemap)
(use ./player)
(import ./start-menu)
(import ./level1)

(var- state nil)

(defn switch-state [new-state] 
  (when-let [music (dyn :music)]
    (j/pause-music-stream music))
  (set state new-state))

(defn run-game [assets] 
  (put assets :start-menu/init start-menu/init)
  (put assets :level1/init level1/init)
  (setdyn :assets assets)
  (set state (start-menu/init assets))
  (math/seedrandom (os/time))
  (while (not (j/window-should-close))
    (:update state (j/get-frame-time) switch-state)
    (j/begin-drawing)
    (:draw state)
    (j/end-drawing))
  (j/close-window))

(defn main [& args]
  (j/set-trace-log-level :error)
  (j/init-window 1200 800 "Spark works")
  (j/init-audio-device)
  (j/set-target-fps 60)
  (j/hide-cursor)
  (def assets (load-assets)) 
  (run-game assets))

