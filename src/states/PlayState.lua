PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.paused = false
    self.score = 0

    self.projectiles = {}
    self.meteors = {}
    self.powerups = {}

    -- meteor utilities
    self.mTimer = 0         -- spawn timer
    self.mInterval = 1.2    -- spawn interval
    self.mvMin = 80         -- min velocity
    self.mvMax = 120        -- max velocity
    self.mIncTimer = 0      -- timer for increase in spawn rate and velocity
    self.mIncrement = 10    -- interval for increase in spawn rate and velocity

    -- powerup utilities
    self.pTimer = 0         -- spawn timer
    self.pInterval = 6      -- spawn interval
    self.boltAlpha = 0      -- for bolt's flash

    -- game over utilities
    self.r, self.g, self.b = 1, 1, 1
    self.over = false
end

function PlayState:enter(def)
    self.background = def.background
    self.player = def.player
end

function PlayState:update(dt)
    -- pause logic
    if self.paused then
        if love.keyboard.wasPressed('p') then
            gSounds['pause']:stop()
            gSounds['pause']:play()
            self.paused = false
        else
            -- don't update game if paused
            return
        end
    elseif love.keyboard.wasPressed('p') then
        gSounds['pause']:stop()
        gSounds['pause']:play()
        self.paused = true
        return
    end

    Timer.update(dt)

    self.background:update(dt)

    if self.over then
        return
    end

    -- meteors
    self.mTimer = self.mTimer + dt
    self.mIncTimer = self.mIncTimer + dt

    -- spawn a meteor
    if self.mTimer > self.mInterval then
        self.mTimer = self.mTimer % self.mInterval
        
        table.insert(self.meteors, Meteor(math.random(self.mvMin, self.mvMax)))
    end

    -- increase spawn rate and velocity of meteors as game progresses for added difficulty
    if self.mIncTimer > self.mIncrement then
        self.mIncTimer = self.mIncTimer % self.mIncrement

        self.mIncrement = math.max(5.5, self.mIncrement / 1.025)

        self.mInterval = math.max(0.3, self.mInterval / 1.03)
        self.mvMin = math.min(400, self.mvMin * 1.08)
        self.mvMax = math.min(600, self.mvMax * 1.08)
    end

    -- powerups
    self.pTimer = self.pTimer + dt

    if self.pTimer > self.pInterval then
        self.pTimer = self.pTimer % self.pInterval
        
        -- chance for a powerup
        local powerupType = 0
        if math.random(5) == 1 then
            powerupType = 1
        elseif math.random(5) == 1 then
            powerupType = 2
        elseif math.random(4) == 1 then
            powerupType = 3
        elseif math.random(4) == 1 then
            powerupType = 4
        end
        
        if powerupType ~= 0 then
            table.insert(self.powerups, Powerup(self.player.colour, powerupType,
                -- speed similar to meteors'
                math.random(self.mvMin, self.mvMax)))
        end
    end

    self.player:update(dt)

    -- player shoots
    if love.keyboard.wasPressed('space') then
        gSounds['laser1']:stop()
        gSounds['laser2']:stop()
        gSounds['laser1']:play()
        gSounds['laser2']:play()

        table.insert(self.projectiles, 
            Projectile(self.player.x + self.player.width - 5, self.player.y + self.player.height / 2 - 4.5,
                    self.player.pcolour, 4))
    end
    
    for k, projectile in pairs(self.projectiles) do
        projectile:update(dt)

        -- label to remove if beyond right edge of screen, and deduct 1 from score for inaccuracy
        if projectile.x > VIRTUAL_WIDTH then
            projectile.remove = true

            self.score = self.score - 1

            -- -1 health if score is negative, and reset score to 0
            if self.score < 0 then
                self.score = 0
                self.player:deductHealth(1, self)
            end
        end
    end

    for k, powerup in pairs(self.powerups) do
        powerup:update(dt)

        -- test if player successfully collected powerup
        if self.player:collides(powerup) then
            -- apply powerup
            powerup:collect(self)
        end
    end

    for k, meteor in pairs(self.meteors) do
        meteor:update(dt)

        -- test if projectile hits meteor
        for k1, projectile in pairs(self.projectiles) do
            if projectile:collides(meteor) and not projectile.remove and not meteor.remove then
                gSounds['burst']:stop()
                gSounds['burst']:play()
                
                meteor.remove = true
                projectile.remove = true

                self.score = self.score + meteor.scoreAward
            end
        end

        -- test if meteor hits spacecraft
        if self.player:collides(meteor) and not meteor.remove then
            if self.player.shield then
                gSounds['shield']:stop()
                gSounds['shield']:play()

                -- with shield, player is safe and meteor will be destructed, but no score added
                meteor.remove = true
            else
                gSounds['hit']:stop()
                gSounds['hit']:play()

                -- -1 from health if hit
                self.player:deductHealth(1, self)

                if self.player.health ~= 0 then
                    meteor.remove = true
                end
            end
        end

        -- label to remove if beyond left edge of screen, and deduct score
        if meteor.x + meteor.width < 0 then
            meteor.remove = true

            self.score = self.score - meteor.scoreDeduction
            
            -- -1 health if score is negative and reset score to 0
            if self.score < 0 then
                self.score = 0
                self.player:deductHealth(1, self)
            end
        end
    end

    -- delete objects in separate loops rather than the previous since keys (numerical indices) will
    -- automatically be shifted down after a key-value removal, resulting in skipping objects while updating
    for k, projectile in pairs(self.projectiles) do
        if projectile.remove then
            table.remove(self.projectiles, k)
        end
    end

    for k, meteor in pairs(self.meteors) do
        if meteor.remove then
            table.remove(self.meteors, k)
        end
    end

    for k, powerup in pairs(self.powerups) do
        if powerup.remove then
            table.remove(self.powerups, k)
        end
    end
