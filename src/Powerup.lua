
Powerup = Class{}

function Powerup:init(colour, type, dx)

    -- colour depends on the colour of player's chosen spacecraft
    self.colour = colour

    -- 4 types in total: blank, bolt, shield, star
    self.type = type

    -- dimensions
    self.width = 34/2
    self.height = 33/2
    self.lX, self.lY = 0, 0

    -- randomly spawn in a location beyond right edge of screen
    self.x = VIRTUAL_WIDTH
    self.y = math.random(0, VIRTUAL_HEIGHT - self.height)

    self.dx = -dx
    
    self.remove = false
end

function Powerup:collect(playState)
    self.remove = true

    if self.type == 1 then
        -- score reward
        gSounds['pickup']:play()
        playState.score = playState.score + 10
    elseif self.type == 2 then
        -- bolt
        playState:bolt()
    elseif self.type == 3 then
        -- shield
        playState.player:activateShield()

        -- when shield expires, remove shield
        Timer.after(playState.player.shieldTime, function()
            playState.player:deactivateShield()
        end)
    else
        -- heal
        gSounds['heal']:play()
        if playState.player.health < 3 then
            playState.player.health = playState.player.health + 1
        end
    end
end

function Powerup:update(dt)
    self.x = self.x + self.dx * dt

    -- label for removal when past the screen's left edge
    if self.x + self.width < 0 then
        self.remove = true
    end
end

function Powerup:render()
    love.graphics.draw(gTextures['powerups'], gFrames['powerups'][(self.colour - 1) * 4 + self.type],
        self.x, self.y,
            0,  -- no rotation
            0.5, 0.5  --[[ scaled by half on x and y axis ]])
end