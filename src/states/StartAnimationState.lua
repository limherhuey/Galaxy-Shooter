StartAnimationState = Class{__includes = BaseState}

function StartAnimationState:init()
    self.textAlpha = 1
    
    self.spacecraftX = -60

    self.selectionAlpha = 0
    self.selectionAlpha_leftarrow = 0

    -- a bool to prevent changing back to select-spacecraft state again if user skipped animations already
    self.changedState = false
end

function StartAnimationState:enter(def)
    self.background = def.background
    self.meteorsY = def.meteorsY

    -- gradually fade out text
    Timer.tween(0.7, {
        [self] = {textAlpha = 0}
    })

    -- then make meteors 'fall' out of screen 
    :finish(function()
        Timer.tween(0.27, {
            [self.meteorsY] = {[3] = VIRTUAL_HEIGHT}
        })
        :finish(function()
            self:fallSound()
            Timer.tween(0.27, {
                [self.meteorsY] = {[8] = VIRTUAL_HEIGHT}
            })
            :finish(function()
                Timer.tween(0.25, {
                    [self.meteorsY] = {[4] = VIRTUAL_HEIGHT}
                })
                :finish(function()
                    self:fallSound()
                    Timer.tween(0.24, {
                        [self.meteorsY] = {[7] = VIRTUAL_HEIGHT}
                    })
                    :finish(function()
                        Timer.tween(0.23, {
                            [self.meteorsY] = {[6] = VIRTUAL_HEIGHT}
                        })
                        :finish(function()
                            self:fallSound()
                            Timer.tween(0.23, {
                                [self.meteorsY] = {[2] = VIRTUAL_HEIGHT}
                            })
                            :finish(function()
                                Timer.tween(0.22, {
                                    [self.meteorsY] = {[5] = VIRTUAL_HEIGHT}
                                })
                                :finish(function()
                                    self:fallSound()
                                    Timer.tween(0.22, {
                                        [self.meteorsY] = {[1] = VIRTUAL_HEIGHT}
                                    })

                                    -- first spacecraft flying in
                                    :finish(function()
                                        self:rocketSound()
                                        Timer.tween(0.68, {
                                            [self] = {spacecraftX = VIRTUAL_WIDTH / 2 - 22}
                                        })

                                        -- new text and arrows appear
                                        :finish(function()
                                            Timer.tween(1, {
                                                [self] = {selectionAlpha = 1, selectionAlpha_leftarrow = 0.716}
                                            })

                                            -- change to select state
                                            :finish(function()
                                                if not self.changedState then
                                                    gStateMachine:change('select-spacecraft', {
                                                        background = self.background
                                                    })
                                                end
                                            end)
                                        end)
                                    end)
                                end)
                            end)
                        end)
                    end)
                end)
            end)
        end)
    end)
end

function StartAnimationState:update(dt)
    Timer.update(dt)

    self.background:update(dt)

    -- to skip all the animation
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        self.changedState = true

        gStateMachine:change('select-spacecraft', {
            background = self.background
        })
    end
end

function StartAnimationState:render()
    self.background:render()

    -- items from start screen
    love.graphics.setColor(1, 1, 1, self.textAlpha)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Galaxy Shooter', 0, 76, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['thin'])
    love.graphics.printf('Press Enter to Begin', 0, 280, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gTextures['meteors'][4], 210, self.meteorsY[1])
    love.graphics.draw(gTextures['meteors'][6], 116, self.meteorsY[2])
    love.graphics.draw(gTextures['meteors'][8], 163, self.meteorsY[3])
    love.graphics.draw(gTextures['meteors'][10], 100, self.meteorsY[4])
    love.graphics.draw(gTextures['meteors'][11], 400, self.meteorsY[5], math.rad(50))
    love.graphics.draw(gTextures['meteors'][15], 480, self.meteorsY[6])
    love.graphics.draw(gTextures['meteors'][17], 506, self.meteorsY[7])
    love.graphics.draw(gTextures['meteors'][19], 340, self.meteorsY[8])

    -- spacecraft
    love.graphics.draw(gTextures['spacecrafts'], gFrames['spacecrafts'][1], self.spacecraftX, 190, 0, 0.5, 0.5)

    love.graphics.setColor(1, 1, 1, self.selectionAlpha)

    -- instructions
    love.graphics.setFont(gFonts['normal'])
    love.graphics.printf('Select your spacecraft!', 0, 68, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("Navigate with left and right arrows", 0, 100, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press Enter to choose", 0, 114, VIRTUAL_WIDTH, 'center')

    -- arrows
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], VIRTUAL_WIDTH - VIRTUAL_WIDTH / 4, 204)

    love.graphics.setColor(0.594, 0.594, 0.594, self.selectionAlpha_leftarrow)
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], VIRTUAL_WIDTH / 4 - 24, 204)
end

function StartAnimationState:fallSound()
    if not self.changedState then
        gSounds['fall']:stop()
        gSounds['fall']:play()
    end
end

function StartAnimationState:rocketSound()
    if not self.changedState then
        gSounds['rocket']:play()
    end
end