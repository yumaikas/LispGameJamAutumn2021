(use ./utils)
(import jaylib :as j)

(defn pressed-move-down? [] (or (j/key-down? :down) (j/key-down? :s)))
(defn pressed-move-up? [] (or (j/key-down? :up) (j/key-down? :w)))
(defn pressed-move-right? [] (or (j/key-down? :right) (j/key-down? :d)))
(defn pressed-move-left? [] (or (j/key-down? :left) (j/key-down? :a)))

(defn update-player [player dt raftmap] 
  (def run-cycle (player :run-cycle))
  (def stand-cycle (player :stand-cycle))
  (def speed (player :speed))
  (var dy 0)
  (var dx 0)
  (def pos (player :position))
  (def [north east south west] 
    (map |(map + pos $) [[0 -8] [8 0] [0 8] [-8 0]]))

  (def move-up? (and (pressed-move-up?) (:test-coord raftmap ;north)))
  (def move-down? (and (pressed-move-down?) (:test-coord raftmap ;south)))
  (def move-right? (and (pressed-move-right?) (:test-coord raftmap ;east)))
  (def move-left? (and (pressed-move-left?) (:test-coord raftmap ;west)))

  (when move-down? (+= dy (* dt speed)))
  (when move-up? (-= dy (* dt speed)))

  (when move-right?
    (+= dx (* dt speed))
    (put player :scale [1 1]))

  (when move-left?
    (-= dx (* dt speed))
    (put player :scale [1 -1]))

  (def new-pos (map + pos [dx dy]))
  (put player :position new-pos)
  (put player :moved [dx dy])
  (:update run-cycle dt)
  (:update stand-cycle dt))
  
(defn player-on-tile [player tilemap x y] 
  (def [px py] (player :position))
  (def [sx sy] (get-in tilemap [:tileset :grid :size]))
  (def [tx ty] [(math/trunc (/ px sx)) (math/trunc (/ py sy))])
  (and (= x tx) (= y ty)))

(defn draw-player [player]
  (def 
    {
     :run-cycle run 
     :stand-cycle stand
     :moved movement
     :position [x y]
     :scale [sx sy]
     } player)

  (def [nx ny] (map math/trunc [x y]))
  (def pos [(- x  8) (- y 16) ;(map * [sx sy] [34 34])])
  #(j/draw-circle nx ny 100 [1 0 0 0.5])

  # Draw wre the sensors are going to be
  ## (j/draw-circle (+ nx 8) ny 4 [0 1 1])
  ## (j/draw-circle nx (- ny 8) 4 [0 1 1])
  ## (j/draw-circle nx (+ ny 8) 4 [0 1 1])
  ## (j/draw-circle (- nx 8) ny 4 [0 1 1])
  (if (= [0 0] movement)
    (:draw stand pos 0)
    (:draw run pos 0)))

(defmacro tfn [t f] 
  ~(put ,t ,(keyword f) ,f))

(defn init-player [assets x y]
  (def {
        :player-run-cycle run-cycle
        :player-stand-cycle stand-cycle
        } assets)

  (def player 
    @{
      :update update-player
      :draw draw-player
      :moved [0 0]
      :speed 100
      :scale [1 1]
      :on-tile player-on-tile
      :run-cycle run-cycle
      :stand-cycle stand-cycle
      :position @[x y]
      })
  player)


