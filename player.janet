(use ./utils)
(import jaylib :as j)

(defn move-down? [] (or (j/key-down? :down) (j/key-down? :s)))
(defn move-up? [] (or (j/key-down? :up) (j/key-down? :w)))
(defn move-right? [] (or (j/key-down? :right) (j/key-down? :d)))
(defn move-left? [] (or (j/key-down? :left) (j/key-down? :a)))

(defn update-player [player dt] 
  (def run-cycle (player :run-cycle))
  (def stand-cycle (player :stand-cycle))
  (def speed (player :speed))
  (def pos (player :position))
  (var dy 0)
  (var dx 0)

  (when (move-down?) (+= dy (* dt speed)))
  (when (move-up?) (-= dy (* dt speed)))

  (when (move-right?)
    (+= dx (* dt speed))
    (put player :scale [1 1]))

  (when (move-left?)
    (-= dx (* dt speed))
    (put player :scale [1 -1]))

  (def new-pos (map + pos [dx dy]))
  (put player :position new-pos)
  (put player :moved [dx dy])
  (:update run-cycle dt)
  (:update stand-cycle dt))
  

(defn draw-player [player]
  (def 
    {
     :run-cycle run 
     :stand-cycle stand
     :moved movement
     :position [x y]
     :scale [sx sy]
     } player)
  (def pos [x y ;(map * [sx sy] [34 34])])
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
      :run-cycle run-cycle
      :stand-cycle stand-cycle
      :position @[x y]
      })
  player)


