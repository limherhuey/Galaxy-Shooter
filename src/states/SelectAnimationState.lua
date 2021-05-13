SelectAnimationState = Class{__includes = BaseState}

function SelectAnimationState:init()
    self.selectionAlpha1 = 1
    self.selectionAlpha2 = 0.716

    self.animBg = false

    self.spacecraftX = VIRTUAL_WIDTH / 2 - 22
end

function SelectAnimationState:enter(def)
    self.background = def.background
    self.spacecraft = def.spacecraft

    -- fade text and arrows out
    Timer.tween(0.8, {
        [self] = {selectionAlpha1 = 0, selectionAlpha2 = 0}
    })

    :finish(function()
        -- animate faster background
        self.animBackground = Background(true, self.background.background, self.background.xOffset)
        self.animBg = true

        gSounds['rocket']:stop()
        gSounds['rocket']:play()

        -- move spacecraft to the left side to ready for gameplay
        Timer.tween(1.2, {
            [self] = {spacecraftX = 18}
        })

        -- afterwards enter play state
        :finish(function()               
            gStateMachine:change('play', {
                -- new normal background continue from where animated one left off
                background = Background(false, self.background.background, self.animBackground.xOffset),
                
                player = Spacecraft(self.spacecraft)
            })
        end)
    end)
end

function SelectAnimationState:update(dt)
    Timer.update(dt)

    if self.animBg then
        self.animBackground:update(dt)
    else
        self.background:update(dt)
    end
end

function SelectAnimationState:render()
    love.graphics.setColor(1, 1, 1, 1)

    if self.animBg then
        self.animBackground:render()
    else
        self.background:render()
    end

    -- spacecraft
    love.graphics.draw(gTextures['spacecrafts'], gFrames['spacecrafts'][self.spacecraft], self.spacecraftX, 190, 0, 0.5, 0.5)
        
    -- for fading out effect
    love.graphics.setColor(1, 1, 1, self.selectionAlpha1)

    -- instructions
    love.graphics.setFont(gFonts['normal'])
    love.graphics.printf('Select your spacecraft!', 0, 68, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("Navigate with left and right arrows", 0, 100, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press Enter to choose", 0, 114, VIRTUAL_WIDTH, 'center')

    -- left arrow darker and translucent if at extreme left
    if self.spacecraft == 1 then
        love.graphics.setColor(0.594, 0.594, 0.594, self.selectionAlpha2)
    end
    
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], VIRTUAL_WIDTH / 4 - 24, 204)

    -- reset colour
    love.graphics.setColor(1, 1, 1, self.selectionAlpha1)

    -- right arrow darker and translucent if at extreme right
    if self.spacecraft == 12 then
        love.graphics.setColor(0.594, 0.594, 0.594, self.selectionAlpha2)
    end
    
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], VIRTUAL_WIDTH - VIRTUAL_WIDTH / 4, 204)
end
