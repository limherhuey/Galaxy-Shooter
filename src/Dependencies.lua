Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/constants'
require 'src/StateMachine'
require 'src/Util'

require 'src/Background'
require 'src/Spacecraft'
require 'src/Projectile'
require 'src/Meteor'
require 'src/Powerup'

require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/StartAnimationState'
require 'src/states/SelectSpacecraftState'
require 'src/states/SelectAnimationState'
require 'src/states/PlayState'
require 'src/states/GameOverState'

gTextures = {
    -- backgrounds
    ['black'] = love.graphics.newImage('graphics/Backgrounds/black_combined.png'),
    ['blue'] = love.graphics.newImage('graphics/Backgrounds/blue_combined.png'),
    ['dark-purple'] = love.graphics.newImage('graphics/Backgrounds/darkPurple_combined.png'),
    ['purple'] = love.graphics.newImage('graphics/Backgrounds/purple_combined.png'),

    ['spacecrafts'] = love.graphics.newImage('graphics/spacecrafts.png'),

    ['lasers'] = love.graphics.newImage('graphics/lasers.png'),

    ['lives'] = love.graphics.newImage('graphics/life.png'),

    ['powerups'] = love.graphics.newImage('graphics/powerups.png'),

    ['shields'] = love.graphics.newImage('graphics/shields.png'),

    ['arrows'] = love.graphics.newImage('graphics/arrows.png'),

    ['meteors'] = {
        -- brown meteors
        love.graphics.newImage('graphics/Meteors/meteorBrown_big1.png'),
        love.graphics.newImage('graphics/Meteors/meteorBrown_big2.png'),
        love.graphics.newImage('graphics/Meteors/meteorBrown_big3.png'),
        love.graphics.newImage('graphics/Meteors/meteorBrown_big4.png'),
        love.graphics.newImage('graphics/Meteors/meteorBrown_med1.png'),
        love.graphics.newImage('graphics/Meteors/meteorBrown_med2.png'),
        love.graphics.newImage('graphics/Meteors/meteorBrown_small1.png'),
        love.graphics.newImage('graphics/Meteors/meteorBrown_small2.png'),
        love.graphics.newImage('graphics/Meteors/meteorBrown_tiny1.png'),
        love.graphics.newImage('graphics/Meteors/meteorBrown_tiny2.png'),
        
        -- grey meteors
        love.graphics.newImage('graphics/Meteors/meteorGrey_big1.png'),
        love.graphics.newImage('graphics/Meteors/meteorGrey_big2.png'),
        love.graphics.newImage('graphics/Meteors/meteorGrey_big3.png'),
        love.graphics.newImage('graphics/Meteors/meteorGrey_big4.png'),
        love.graphics.newImage('graphics/Meteors/meteorGrey_med1.png'),
        love.graphics.newImage('graphics/Meteors/meteorGrey_med2.png'),
        love.graphics.newImage('graphics/Meteors/meteorGrey_small1.png'),
        love.graphics.newImage('graphics/Meteors/meteorGrey_small2.png'),
        love.graphics.newImage('graphics/Meteors/meteorGrey_tiny1.png'),
        love.graphics.newImage('graphics/Meteors/meteorGrey_tiny2.png')
    }
}

gFrames = {
    -- table of spacecrafts
    ['spacecrafts'] = GenerateSpacecraftQuads(gTextures['spacecrafts']),

    -- table of lasers
    ['lasers'] = GenerateLaserQuads(gTextures['lasers']),

    -- table of lives
    ['lives'] = GenerateLifeQuads(gTextures['lives']),

    -- table of powerups
    ['powerups'] = GenerateQuads(gTextures['powerups'], 34, 33),

    -- table of shields
    ['shields'] = GenerateShieldQuads(gTextures['shields']),

    -- table of arrows
    ['arrows'] = GenerateQuads(gTextures['arrows'], 24, 24)
}

gSounds = {
    -- pre-game sounds
    ['fall'] = love.audio.newSource('sounds/fall.wav', 'static'),
    ['rocket'] = love.audio.newSource('sounds/rocket.wav', 'static'),
    ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
    ['no-select'] = love.audio.newSource('sounds/no_select.wav', 'static'),
    ['selected'] = love.audio.newSource('sounds/selected.wav', 'static'),

    -- game sounds: basic
    ['laser1'] = love.audio.newSource('sounds/sfx_laser1.ogg', 'static'),
    ['laser2'] = love.audio.newSource('sounds/sfx_laser2.ogg', 'static'),
    ['burst'] = love.audio.newSource('sounds/burst.wav', 'static'),
    ['hit'] = love.audio.newSource('sounds/hit.wav', 'static'),
    ['shield'] = love.audio.newSource('sounds/shield.wav', 'static'),

    -- game sounds: powerups
    ['heal'] = love.audio.newSource('sounds/heal.wav', 'static'),
    ['pickup'] = love.audio.newSource('sounds/pickup.wav', 'static'),
    ['shieldDown'] = love.audio.newSource('sounds/sfx_shieldDown.ogg', 'static'),
    ['shieldUp'] = love.audio.newSource('sounds/sfx_shieldUp.ogg', 'static'),
    ['bolt'] = love.audio.newSource('sounds/bolt.wav', 'static'),
    
    -- game sounds: others
    ['pause'] = love.audio.newSource('sounds/sfx_twoTone.ogg', 'static'),
    ['lose'] = love.audio.newSource('sounds/lose.wav', 'static'),

    ['music'] = love.audio.newSource('sounds/music.mp3', 'static')
}

-- setting volumes
gSounds['music']:setVolume(0.4)
gSounds['fall']:setVolume(0.5)
gSounds['select']:setVolume(0.5)
gSounds['no-select']:setVolume(0.6)
gSounds['selected']:setVolume(0.4)
gSounds['heal']:setVolume(0.5)
gSounds['pickup']:setVolume(0.6)
gSounds['shield']:setVolume(0.2)
gSounds['lose']:setVolume(0.6)

gFonts = {
    ['small'] = love.graphics.newFont('fonts/kenvector_future_thin.ttf', 12),
    ['thin'] = love.graphics.newFont('fonts/kenvector_future_thin.ttf', 16),
    ['normal'] = love.graphics.newFont('fonts/kenvector_future.ttf', 24),
    ['large'] = love.graphics.newFont('fonts/kenvector_future.ttf', 32),
    ['huge'] = love.graphics.newFont('fonts/kenvector_future.ttf', 48)
}
