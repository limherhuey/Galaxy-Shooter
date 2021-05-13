
Spacecraft = Class{}

function Spacecraft:init(skin)
    self.x = 18
    self.y = 190

    self.dy = 0

    self.health = 3

    -- the skin is the spacecraft chosen by the player
    self.skin = skin

    -- type is the model of the spacecraft (3 in total); colour is its colour (4 in total)
    self.type = math.ceil(self.skin / 4)
    self.colour = self.skin % 4 == 0 and 4 or self.skin % 4

    -- projectile colour (red and orange will both be red); 
    self.pcolour = self.colour == 4 and 3 or self.colour

    -- dimensions (height depend on type)
    self.width = 75/2
    if self.type == 1 then
        self.height = 99/2 
    elseif self.type == 2 then
        self.height = 112/2
    else
        self.height = 98/2
    end

    -- whether shield is active & shield active time
    self.shield = false
    self.shieldTime = 5

    -- if negative, is additional width and height to the spacecraft
    -- 2 and 3 when shield not active, negative when shield is active
    self.addW = 2
    self.addH = 3
end

function Spacecraft:collides(object)
    -- collision logic (with leniency given to the hurt and hitboxes)
    if self.x + self.addW < object.x + object.width - object.lX * 2 and
        self.x + self.width - self.addW * 2 > object.x + object.lX and
            self.y + self.addH < object.y + object.height - object.lY * 2 and
                self.y + self.height - self.addH * 2 > object.y + object.lY then
        return true
    end

    return false
end

function Spacecraft:deductHealth(deduction, playState)
    if self.health > deduction then
        self.health = self.health - deduction
    else
        -- game over
        self.health = 0
        playState:gameOver()
    end
end

function Spacecraft:update(dt)
    -- keyboard controls
    if love.keyboard.isDown('up') then
        self.dy = -SPACECRAFT_SPEED
    elseif love.keyboard.isDown('down') then
        self.dy = SPACECRAFT_SPEED
    else
        self.dy = 0
    end

    -- make sure spacecraft does not go beyond screen dimensions
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end
end

function Spacecraft:render()
    love.graphics.draw(gTextures['spacecrafts'], gFrames['spacecrafts'][self.skin], self.x, self.y,
        0,  -- no rotation
            0.5, 0.5  --[[ scaled by half on x and y axis ]])

    if self.shield then
        love.graphics.draw(gTextures['shields'], gFrames['shields'][1], self.x - 3, self.y + self.addH,
            0,  -- no rotation
                0.52, 0.52  --[[ scaled by half on x and y axis ]])
    end
    
    -- hurtbox
    -- love.graphics.rectangle('line', self.x + self.addW, self.y + self.addH,
    --         self.width - self.addW * 2, self.height - self.addH * 2)
end

function Spacecraft:activateShield()
    gSounds['shieldUp']:play()
    
    self.shield = true

    -- expand hurtbox
    self.addW = -8
    if self.type == 2 then
        -- type 2 is larger so don't need to expand as much
        self.addH = -6
    else
        self.addH = -9
    end
end

function Spacecraft:deactivateShield()
    gSounds['shieldDown']:play()

    self.shield = false

    -- return hurtbox to normal
    self.addW = 2
    self.addH = 3
end