(import jaylib :as j)

(defn- update- [&]
  nil)

(defn- draw [entry] 
  (def 
    {:text text
    :coord [x y]
    :size h
    :color color} entry)
  (def text-width (j/measure-text text h))
  (j/draw-text text (+ x 10) (+ y 4) (- h 3) color))

(defn init [text coord size color]
  @{:text text
    :coord coord
    :size size
    :color color
    :update update-
    :draw draw })
