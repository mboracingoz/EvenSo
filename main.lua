local Player = require("src/entities/player")
local Enemy = require("src/entities/enemy")
local Base = require("src/entities/base")
local Coin = require("src/entities/coin")

local player
local enemies = {}
local coins = {}
local base 
local totalCoins = 0


local function checkCollision(ax, ay, aw, ah, bx, by, bw, bh)
    return ax < bx + bw and
            ax + aw > bx and
            ay < by + bh and 
            ay + ah > by
end


function love.load()
    base = Base.new()
    player = Player.new()

    for i = 1,3 do
        table.insert(enemies, Enemy.new())
    end
end

function love.update(dt)
    player:update(dt)

    for i, enemy in ipairs(enemies) do
        enemy:update(dt, player)

        if player.isAttacking and enemy.alive and not enemy.hitThisAttack then
            local px = player:getCenterX()
            local py = player:getCenterY()
            if enemy:isInRange(px, py, player.attackRange) then
                enemy:takeDamage(player.attackDamage)
                enemy.hitThisAttack = true

                if not enemy.alive then
                    local cx = enemy.x + enemy.width / 2
                    local cy = enemy.y + enemy.height / 2
                    table.insert(coins, Coin.new(cx, cy))
                end
            end
        end

        if not player.isAttacking then
            enemy.hitThisAttack = false
        end
        
        if enemy.alive and player.alive then
            if checkCollision(enemy.x, enemy.y, enemy.width, enemy.height,
                              player.x, player.y, player.width, player.height) then
                player:takeDamage(0.05)   
            end
        end

        if enemy.alive and base.alive then
            if checkCollision(enemy.x, enemy.y, enemy.width, enemy.height,
                              base.x, base.y, base.width, base.height) then
                base:takeDamage(0.02)      
            end
        end
    end

    for i, coin in ipairs(coins) do
        if not coin.collected then
            if checkCollision(player.x, player.y, player.width, player.height, coin.x, coin.y, coin.width, coin.height) then
                coin.collected = true
                totalCoins = totalCoins + 1 
            end
        end
    end
end


function love.draw()
    base:draw()
    player:draw()

    for i, coin in ipairs(coins) do
        coin:draw()
    end

    for i, enemy in ipairs(enemies) do
        enemy:draw()
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Player HP: "..math.floor(player.hp), 20, 20)
    love.graphics.print("Base HP: "..math.floor(base.hp), 20, 40)
end


function love.mousepressed(x, y, button)
    if button == 1 then
        player:attack()
    end
end