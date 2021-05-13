function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

function GenerateSpacecraftQuads(atlas)
    local tileWidth = 75

    local sheetCounter = 1
    local spritesheet = {}

    for x = 0, 3 do
        spritesheet[sheetCounter] =
            love.graphics.newQuad(x * tileWidth, 0, tileWidth, 99, atlas:getDimensions())
        sheetCounter = sheetCounter + 1
    end

    for x = 0, 3 do
        spritesheet[sheetCounter] =
            love.graphics.newQuad(x * tileWidth, 99, tileWidth, 112, atlas:getDimensions())
        sheetCounter = sheetCounter + 1
    end

    for x = 0, 3 do
        spritesheet[sheetCounter] =
            love.graphics.newQuad(x * tileWidth, 211, tileWidth, 98, atlas:getDimensions())
        sheetCounter = sheetCounter + 1
    end

    return spritesheet
end

function GenerateLifeQuads(atlas)
    local tileHeight = 26

    local sheetCounter = 1
    local spritesheet = {}

    for x = 0, 3 do
        spritesheet[sheetCounter] =
            love.graphics.newQuad(x * 33, 0, 33, tileHeight, atlas:getDimensions())
        sheetCounter = sheetCounter + 1
    end

    for x = 0, 3 do
        spritesheet[sheetCounter] =
            love.graphics.newQuad(x * 37, tileHeight, 37, tileHeight, atlas:getDimensions())
        sheetCounter = sheetCounter + 1
    end

    for x = 0, 3 do
        spritesheet[sheetCounter] =
            love.graphics.newQuad(x * 32, tileHeight * 2, 32, tileHeight, atlas:getDimensions())
        sheetCounter = sheetCounter + 1
    end

    return spritesheet
end

function GenerateShieldQuads(atlas)
    spritesheet = {
        love.graphics.newQuad(0, 0, 109, 133, atlas:getDimensions()),
        love.graphics.newQuad(109, 0, 118, 143, atlas:getDimensions()),
        love.graphics.newQuad(227, 0, 137, 144, atlas:getDimensions())
    }
    
    return spritesheet
end

function GenerateLaserQuads(atlas)
    local tileHeight = 9

    local sheetCounter = 1
    local spritesheet = {}

    for x = 0, 2 do
        spritesheet[sheetCounter] =
            love.graphics.newQuad(x * 37, 0, 37, tileHeight, atlas:getDimensions())
        sheetCounter = sheetCounter + 1
    end

    for x = 0, 2 do
        spritesheet[sheetCounter] =
            love.graphics.newQuad(x * 57, tileHeight, 57, tileHeight, atlas:getDimensions())
        sheetCounter = sheetCounter + 1
    end

    for x = 0, 2 do
        spritesheet[sheetCounter] =
            love.graphics.newQuad(x * 37, tileHeight * 2, 37, tileHeight, atlas:getDimensions())
        sheetCounter = sheetCounter + 1
    end

    for x = 0, 2 do
        spritesheet[sheetCounter] =
            love.graphics.newQuad(x * 54, tileHeight * 3, 54, tileHeight, atlas:getDimensions())
        sheetCounter = sheetCounter + 1
    end

    return spritesheet
end