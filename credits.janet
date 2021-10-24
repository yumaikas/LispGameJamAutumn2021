(use ./utils)
(import ./button)
(import ./label)
(import jaylib :as j)
(import ./menu)
(import ./attributions :as credits)


(defn init [assets]
  (var ytrack 80)
  (var xtrack 60)
  (def state {:assets assets})
  (def start-menu/init  (assets :start-menu/init))
  (def menu 
    (menu/init 
      assets 
      [(label/init "Sparkworks" [xtrack (+= ytrack 40)] 100 [1 1 0])

       (label/init "#builtwithraylib" [(+= xtrack 20) (+= ytrack 140)] 40 [1 1 1])
       (label/init "code by @yumaikas" [xtrack (+= ytrack 50)] 40 [1 1 1])
       ;(seq [lbl :in (credits/every)]
          (label/init lbl [xtrack (+= ytrack 50)] 40 [1 1 1]))
       (button/init "Back to menu" [xtrack (+= ytrack 90)] 60 [1 1 1] 
                    (fn [me switch] (switch (start-menu/init assets))))
       ] 
      {:clear [0 0 0]}))
  (put menu :shown true)
  menu)
