local Player = {}
Player.__index = Player

function Player.new()
    local self = setmetatable({}, Player)

    self.x = 960
    self.y = 540
    self.width = 32
    self.height = 32
    self.speed = 200
    self.hp = 5
    self.maxHp = 5
    self.alive = true

    self.angle = 0
    self.dirX = 0
    self.dirY = 1

    self.attackRange = 60
    self.attackDamage = 1
    self.isAttacking = false
    self.attackTimer = 0
    self.attackDuration = 0.35

    self.flashTimer = 0
    self.flashDuration = 0.15
    return self
end

function Player:takeDamage(amount)
    self.hp = math.max(0, self.hp - amount)
    self:flash()
    if self.hp <= 0 then
        self.alive = false
    end
end

function Player:update(dt)
    local moveX = 0
    local moveY = 0

    if love.keyboard.isDown("w") then moveY = -1 end
    if love.keyboard.isDown("s") then moveY =  1 end
    if love.keyboard.isDown("a") then moveX = -1 end
    if love.keyboard.isDown("d") then moveX =  1 end

    if moveX ~= 0 or moveY ~= 0 then
        self.angle = math.atan2(moveY, moveX)
    end

    self.x = self.x + moveX * self.speed * dt
    self.y = self.y + moveY * self.speed * dt

    if self.flashTimer > 0 then
        self.flashTimer = self.flashTimer - dt
    end

    if self.isAttacking then
        self.attackTimer = self.attackTimer - dt
        if self.attackTimer <= 0 then
            self.isAttacking = false
        end
    end
end

function Player:attack()
    if not self.isAttacking then
        self.isAttacking = true
        self.attackTimer = self.attackDuration
    end
end

function Player:getCenterX () return self.x + self.width / 2 end
function Player:getCenterY () return self.y + self.height / 2 end

function Player:flash()
    self.flashTimer = self.flashDuration
end

function Player:draw()
    local cx = self:getCenterX()
    local cy = self:getCenterY()

    love.graphics.push()
        love.graphics.translate(cx, cy)
        love.graphics.rotate(self.angle)

        local swordAngle = 0
        if self.isAttacking then
            local progress = 1 - (self.attackTimer / self.attackDuration)
            local eased = progress * progress * (3 - 2 * progress)
            swordAngle = math.rad(-75 + progress * 150) 
        end

        love.graphics.push()
            love.graphics.rotate(swordAngle)

            if self.isAttacking then
                love.graphics.setColor(1, 1, 0.5)
            else
                love.graphics.setColor(0.8, 0.8, 0.8)
            end
            love.graphics.rectangle("fill", self.width/2, -3, 24, 6)
        love.graphics.pop()


        if self.flashTimer > 0 then
            love.graphics.setColor(1, 0.2, 0.2)    -- Kırmızı flash
        else
            love.graphics.setColor(0.2, 0.6, 1)    -- Normal mavi
        end
        love.graphics.rectangle("fill", -self.width/2, -self.height/2, self.width, self.height)

    love.graphics.pop()

    love.graphics.setColor(1, 1, 1)
end

return Player