end

function PlayState:render()
    love.graphics.setColor(self.r, self.g, self.b, 1)
    
    self.background:render()
    self.player:render()

    for k, projectile in pairs(self.projectiles) do
        projectile:render()
    end

    for k, meteor in pairs(self.meteors) do
        meteor:render()
    end

    for k, powerup in pairs(self.powerups) do
        powerup:render()
    end

    -- draw health
    local healthLeft = self.player.health

    for i = 1, 3 do
        if healthLeft < 1 then
            -- draw a darker and more transparent version if not an existing health
            love.graphics.setColor(0.3, 0.3, 0.3, 0.7)
        end

        love.graphics.draw(gTextures['lives'], gFrames['lives'][self.player.skin],
            396 + (i - 1) * 28, 6, 0, 0.7, 0.7)
        
        healthLeft = healthLeft - 1
    end

    love.graphics.setColor(self.r, self.g, self.b, 1)

    -- render score
    love.graphics.setFont(gFonts['thin'])
    love.graphics.print("Score: " .. tostring(self.score), VIRTUAL_WIDTH - 120, 5)

    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 20, VIRTUAL_WIDTH, 'center')
    end

    -- bolt's flash
    love.graphics.setColor(1, 1, 1, self.boltAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

-- bolt powerup: destroys all meteors in the game with a flash
function PlayState:bolt()
    gSounds['bolt']:play()

    -- quick flash
    Timer.tween(0.03, {
        [self] = {boltAlpha = 1}
    })
    :finish(function()
        -- remove all meteors currently in the game and add to score
        for k, meteor in pairs(self.meteors) do
            meteor.remove = true
            self.score = self.score + meteor.scoreAward
        end

        -- flash fades out
        Timer.tween(0.54, {
            [self] = {boltAlpha = 0}
        })
    end)
end

function PlayState:gameOver()
    -- 'pause' game
    gSounds['lose']:play()
    self.over = true 

    -- render the screen red
    Timer.tween(1.14, {
        [self] = {r = 1, g = 0.4, b = 0.4}
    })

    -- afterwards, transition to game over state
    :finish(function()
        Timer.after(0.36, function()
            gStateMachine:change('game-over', {
                background = self.background,
                score = self.score
            })
        end)        
    end)
end