(use ./utils)
(import ./button)
(import jaylib :as j)
(import ./level1)

(defn- update-menu [state dt switch-state]
  (def mpos (j/get-mouse-position))

  (def {:state { :menu-entries menu }} state)
  (each entry menu (:update entry dt mpos switch-state)))

(defn- draw-menu [{:state state :cursor cursor}]
  (j/clear-background [0 0 0])

  (def [mx my] (j/get-mouse-position))
  (each entry (state :menu-entries) 
    (:draw entry))
  (:draw cursor mx my))

(defn start-game [state switch]
  (switch (level1/init (state :assets))))

(defn exit-game [&]
  (j/close-window)
  (os/exit 0))

(defn init [assets]
  (def state @{:update update-menu
   :draw draw-menu
   :cursor (assets :cursor)
   :assets assets})
   (def menu-state 
     @{ :menu-entries 
      [
       (button/init "Start Game" [40 40] 80 [1 1 1] (fn [switch] (start-game state switch)))
       (button/init "Exit" [40 120] 80 [1 1 1] (fn [switch] (exit-game)))
       ] })
   (put state :state menu-state))
