(use ./utils)
(import ./button)
(import jaylib :as j)

(defn- update-menu [state dt switch-state]
  (def mpos (j/get-mouse-position))
  (when (j/key-pressed? :p)
    (put state :shown (not (state :shown))))

  (when (state :shown) 
    (def {:state { :menu-entries menu }} state)
    (each entry menu (:update entry dt mpos switch-state))))

(defn- draw-menu [{:state state :shown shown :cursor cursor}]
  (def [mx my] (j/get-mouse-position))
  (when state
    (each entry (state :menu-entries) 
      (:draw entry))))

(defn init [assets]
  (def start-menu/init (assets :start-menu/init))
  (def level1/init (assets :level1/init))

  (def state 
    @{:update update-menu
      :draw draw-menu
      :shown false
      :cursor (assets :cursor)
      :assets assets})

   (def menu-state 
     @{ :menu-entries 
      [
       (button/init "Play again" [80 160] 80 [1 1 1] 
                    (fn [switch] (switch (level1/init assets))))
       (button/init "Return to Menu" [80 240] 80 [1 1 1] 
                    (fn [switch] (switch (start-menu/init assets))))
       ] })
   (put state :state menu-state))
