local Player = require("src/entities/player")
local player

function love.load()
    player = Player.new()
end

function love.update(dt)
    player:update(dt)
end


function love.draw()
    player:draw()
end