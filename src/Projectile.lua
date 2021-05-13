
Projectile = Class{}

function Projectile:init(x, y, colour, type)
    self.x = x
    self.y = y

    -- total 3 colours and 4 types
    self.colour = colour
    self.type = type

    -- dimensions (width depends on type)
    self.height = 9/2
    if self.type == 1 or self.type == 3 then
        self.width = 37/2
    elseif self.type == 2 then
        self.width = 57/2
    else
        self.width = 54/2
    end

    self.remove = false
end

function Projectile:collides(object)
    -- collision logic (given leniency)
    if self.x < object.x + object.width - object.lX * 2 and self.x + self.width > object.x + object.lX and
        self.y < object.y + object.height - object.lY * 2 and self.y + self.height > object.y + object.lY then
            return true
    end

    return false
end

function Projectile:update(dt)
    self.x = self.x + PROJECTILE_SPEED * dt
end

function Projectile:render()
    love.graphics.draw(gTextures['lasers'], gFrames['lasers'][(self.type - 1) * 3 + self.colour],
            self.x, self.y,
            0,  -- no rotation
            0.5, 0.5  --[[ scaled by half on x and y axis ]])

    -- hitbox
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end