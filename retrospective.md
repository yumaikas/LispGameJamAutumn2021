# Autumn Lisp Game Jam 2021 Retrospective/Postmortem

So, I took part in 

Space invaders
Platforming demo

1 LD 34 (Omega Llama)
2 LD 36 (Fateful Cavern)
3 LD 38 (Bullet Surfing)
4 Alakajam (Caster Fight!)
5 GMTK Game Jam 1 (Help, My Carrot Patch is out of control!)
6 Mizizizizi Game Jam (Battle for Seclusa)
7 GMTK Game Jam 2 (WISP)
Autum Lisp Game Jam  (Sparkworks)

The Autumn Lisp Game jam is the 8th game jam I've taken part in over the past 6 years, and the second one where I don't think I actively hate the code after finishing the Jam. So how did it go?

To be honest, this game jam kinda snuck up on me. Not having a theme meant that the usual heat of inspritation as my mind sparks and grinds ideas against each other wasn't happening this time. That feeling of staring at a blank page? Yeah, not fun. Still, since this was a Lisp Game Jam, and I had a Lisp I liked in Janet, I started, a day late, by getting a Rectangle swaying with sine and cosine in Jaylib, Janet's Raylib Bindings. Once I had that basic thing in place,  I decided to employ a trick I'd witnessed in the [Noblin's Nook Discord][Noblis-Nook-DIsc]: Divination ne Random Generation. I pulled 5 random words from a website, and got "Healthy, railroad, green, treat and omission". Human brains being as pattern seeking as they are, it reminded me of the Kenney 1-bit part back I'd used for the Battle for Seclusa, and the rails in it. 

Because if I use assets, that'll save me a lot of time, and keep the scope resonable, right?

I wasn't sure what to do with "healthy", "treat" or "omission", noodling around ideas around emotional boundaries or food. The emotional boundaries idea would have required a lot of custom assets, and I didn't want to play into diet culture too much.

So, I focused in on the railroads, and started putting together a system to designate tiles from a texture for use by the game. After getting that in place, I dived into building a system for creating dynamic autotiling, because what fun is a rail system if you can't add/remove rails from it? The end results were as shown.

![First screenshots here]()

Green as the color for the tiles was chosen since that was the color I got from the random words. 

After that, [Back here!]

[Jaylib]: TO-LINK
[Raylib]: TO-LINK
[Noblins-Nook-Disc]: TODO
