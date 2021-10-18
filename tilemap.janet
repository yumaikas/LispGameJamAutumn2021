(import jaylib :as j)
(import ./assets :as a)

(defn set-point [tilemap x y]
  (put-in tilemap [:state [x y]] true))

(defn clear-point [tilemap x y]
  (put-in tilemap [:state [x y]] nil))

(defn toggle-point [tilemap x y] 
  (if (get-in tilemap [:state [x y]])
    (do (clear-point tilemap x y))
    (do (set-point tilemap x y))))


(defn dir-test [bitmap]
  (if (= 2r0000 bitmap) :none
    [
     (when (= 2r0001 (band bitmap 2r0001)) :north) 
     (when (= 2r0010 (band bitmap 2r0010)) :east) 
     (when (= 2r0100 (band bitmap 2r0100)) :south) 
     (when (= 2r1000 (band bitmap 2r1000)) :west)]))

(def- dirs [
            [0 -1 2r0001] #north
            [1 0 2r0010] #east
            [0 1 2r0100] #south
            [-1 0 2r1000] #west
            ])

(defn- bitmap-point [tilemap x y] 
  (var bitmap 0)
  (each [dx dy bit] dirs 
    (when (get-in tilemap [:state [(+ x dx) (+ y dy)]])
      (+= bitmap bit)))
  bitmap)

(defn place-tile [{:size [mx my] :center [cx cy]} x y] 
  [(+ (* mx x) cx) (+ (* my y) cy) mx my])

(defn place-mouse [{:size [mx my] :center [cx cy]} x y] 
  [(+ (* mx (math/trunc (/ x mx))) cx) (+ (* my (math/trunc (/ y mx))) cy) mx my])

(defn draw-tilemap [tilemap]
  (def tileset (tilemap :tileset))
  (def bit-map (tileset :bitmap))
  (def grid (tileset :grid))

  (each [[x y] state] (pairs (tilemap :state))
    (when state
      (def name (bit-map (bitmap-point tilemap x y)))
      (:draw-named-tile tileset name (place-tile grid x y))
    )
    (def [mx my] (j/get-mouse-position))
    (def cursor (place-mouse grid mx my))
    (:draw-named-tile tileset :cursor cursor)
    ))

(defn click-tilemap [tilemap mx my] 
  (def [sx sy] (get-in tilemap [:tileset :grid :size]))
  (toggle-point tilemap (math/trunc (/ mx sx)) (math/trunc (/ my sy))))


(defn init-tilemap [tileset initial-state] 
  @{
    :tileset tileset
    :state initial-state
    :set-point set-point 
    :clear-point clear-point
    :draw draw-tilemap
    :click click-tilemap
    })

(comment @[:none #surround
  (:north nil nil nil)  #vert
  (nil :east nil nil) #horiz
  (:north :east nil nil) #up-right
  (nil nil :south nil)  # vert
  (:north nil :south nil) # vert
  (nil :east :south nil) #down-right
  (:north :east :south nil) #right-tri 
  (nil nil nil :west)  #horiz
  (:north nil nil :west) #up-right
  (nil :east nil :west)  #horiz
  (:north :east nil :west) #up-tri
  (nil nil :south :west) #down-left
  (:north nil :south :west) #left-tri
  (nil :east :south :west) #down-tri
  (:north :east :south :west) #surround
  ])
