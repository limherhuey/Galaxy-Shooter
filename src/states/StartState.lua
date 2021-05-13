StartState = Class{__includes = BaseState}

function StartState:init()
    self.background = Background()

    -- y render positions of meteors
    self.meteorsY = {140, 240, 162, 140, 153, 138, 237, 140}
end

function StartState:update(dt)
    self.background:update(dt)

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        
        gStateMachine:change('start-animation', {
            background = self.background,
            meteorsY = self.meteorsY
        })
    end
end

function StartState:render()
    self.background:render()

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Galaxy Shooter', 0, 76, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['thin'])
    love.graphics.printf('Press Enter to Begin', 0, 280, VIRTUAL_WIDTH, 'center')

    love.graphics.draw(gTextures['meteors'][4], 210, self.meteorsY[1])
    love.graphics.draw(gTextures['meteors'][6], 116, self.meteorsY[2])
    love.graphics.draw(gTextures['meteors'][8], 163, self.meteorsY[3])
    love.graphics.draw(gTextures['meteors'][10], 100, self.meteorsY[4])
    love.graphics.draw(gTextures['meteors'][11], 400, self.meteorsY[5], math.rad(50))
    love.graphics.draw(gTextures['meteors'][15], 480, self.meteorsY[6])
    love.graphics.draw(gTextures['meteors'][17], 506, self.meteorsY[7])
    love.graphics.draw(gTextures['meteors'][19], 340, self.meteorsY[8])
end
