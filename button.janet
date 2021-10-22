(import jaylib :as j)

(defn- hover-rect 
  
  [
   {:text text
    :coord [x y]
    :size h
    :color color }
   ] 
  (def text-width (j/measure-text text h))
  [x y (+ text-width 10) h])

(defn- update-menu-entry [entry dt [mx my] switch]
  (def 
    {:text text
    :coord [x y]
    :size h
    :color color} entry)
  (def hovered (j/check-collision-recs [mx my 1 1] (hover-rect entry)))
  (put entry :hovered hovered)
  (def clicked (and (j/mouse-button-pressed? :left) hovered))
  (when clicked
    ((entry :on-click) switch)))

(defn- draw-menu-entry [entry] 
  (def 
    {:text text
    :coord [x y]
    :size h
    :color color} entry)
  (def text-width (j/measure-text text h))

  (j/draw-text text (+ x 10) (+ y 4) (- h 3) color)
  (when (entry :hovered)
    (j/draw-rectangle-lines ;(hover-rect entry) color)))

(defn init [text coord size color on-click]
  @{:text text
    :coord coord
    :size size
    :color color
    :hovered false
    :update update-menu-entry
    :draw draw-menu-entry
    :on-click on-click })
