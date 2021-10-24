(import jaylib :as j)
(use ./utils)
(import ./attributions :as credits)

(def tiles 
  {
   :vert { :coords [0 5] :rotation 0.0 :color [0 0.4 0] }
   :horiz { :coords [0 5] :rotation 90.0 :color [0 0.4 0] }
   :down-right { :coords [1 5] :rotation 0.0 :color [0 0.4 0] }
   :up-left { :coords [1 5] :rotation 180.0 :color [0 0.4 0] }
   :down-left { :coords [1 5] :rotation 90.0 :color [0 0.4 0] }
   :up-right { :coords [1 5] :rotation 270.0 :color [0 0.4 0] }
   :up-tri { :coords [2 5] :rotation 270.0 :color [0 0.4 0] }
   :right-tri { :coords [2 5] :rotation 0.0 :color [0 0.4 0] }
   :down-tri { :coords [2 5] :rotation 90.0  :color [0 0.4 0] }
   :left-tri { :coords [2 5] :rotation 180.0 :color [0 0.4 0] }
   :surround { :coords [3 5] :rotation 270.0 :color [0 0.4 0] }
   :cursor { :coords [ 39 14 ] :rotation 0.0 :color [1 0 0 ]}
   :mouse { :coords [ 38 10 ] :rotation 0.0 :color [0.2 0.4 1]}
   :lock-box { :coords [ 0 10 ] :rotation 0.0 :color [1 1 0]}
   :blocked { :coords [ 40 14 ] :rotation 0.0 :color [1 0 0]}
   :spark { :coords [6 0] :rotation 0.0 :color [1 1 0]}
   }) 

(def bitmap [ 
    :surround :vert :horiz :up-right
    :vert :vert :down-right :right-tri 
    :horiz :up-left :horiz :up-tri
   :down-left :left-tri :down-tri :surround
  ])

(defn pick-tile [coord size] 
  [;(map * coord size) ;size])

(defn draw-named-tile 
  [tmap tile-name dest &opt rotation add-color]  
  (default rotation 0.0)
  (default add-color [0 0 0])
  (def tile-coord (get-in tmap [:named tile-name :coords]))
  (def base-color (get-in tmap [:named tile-name :color]))
  (def base-rotation (get-in tmap [:named tile-name :rotation]))

  (j/draw-texture-pro 
    (tmap :tex)
    (pick-tile tile-coord (tmap :tile-size))
     dest 
    (tmap :center) (+ rotation base-rotation) (map + base-color add-color)))

(defn draw-cursor 
  [tmap tile-name dest]  
  (def tile-coord (get-in tmap [:named tile-name :coords]))
  (def base-color (get-in tmap [:named tile-name :color]))
  (def base-rotation (get-in tmap [:named tile-name :rotation]))

  (j/draw-texture-pro 
    (tmap :tex)
    (pick-tile tile-coord (tmap :tile-size))
     dest 
     [0 0] 0 base-color))

(defn draw-rect-frame [frame dest rotation] 
  (var dest dest)
  (var [x y h w] dest)
  (var src (frame :rect))
  (var [sx sy sh sw] src)

  (when (> 0 w)
    (set dest [x y (- w) h])
    (set src [sx sy (- sw) sh]))
  (when (> 0 h)
    (set dest [x y w (- h)])
    (set src [sx sy sw (- sh)]))

  (j/draw-texture-pro 
    (frame :tex)
    src
    dest 
    (frame :center) 
    (+ rotation (frame :rotation)) (frame :color)))

(defn frame [start-time tex rect &opt rotation color]
  {
   :ts start-time
   :tex tex
   :rect rect
   :center (map |(/ $ 2) (slice rect 2))
   :rotation (or rotation 0)
   :color (or color [1 1 1])
   :draw draw-rect-frame
   }
  )

(defn update-animation [animation dt]
  (var {:time t 
        :idx idx 
        :duration duration
        :frames frames} animation)

  (def f (frames idx))
  (var new-time (+ t dt))
  (when (> new-time (f :ts))
    (set idx (clamp (+ 1 idx) 0 (- (length frames) 1 ))))
  (when (and 
          (> new-time (animation :duration))
          (animation :loop))
    (set new-time 0)
    (set idx 0))

  (put animation :time (clamp new-time 0 (animation :duration)))
  (put animation :idx idx)
  )

(defn draw-animation [animation dest rotation] 
  (var {:idx idx :frames frames} animation)
  (def f (frames idx))
  (:draw f dest rotation))


(defn init-animation [duration frames]
  @{:time 0.0
    :duration duration
    :idx 0
    :loop true
    :state :playing # playing or stopped
    :frames frames
    :update update-animation 
    :draw draw-animation
    }
  )

# Kenney
(credits/add :kenny-tex "Textures by Kenny.nl")
(def- text.png (slurp `Assets/monochrome_transparent.png`))

# No credits for this, as far as I can tell?
(def- click-audio (slurp `Assets/Clic07.wav`))
(credits/add :music `Song: "Janne Hanhisuanto for Radakan"`)
(def- music-data (slurp `Assets/del_erad.ogg`))
(credits/add :thump-sound "Thump sound created by Jordan Irwin (AntumDeluge)")
(def- thump-sound (slurp `Assets/thwack-03.wav`))

(defn spitball [data ext func]
  (def temp-path (string "temp." ext))
  (spit temp-path data)
  (def return-value (func temp-path))
  (os/rm temp-path)
  return-value)

(defn cleanup-assets [] 
  (os/rm "music1.ogg"))

(defn load-assets [] 
  (def center [15 15])
  (def tile-size [17 17])

  (def core-tex (spitball text.png "png" j/load-texture))
  (def click-audio (spitball click-audio "wav" j/load-sound))
  (def thump-sound (spitball thump-sound "wav" j/load-sound))
  (spit "music1.ogg" music-data)
  (def level1-music (j/load-music-stream "music1.ogg"))

  (j/set-sound-volume thump-sound 0.2)
  (j/set-music-volume level1-music 0.2)

  (def tmap 
    { 
     :tile-size tile-size 
     :grid {:size [32 32] :center center}
     :center center
     :tex core-tex
     :named tiles
     :draw-named-tile draw-named-tile
     :bitmap bitmap })

  (def player-run-cycle 
    (init-animation 
      (* 0.125 3)
      [(frame (* 1 0.125) core-tex (pick-tile [19 9] tile-size) 0 :yellow)
       (frame (* 2 0.125) core-tex (pick-tile [20 9] tile-size) 0 :yellow)
       (frame (* 3 0.125) core-tex (pick-tile [18 9] tile-size) 0 :yellow) ]))

  (def player-stand-cycle 
    (init-animation 
      (* 0.5 2)
      [(frame (* 1 0.5) core-tex (pick-tile [18 9] tile-size) -2 :yellow)
       (frame (* 2 0.5) core-tex (pick-tile [18 9] tile-size) 2 :yellow)
       ]))

  @{:tileset tmap 
   :player-run-cycle player-run-cycle
   :player-stand-cycle player-stand-cycle
   :click-sound click-audio
   :thump-sound thump-sound
   :level1-music level1-music
   :cursor { :draw (fn [_ x y] (draw-cursor tmap :mouse [x y ;(map |(* 2 $) tile-size)])) }
   })

