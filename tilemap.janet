(import jaylib :as j)
(import ./assets :as a)
(use ./utils)

(def- dirs [
            [0 -1 2r0001] #north
            [1 0 2r0010] #east
            [0 1 2r0100] #south
            [-1 0 2r1000] #west
            ])

(defn- set-around-point [tilemap x y]
  (seq [[dx dy bit] :in dirs
        :let [px (+ x dx) py (+ y dy)]
        :when (get-in tilemap [:state [px py]]) ]
    [px py bit]))

(defn- dark? [[_ _ light]] (not light))
(defn- light? [[_ _ light]] light)

(defn- lit-key? [tilemap x y] 
  (and
    (get-in tilemap [:key-map [x y]])
    (light? (or (get-in tilemap [:state [x y]]) [0 0 false]))))

(defn- dark-around-point [tilemap x y]
  (seq [[dx dy bit] :in dirs
        :let [px (+ x dx) py (+ y dy)
              pt (get-in tilemap [:state [px py]])
              ] 
        :when (and pt (dark? pt)) ]
    [px py bit]))

(defn- light-around-point [tilemap x y]
  (seq [[dx dy bit] :in dirs
        :let [px (+ x dx) py (+ y dy)
              pt (get-in tilemap [:state [px py]])
              ] 
        :when (and pt (light? pt)) ]
    [px py bit]))

(defn- bitmap-point [tilemap x y] 
  (var bitmap 0)
  (each [px py bit] (set-around-point tilemap x y) 
      (+= bitmap bit))
  bitmap)

(defn- light-point [tilemap x y]
  (def [_ bitmap _] (get-in tilemap [:state [x y]]))
  (put-in tilemap [:state [x y]] [true bitmap true])
  (each [dx dy] (dark-around-point tilemap x y)
    (light-point tilemap dx dy)))

(defn- set-point [tilemap x y]
  (def bitmap (bitmap-point tilemap x y))
  (def light (get-in tilemap [:state [x y] 2]))
  (put-in tilemap [:state [x y]] [true bitmap (or light false)])

  (each [px py] (set-around-point tilemap x y)
    (def bitmap (bitmap-point tilemap px py))
    (def light (get-in tilemap [:state [px py] 2]))
    (put-in tilemap [:state [px py]] [true bitmap light]))
  tilemap)

(defn- lock-point [tilemap x y] 
  (put-in tilemap [:locked-tiles [x y]] true))

(defn- set-target-tile [tilemap x y]
  (put-in tilemap [:key-map [x y]] true))

(defn- clear-point [tilemap x y]
  (put-in tilemap [:state [x y]] nil)
  (each [px py] (set-around-point tilemap x y)
    (def bitmap (bitmap-point tilemap px py))
    (def light (get-in tilemap [:state [px py] 2]))
    (put-in tilemap [:state [px py]] [true bitmap light]))
  tilemap)

(defn- toggle-point [tilemap x y] 
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


(defn place-tile [{:size [mx my] :center [cx cy]} x y] 
  [(+ (* mx x) cx) (+ (* my y) cy) mx my])

(defn place-mouse [{:size [mx my] :center [cx cy]} x y] 
  [(+ (* mx (math/trunc (/ x mx))) cx) (+ (* my (math/trunc (/ y mx))) cy) mx my])

(defn pixel->tile [{:size [mx my] :center [cx cy]} x y]
  [(math/trunc (/ x mx)) (math/trunc (/ y my))])


(defn draw-tilemap [tilemap [mx my] should-draw-cursor]
  (def tileset (tilemap :tileset))
  (def bit-map (tileset :bitmap))
  (def key-map (tilemap :key-map))
  (def grid (tileset :grid))

  (def max-y (max ;(map 1 (keys (tilemap :state)))))
  (each [[x y] [state bitmap lit]] (pairs (tilemap :state))
    (when state
      (def keyed (get key-map [x y]))
      (def name (bit-map bitmap ))
      (def blueness (/ y max-y))
      (def redness (/ (- max-y y) max-y))
      (cond
        lit (:draw-named-tile tileset name (place-tile grid x y) 0 [0.1 0.3 (+ (* 0.6 blueness) 0.1)])
        :else (:draw-named-tile tileset name (place-tile grid x y) 0 [(* 0.7 redness) 0 0] ))
      (when (and (not lit) keyed)
        (:draw-named-tile tileset :spark (place-tile grid x y) 0 [0 0 0]))
      ))

  (when should-draw-cursor
    (def cursor (place-mouse grid mx my))
    (:draw-named-tile tileset :cursor cursor)

    (def [tx ty] (pixel->tile grid mx my))
    (when (get-in tilemap [:locked-tiles [tx ty]])
      (:draw-named-tile tileset :lock-box cursor))
    (when (<= 2 (length (light-around-point tilemap tx ty)))
      (:draw-named-tile tileset :blocked cursor))
    ))

(defn unlit-remain [tilemap]
  (-
   (length (keys (tilemap :key-map)))
   (length (filter |(lit-key? tilemap ;$) (keys (tilemap :state))))))

(defn click-tilemap [tilemap player mx my] 
  (def [sx sy] (get-in tilemap [:tileset :grid :size]))
  (def [x y] [(math/trunc (/ mx sx)) (math/trunc (/ my sy))])
  (when (get-in tilemap [:locked-tiles [x y]])
    (break))
  (def lights (light-around-point tilemap x y))
  (def destroy?  (not (not (get-in tilemap [:state [x y]]))))
  (def create? (not destroy?))
  (def in-radius (> 100 (distance [mx my] (player :position))))
  (def under-player (:on-tile player tilemap x y))
  (def has-room (> 2 (length lights)))

  (when (or 
          (and destroy? in-radius (not under-player))
          (and create? in-radius under-player) 
          (and create? in-radius has-room))
    (toggle-point tilemap x y)
    (when (and create? (> (length lights) 0))
      (light-point tilemap x y))))

(defn test-coord [tilemap tx ty]
  (def [sx sy] (get-in tilemap [:tileset :grid :size]))
  (def [x y] [(math/trunc (/ tx sx)) (math/trunc (/ ty sy))])
  (when-let [state (get-in tilemap [:state [x y]])]
    state))

(defn init-tilemap [tileset initial-state] 
  (def tmap @{
    :tileset tileset
    :state @{}
    :locked-tiles @{}
    :key-map @{}
    :light-point light-point
    :set-point set-point 
    :lock-point lock-point
    :unlit-remain unlit-remain
    :clear-point clear-point
    :test-coord test-coord
    :key-point set-target-tile
    :draw draw-tilemap
    :click click-tilemap
    })
  (each pt (keys initial-state)
    (set-point tmap ;pt)
    (lock-point tmap ;pt))
  tmap)

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
