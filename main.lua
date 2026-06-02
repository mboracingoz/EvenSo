local Player = require("src/entities/player")
local Enemy = require("src/entities/enemy")

local player
local enemies = {}

function love.load()
    player = Player.new()

    for i = 1,3 do
        table.insert(enemies, Enemy.new())
    end
end

function love.update(dt)
    player:update(dt)

    for i, enemy in ipairs(enemies) do
        enemy:update(dt, player)

         if player.isAttacking and enemy.alive then
            local px = player:getCenterX()
            local py = player:getCenterY()
            if enemy:isInRange(px, py, player.attackRange) then
                enemy:takeDamage(player. attackDamage)
            end
        end
    end
end


function love.draw()
    player:draw()

    for i, enemy in ipairs(enemies) do
        enemy:draw()
    end
end


function love.mousepressed(x, y, button)
    if button == 1 then
        player:attack()
    end
end