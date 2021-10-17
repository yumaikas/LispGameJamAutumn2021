(import jaylib :as j)
(use ./utils)

(def tiles 
  {
   :vert { :coords [0 5] :rotation 0.0 :color [0 1 0] }
   :horiz { :coords [0 5] :rotation 90.0 :color [0 1 0] }
   :down-right { :coords [1 5] :rotation 0.0 :color [0 1 0] }
   :up-left { :coords [1 5] :rotation 180.0 :color [0 1 0] }
   :down-left { :coords [1 5] :rotation 90.0 :color [0 1 0] }
   :up-right { :coords [1 5] :rotation 270.0 :color [0 1 0] }
   :up-tri { :coords [2 5] :rotation 270.0 :color [0 1 0] }
   :right-tri { :coords [2 5] :rotation 0.0 :color [0 1 0] }
   :down-tri { :coords [2 5] :rotation 90.0  :color [0 1 0] }
   :left-tri { :coords [2 5] :rotation 180.0 :color [0 1 0] }
   :surround { :coords [3 5] :rotation 270.0 :color [0 1 0] }
   :cursor { :coords [ 39 14 ] :rotation 0.0 :color [1 0 0 ]}

   }) 

(def bitmap [ 
     :surround :vert :horiz :up-right
    :vert :vert :down-right :right-tri 
    :horiz :up-left :horiz :up-tri
   :down-left :left-tri :down-tri :surround
  ])

(defn draw-named-tile 
  [tmap tile-name dest &opt rotation]  
  (default rotation 0.0)
  (def tile-coord (get-in tmap [:named tile-name :coords]))
  (def base-color (get-in tmap [:named tile-name :color]))
  (def rect-coord [;(vec-elt-mult tile-coord (tmap :tile-size)) 
                   ;(tmap :tile-size)] )

  (def base-rotation (get-in tmap [:named tile-name :rotation]))

  (j/draw-texture-pro 
    (tmap :tex)
    rect-coord 
    dest 
    (tmap :center) (+ rotation base-rotation) base-color))

(defn load-assets [] 
  (def center [15 15])
  (def tmap 
    { 
     :tile-size [17 17] 
     :grid {:size [32 32] :center center}
     :center center
     :tex (j/load-texture `Assets\\monochrome_transparent.png`) 
     :named tiles
     :draw-named-tile draw-named-tile
     :bitmap bitmap })

  {:tileset tmap })

