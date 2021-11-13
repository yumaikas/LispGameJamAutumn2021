# Retrospective draft

Below are random assorted thoughts from reflecting on the Autum Lisp Game jam. The Autumn Lisp Game Jam of 2021 marks the 8th game jam I've taken part in.


## Art

- I liked the asset slicing, but mostly because I already had one major asset. I ended up using named tiles for most things.
- Looks like Asperite can create texture a texture atlas. Cool, that'll be handy to know for later, even though I din't use it during the jam.
- The 1-bit plus render-time coloring worked well.

## Sources of inspiration

- [Noblin's nook](https://i.momatoes.com/discord) gave me the the idea to try a random word generator. The random words that fell out where "healthy", "railroad", "green", "treat", "omission". I think that 5 words was too many. In the future, I might do roll 5 keep 2, or roll 6 keep 3. 
- [BeeverFeever95](https://discord.com/channels/426912293134270465/540457197176487946/901439179857211443) suggested using gradients, which enhanced the look immensely.
- The [Kenney 1-bit pack](https://www.kenney.nl/assets/bit-pack) was obviously inspirational as well.


## The game snuck up on me, from an effort standpoint. 

It started out as a move square, and that was it for night one. Then it was me noodling about how to turn 5 words into a game. Then it was auto-tiling rails. Then it was Seaweed Salad: a Raft Demake. Then it was fixing movement. Once the movent was in place, I started getting fixated on vibes, especially since people liked the green. Then the game became about connecting all of the pieces together. Then I spent a decent amount of time on fiddling with how the game looked. Because the game looked nicer when only a subset of the tiles were connected, I moved it towards only requireing a subset of the tiles. 

## Effort sinks

Autotiling took a lot of effort, as did setting rules for avoiding lighting loops. Menuing also took a chunk of effort.

Molloy wanted to help too, but kept running into JPM issues. JPM, as a tool, is still too fiddly to get up and running.

## Tech things

At one point, I had to cache the auto-tiling. That took an extra 60-90 minutes or so, but computing the auto-tiling for every tile ended up dropping things to 20 FPS, it was the only thing that did that the entire Jam, however. There were some funny results while that was WIP. Turns out that doing 9x200 ish map accesses isn't super efficient to do every frame, only re-computing tilemap bitmaps on tilemap change brought that framerate right back up to 0fps.

Movement was a very basic 4-directional "is there an active tile in this direction" style thing.

Deciding when to allow creating/destroying tiles became quite a bit effort, though it also ended up with some of the most "readable" code:

```janet

  (when (or 
          (and destroy? in-radius (not under-player))
          (and create? in-radius under-player) 
          (and create? in-radius has-room))
    (j/play-sound thump-sound)
    (toggle-point tilemap x y)
    (when destroy? 
      (each [lx ly] lights
        (when (= 0 (length (light-around-point tilemap lx ly)))
          (dark-point tilemap lx ly))))

    (when (and create? (> (length lights) 0))
      (light-point tilemap x y))))

```

I have a file called attributions.janet, so that I could add attributions for assets as I imported them, and then use that information in the credits scene. It felt funny to be using enough assets to justify that, but attribution is important, and was in-scope for the jam.

I wasn't able to get a web-build completed, which was disappointing, but a web build of Janet + Jaylib looks to be a fairly fiddly challenge. Not impossible, but likely involving tradeoffs around native libraries.

## Finishing

- "Finishing" meant something specific to me, and might be part of why some parts of the game were underbaked? Finishing, to me, means:
  - Basic sounds are in place
  - There is a starting menu of some flavor, and ideally a pause menu as well.
  - There is a way to "complete" the basics of the game, both positive and/or negative as called for by the game, with feedback in that direction.
  - I have representative screenshots on the project page
  - I have builds for multiple platforms
  - The gameplay isn't entirely broken.

Finishing the game also took the better part of a day.

## Notable feedback to integrate into the future

If I'm going to do such a grid-based game, mouse + free-moving WASD is a bit of an awkward scheme for the movement, it'd be better to make it a bit snappier and do more hop-like movement. 

Only one player mentioned adding more puzzle elements with levels that weren't so large. To really do something like that, I think I'd need to integrate better level design tools. 

At a bare minimum, I'd need something like support for Tiled in Janet, or I'd need to build my own GUI level editor of sorts. That is a big difference between my Godot games and my non-Godot games: The non-Godot ones only have features that are easy to code, which means that crunching out content is harder to pull off. I'd like to try to fix this at some point.



