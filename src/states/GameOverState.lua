GameOverState = Class{__includes = BaseState}

function GameOverState:init()

end

function GameOverState:enter(def)
    self.background = def.background
    self.score = def.score
end

function GameOverState:update(dt)
    self.background:update(dt)

    -- return to title screen / main menu
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('start')
    end
end

function GameOverState:render()
    love.graphics.setColor(1, 1, 1, 1)

    self.background:render()

    love.graphics.setFont(gFonts['huge'])
    love.graphics.printf('Game Over!', 0, 114, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['normal'])
    love.graphics.printf("Score: " .. tostring(self.score), 0, 174, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press Enter to return to the Title Screen', 0, 254, VIRTUAL_WIDTH, 'center')
end