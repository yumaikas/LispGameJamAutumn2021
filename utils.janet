(defn sway [n t scale]
  (+ n (* scale (math/sin t))))
(defn co-sway [n t scale]
  (+ n (* scale (math/cos t))))

(defn vec-elt-mult [[x y] [mx my]] 
  [(* x mx) (* y my)])

(defn clamp [val lower upper] (max (min val upper) lower))

(defn distance [a b] (math/sqrt (+ ;(map |(math/pow (- $1 $0) 2) a b))))




