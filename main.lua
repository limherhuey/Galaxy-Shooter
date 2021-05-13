--[[
    Galaxy Shooter
    by Lim Her Huey
    An infinite-scoring 2D shooter game.


    Graphics, fonts, and some sounds by Kenney Vleugels (www.kenney.nl)
    https://opengameart.org/content/space-shooter-redux

    Other sounds: generated with sfxr
    http://drpetter.se/project_sfxr.html

    Music: Lift Off by Jahzzar
    https://freemusicarchive.org/music/Jahzzar/Galaxy/Lift_Off_1082
]]

require 'src/Dependencies'

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Galaxy Shooter')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['start-animation'] = function() return StartAnimationState() end,
        ['select-spacecraft'] = function() return SelectSpacecraftState() end,
        ['select-animation'] = function() return SelectAnimationState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end
    }
    gStateMachine:change('start')

    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    love.keyboard.keysPressed = {}
end

function push.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    love.keyboard.keysPressed[key] = true
end

-- self-declared function to keep track of keys pressed on keyboard
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    gStateMachine:render()
    push:finish()
end