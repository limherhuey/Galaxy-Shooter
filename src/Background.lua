
Background = Class{}

function Background:init(animated, background, xOffset)
    self.background = background or BACKGROUND_TYPES[math.random(#BACKGROUND_TYPES)]

    self.width = gTextures[self.background]:getWidth()

    -- for scrolling
    self.xOffset = xOffset or 0

    -- whether this is a background for animation purposes (see SelectAnimationState)
    self.animated = animated or false
end

function Background:update(dt)
    if self.animated then
        -- move at much faster speed, and skip over the normal background update
        self.xOffset = (self.xOffset + BACKGROUND_ANIMATED_SCROLL_SPEED * dt) % (self.width / 2)
        return
    end

    -- background scrolling
    self.xOffset = (self.xOffset + BACKGROUND_SCROLL_SPEED * dt) % (self.width / 2)
end

function Background:render()
    love.graphics.draw(gTextures[self.background], -self.xOffset, 0)
end