local Enemy = {}
Enemy.__index = Enemy

function Enemy.new()
    local self = setmetatable({}, Enemy)

    self.width = 32
    self.height = 32
    self.speed = 100
    self.hp = 3
    self.alive = true
    self.hitThisAttack = false
    self.angle = 0
    self.isAttacking = false
    self.attackTimer = 0
    self.attackDuration = 0.35

    self.flashTimer = 0
    self.flashDuration = 0.1    

    local side = love.math.random(1, 4)
    if side == 1 then
        self.x = love.math.random(0, 1280)
        self.y = -self.height
    elseif side == 2 then
        self.x = love.math.random(0, 1280)
        self.y = 720 + self.height
    elseif side == 3 then
        self.x = -self.width
        self.y = love.math.random(0, 720)
    else
        self.x = 1280 + self.width
        self.y = love.math.random(0, 720)
    end

    return self
end


function Enemy:flash()
    self.flashTimer = self.flashDuration
end

function Enemy:update(dt, player)
    if not self.alive then return end

    local dx = player.x - self.x
    local dy = player.y - self.y
    local dist = math.sqrt(dx * dx + dy * dy)

    if dist > 0 then
        self.x = self.x + (dx / dist) * self.speed * dt
        self.y = self.y + (dy / dist) * self.speed * dt
        self.angle = math.atan2(dy, dx)
    end

    if self.attackTimer and self.attackTimer > 0 then
        self.attackTimer = self.attackTimer - dt
        if self.attackTimer <= 0 then
            self.isAttacking = false    -- saldırı bitti, sıfırla
        end
    end

    if self.flashTimer > 0 then
        self.flashTimer = self.flashTimer - dt
    end

    if dist < 80 then
        if not self.isAttacking then
            self.isAttacking = true
            self.attackTimer = 0.35
        end
    end
end

function Enemy:takeDamage(amount)
    self.hp = self.hp - amount
    if self.hp <= 0 then
        self.alive = false
    end
end

function Enemy:isInRange(px, py, range)
    local cx = self.x + self.width / 2
    local cy  = self.y + self.height / 2
    local dist = math.sqrt((cx - px)^2 + (cy - py )^2)
    return dist <= range
end


function Enemy:draw()
    if not self.alive then return end

    local cx = self.x + self.width / 2
    local cy = self.y + self.height / 2

    local swordAngle = 0
    if self.isAttacking then
        local progress = 1 - (self.attackTimer / self.attackDuration)
        local eased = progress * progress * (3 - 2 * progress)
        swordAngle = math.rad(-75 + eased * 150)
    end

    love.graphics.push()
        love.graphics.translate(cx, cy)         
        love.graphics.rotate(self.angle or 0)   

        if self.flashTimer > 0 then
            love.graphics.setColor(1, 1, 1)
        else
            love.graphics.setColor(1, 0.2, 0.2)
        end
        love.graphics.rectangle("fill", -self.width/2, -self.height/2, self.width, self.height)

        love.graphics.push()
            love.graphics.rotate(swordAngle)
            love.graphics.setColor(0.8, 0.1, 0.1)
            love.graphics.rectangle("fill", self.width/2, -5, 12, 10)
        love.graphics.pop()

    love.graphics.pop()

    love.graphics.setColor(1, 1, 1)
end
return Enemy