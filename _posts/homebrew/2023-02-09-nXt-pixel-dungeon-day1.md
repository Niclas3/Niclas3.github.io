---
title: nXt-pixel-dungeon-day1
updated: 2022-02-09
categories : homebrew
---

Day 1
  Recently, I can't stop playing a RPG named "shattered-pixel-dungeon". It is a
rouge-like game, you are a hero (there are 4 occupations) for the secirts of 
dungeon. This game has a ported version on [switch platform], but I want to create 
a new switch version based on "shattered pixel dungeon" for adding more joycon 
feature, that sounds great.
  First, I don't have any Xp about making game, it is a challage. A good begun
is half done, let's list some goals on version 0.1
1. One hero 'Warrior'
2. No audio
3. One origial boss
  As we know, SPD is a open source game, We can get [SPD's code] from github and 
it also based of the source code of [Pixel Dungeon] by [Watabou], Those two games
were writed by a library called [libgdx] in java, but i want to practice C
programming skills so I want to use C rewriting a 'new' game in switch platform.
Now I need choice a C-based lib which likes 'libgdx', thought long term
searching I got nothing good on homebrew switch platform, btw, If you know
better, let me know. so I choice a 2D vector drawing library on top of OpenGL
for UI and visulizations named [nanovg].

[switch platform]: https://github.com/00-Evan/shattered-pixel-dungeon
[SPD's code]: https://github.com/00-Evan/shattered-pixel-dungeon
[Pixel Dungeon]: https://github.com/00-Evan/pixel-dungeon-gradle
[Watabou]: https://pixeldungeon.tumblr.com/
[libgdx]: https://libgdx.com
[nanovg]: https://github.com/memononen/nanovg
