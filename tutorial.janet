(use ./utils)
(import ./button)
(import ./label)
(import jaylib :as j)
(import ./menu)
(import ./attributions :as credits)


(defn init [assets]
  (var ytrack 30)
  (var xtrack 60)
  (def state {:assets assets})
  (def start-menu/init  (assets :start-menu/init))
  (def menu 
    (menu/init 
      assets 
      [(label/init "How to play" [xtrack (+= ytrack 40)] 100 [1 1 0])

       (label/init "Goal: Connect all of the sparks to a lit rail" [(+= xtrack 20) (+= ytrack 140)] 40 [1 1 1])
       (label/init "- WASD or Arrows move" [xtrack (+= ytrack 50)] 40 [1 1 1])
       (label/init "- Click to place rails" [xtrack (+= ytrack 50)] 40 [1 1 1])
       (label/init "- Click again to remove rails" [xtrack (+= ytrack 50)] 40 [1 1 1])
       (label/init "- If a rail would connect to two lit rails" [xtrack (+= ytrack 50)] 40 [1 1 1])
       (label/init "  it cannot be placed there" [xtrack (+= ytrack 50)] 40 [1 1 1])
       (label/init "- Rails from the start of the level cannot be changed" [xtrack (+= ytrack 50)] 40 [1 1 1])
       (label/init "" [xtrack (+= ytrack 50)] 20 [1 1 1])
       (label/init "Enjoy the vibes!" [xtrack (+= ytrack 50)] 40 [1 1 1])
       (button/init "Back to menu" [xtrack (+= ytrack 90)] 60 [1 1 1] 
                    (fn [me switch] (switch (start-menu/init assets))))
       ] 
      {:clear [0 0 0]}))
  (put menu :shown true)
  menu)
