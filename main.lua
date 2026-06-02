local Player = require("src/entities/player")
local Enemy = require("src/entities/enemy")
local Base = require("src/entities/base")
local Coin = require("src/entities/coin")
local Hud = require("src/ui/hud")


local player
local enemies = {}
local coins = {}
local base 
local totalCoins = 0
local hud
local shakeTimer = 0
local shakeDuration = 0
local shakeMagnitude = 0


local function startShake(duration, magnitude)
    shakeTimer = duration
    shakeDuration = duration
    shakeMagnitude = magnitude
end

local function checkCollision(ax, ay, aw, ah, bx, by, bw, bh)
    return ax < bx + bw and
            ax + aw > bx and
            ay < by + bh and 
            ay + ah > by
end


function love.load()
    base = Base.new()
    player = Player.new()
    hud = Hud.new()

    for i = 1,3 do
        table.insert(enemies, Enemy.new())
    end
end

function love.update(dt)
    if shakeTimer > 0 then
        shakeTimer = shakeTimer - dt
    end

    if not player.alive then return end

    player:update(dt)

    for i, enemy in ipairs(enemies) do
        enemy:update(dt, player)

        if player.isAttacking and enemy.alive and not enemy.hitThisAttack then
            local px = player:getCenterX()
            local py = player:getCenterY()
            if enemy:isInRange(px, py, player.attackRange) then
                enemy:takeDamage(player.attackDamage)
                enemy:flash()             
                startShake(0.15,4)
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
                player:applyKnockback(enemy.x, enemy.y)
                startShake(0.2, 0.7)
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
            if checkCollision(player.x, player.y, player.width, player.height,
                              coin.x, coin.y, coin.width, coin.height) then
                coin.collected = true
                totalCoins = totalCoins + 1
            end
        end
    end
end

function love.draw()
    local ox, oy = 0, 0
    if shakeTimer > 0 then
        local progress = shakeTimer / shakeDuration
        ox = love.math.random(-shakeMagnitude, shakeMagnitude) * progress
        oy = love.math.random(-shakeMagnitude, shakeMagnitude) * progress
    end

    love.graphics.push()
    love.graphics.translate(ox, oy)

    base:draw()
    player:draw()

    for i, coin in ipairs(coins) do
        coin:draw()
    end

    for i, enemy in ipairs(enemies) do
        enemy:draw()
    end

    love.graphics.pop()

    hud:draw(player, totalCoins)

    if not player.alive then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, 1280, 720)

        love.graphics.setColor(1, 0.2, 0.2)
        love.graphics.print("YOUR DIE!", 580, 320)

        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Please press the button R - Try Again", 500, 370)
    end
end

function love.keypressed(key)
    if key == "lshift" then
        local moveX = 0
        local moveY = 0
        if love.keyboard.isDown("w") then moveY = -1 end
        if love.keyboard.isDown("s") then moveY =  1 end
        if love.keyboard.isDown("a") then moveX = -1 end
        if love.keyboard.isDown("d") then moveX =  1 end
        player:dash(moveX, moveY)
    end


    if key == "r" and not player.alive then
        player = Player.new()
        enemies = {}
        coins = {}
        totalCoins = 0
        base = Base.new()

        for i = 1, 3 do
            table.insert(enemies, Enemy.new())
        end
    end
end


function love.mousepressed(x, y, button)
    if button == 1 then
        player:attack()
    end
end