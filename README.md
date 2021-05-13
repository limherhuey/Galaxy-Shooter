# Galaxy Shooter
**An infinite-scoring 2D shooter game.**

Written with Lua and LÖVE. Check out the [gameplay video](https://youtu.be/OhFgctFSzGw)!

---
## Game Features:
1. A Player-controlled Spacecraft
    - player can select preferred spacecraft to play with from 12 unique designs
    - movable vertically along the left side of screen with up and down arrow keys
    - press 'space' to shoot a beam of laser towards the right, which can hit meteors
    - lasers that go past the right edge of the screen without hitting a meteor will result in a deduction of 1 point (for more difficulty and fun!)
    - 3 health points initially; when player has no health left, it will be game over
    - health bar at the top of the screen shows current health, depicted by the chosen spacecraft design

2. Meteors
    - comes in different shapes, sizes, and colours
    - will randomly spawn (indefinitely) from the right side and fly towards the spacecraft's side
    - when a meteor collides with the player's spacecraft, it will deal a point of damage
    - when a meteor passes the left edge of the screen, some score will be deducted
        - the larger the meteor, the higher the score deduction, because they are more difficult to miss
    - when the player hits a meteor with a beam of laser, the meteor will be destroyed and some score will be added
        - the smaller the meteor, the higher the score awarded, because they are more difficult to aim at
    - as the game progresses, the spawn rate and velocity of meteors will increase

3. Score
    - see 'Meteors' section
    - if score is negative, player will lose a health point and score will be reset to 0

4. Powerups
    - colour in any particular game will depend on colour of player's chosen spacecraft in that game
    - different designs have different powers upon collection:
        - blank - increases score by 10
        - bolt - destroys all meteors in the game with a flash
        - shield - player gains a protective shield for 5 seconds; meteors will be destroyed when they collide with the shield, but player will not score for meteors destroyed in this way
        - star - heals player by 1 health point

5. Miscellaneous
    - random background every game
    - cool animations!
    - press 'p' to pause the game in play mode
    - press 'escape' anytime to quit the game

---
## Credits:
Graphics, fonts, and some sounds by [Kenney Vleugels](www.kenney.nl) from [here](https://opengameart.org/content/space-shooter-redux)

Other sounds: generated with [sfxr](http://drpetter.se/project_sfxr.html)

Music: [Lift Off by Jahzzar](https://freemusicarchive.org/music/Jahzzar/Galaxy/Lift_Off_1082)