
Meteor = Class{}

function Meteor:init(dx)

    -- random colour (2 in total) and type (10 in total)
    self.colour = math.random(2)
    self.type = math.random(10)

    self.skin = self.colour == 1 and self.type or self.type + 10

    -- dimensions depend on type // lX and lY are leniency given to their hurt and hit boxes
    self.width, self.height, self.lX, self.lY = self:getDimensions()

    self.dx = dx

    -- randomly spawn in a location beyond right edge of screen
    self.x = VIRTUAL_WIDTH
    if self.type >= 7 then
        -- prevent small meteors to be out of reach of player's lasers at extreme top or bottom
        self.y = math.random(15, VIRTUAL_HEIGHT - self.height - 15)
    else
        self.y = math.random(0, VIRTUAL_HEIGHT - self.height)
    end

    -- how much to add/deduct from player's score when destroyed meteor / meteor passes left edge of screen
    self.scoreAward = self:getScoreAward()
    self.scoreDeduction = self:getScoreDeduction()

    self.remove = false
end

function Meteor:update(dt)
    self.x = self.x - self.dx * dt
end

function Meteor:render()
    love.graphics.draw(gTextures['meteors'][self.skin], self.x, self.y)
    
    --hit/hurt box
    -- love.graphics.rectangle('line', self.x + self.lX, self.y + self.lY, self.width - self.lX * 2, self.height - self.lY * 2)
end

-- returns the dimensions of each type of meteor
function Meteor:getDimensions()
    if self.type == 1 then
        return 101, 84, 12, 4
    elseif self.type == 2 then
        return 120, 98, 13, 6
    elseif self.type == 3 then
        return 89, 82, 9, 6
    elseif self.type == 4 then
        return 98, 96, 12, 8
    elseif self.type == 5 then
        return 43, 43, 6, 4
    elseif self.type == 6 then
        return 45, 40, 6, 4
    elseif self.type == 7 then
        return 28, 28, 4, 2
    elseif self.type == 8 then
        return 29, 26, 3, 2
    elseif self.type == 9 then
        return 18, 18, 3, 1
    else
        return 16, 15, 3, 0
    end
end

function Meteor:getScoreAward()
    -- smaller meteors are harder to hit, so higher award
    if self.type <= 4 then
        return 1
    elseif self.type <= 6 then
        return 2
    elseif self.type <= 8 then
        return 3
    else
        return 4
    end
end

function Meteor:getScoreDeduction()
    -- larger meteors are easier to hit, so larger penalty for letting pass
    if self.type <= 4 then
        return 8
    elseif self.type <= 6 then
        return 5
    elseif self.type <= 8 then
        return 3
    else
        return 1
    end
end