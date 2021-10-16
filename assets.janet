(import jaylib :as j)
(use ./utils)

(def tiles 
  {
   :railroad-vert { :coords [0 5] :rotation 0.0 :color [0 1 0] }
   :railroad-horiz { :coords [0 5] :rotation 90.0 :color [0 1 0] }
   :railroad-down-right { :coords [1 5] :rotation 0.0 :color [0 1 0] }
   :railroad-up-left { :coords [1 5] :rotation 180.0 :color [0 1 0] }
   :railroad-down-left { :coords [1 5] :rotation 90.0 :color [0 1 0] }
   :railroad-up-right { :coords [1 5] :rotation 270.0 :color [0 1 0] }
            })

(defn load-assets [] 
  (def tmap 
    { 
     :tile-size [17 17] 
     :center [15 15]
     :tex (j/load-texture `Assets\\monochrome_transparent.png`) 
     :named tiles })

  {:tilemap tmap :cell-grid [32 32] })

(defn place-tile [[mx my] x y] [(* mx x) (* my y) mx my])

(defn draw-named-tile 
  [tmap tile-name dest &opt rotation]  
  (default rotation 0.0)
  (def tile-coord (get-in tmap [:named tile-name :coords]))
  (def base-color (get-in tmap [:named tile-name :color]))
  (def rect-coord [;(vec-elt-mult tile-coord (tmap :tile-size)) ;(tmap :tile-size)] )

  (def base-rotation (get-in tmap [:named tile-name :rotation]))

  # (tracev [(tmap :tex) rect-coord dest (tmap :center) (+ rotation base-rotation) [1 1 1]])
  (j/draw-texture-pro (tmap :tex) rect-coord dest (tmap :center) (+ rotation base-rotation) base-color))
  
