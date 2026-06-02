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

    --spawn
    local side = love.math.random(1, 4)

    if side == 1 then
        self.x = love.math.random(0,1920)
        self.y = -self.height
    elseif side == 2 then
        self.x = love.math.random(0,1920)
        self.y = 1080 + self.height
    elseif side == 3 then
        self.x = -self.width
        self.y = love.math.random(0, 1080)
    else
        self.x = 1920 + self.width
        self.y = love.math.random(0, 1080)
    end

    return self
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
end

function Enemy:draw()
    if not self.alive then return end

    local cx = self.x + self.width / 2
    local cy = self.y + self.height / 2

    love.graphics.push()
        love.graphics.translate(cx, cy)
        love.graphics.rotate(self.angle or 0)  

        love.graphics.setColor(1, 0.2, 0.2)
        love.graphics.rectangle("fill", -self.width/2, -self.height/2, self.width, self.height)

        love.graphics.setColor(0.8, 0.1, 0.1)
        love.graphics.rectangle("fill", self.width/2, -5, 12, 10)

    love.graphics.pop()

    love.graphics.setColor(1, 1, 1)
end

return Enemy