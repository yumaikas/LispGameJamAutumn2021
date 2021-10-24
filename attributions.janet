(def- attributions @{})
(def- order @[])

(defn add [key data]
  (array/push order key)
  (put attributions key data))

(defn get [key]
  (attributions key))

(defn every []
  (seq [k :in order]
    (attributions k)))
