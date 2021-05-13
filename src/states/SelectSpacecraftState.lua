SelectSpacecraftState = Class{__includes = BaseState}

function SelectSpacecraftState:init()
    self.currentSpacecraft = 1
end

function SelectSpacecraftState:enter(def)
    self.background = def.background
end

function SelectSpacecraftState:update(dt)
    self.background:update(dt)

    -- selection controls
    if love.keyboard.wasPressed('left') then
        if self.currentSpacecraft == 1 then
            gSounds['no-select']:play()
        else
            gSounds['select']:play()
            self.currentSpacecraft = self.currentSpacecraft - 1
        end
    elseif love.keyboard.wasPressed('right') then
        if self.currentSpacecraft == 12 then
            gSounds['no-select']:play()
        else
            gSounds['select']:play()
            self.currentSpacecraft = self.currentSpacecraft + 1
        end
    end

    -- choose selection
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['selected']:play()
        
        gStateMachine:change('select-animation', {
            background = self.background,
            spacecraft = self.currentSpacecraft
        })
    end
end

function SelectSpacecraftState:render()
    love.graphics.setColor(1, 1, 1, 1)

    self.background:render()
    
    -- instructions
    love.graphics.setFont(gFonts['normal'])
    love.graphics.printf('Select your spacecraft!', 0, 68, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("Navigate with left and right arrows", 0, 100, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press Enter to choose", 0, 114, VIRTUAL_WIDTH, 'center')

    -- spacecraft
    love.graphics.draw(gTextures['spacecrafts'], gFrames['spacecrafts'][self.currentSpacecraft], VIRTUAL_WIDTH / 2 - 22, 190, 0, 0.5, 0.5)
        
    -- left arrow darker and translucent if at extreme left
    if self.currentSpacecraft == 1 then
        love.graphics.setColor(0.594, 0.594, 0.594, 0.716)
    end
    
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], VIRTUAL_WIDTH / 4 - 24, 204)

    -- reset colour
    love.graphics.setColor(1, 1, 1, 1)

    -- right arrow darker and translucent if at extreme right
    if self.currentSpacecraft == 12 then
        love.graphics.setColor(0.594, 0.594, 0.594, 0.716)
    end
    
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], VIRTUAL_WIDTH - VIRTUAL_WIDTH / 4, 204)
end
