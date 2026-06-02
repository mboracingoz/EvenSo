local Player = {}
Player.__index = Player

function Player.new()
    local self = setmetatable({}, Player)

    self.x = 960
    self.y = 540
    self.width = 32
    self.height = 32
    self.speed = 200


    self.attackRange = 60
    self.attackDamage = 1
    self.isAttacking = false
    self.attackTimer = 0
    self.attackDuration = 0.2

    return self
end


function Player:update(dt)
    if love.keyboard.isDown("w") then self.y = self.y - self.speed * dt end
    if love.keyboard.isDown("s") then self.y = self.y + self.speed * dt end
    if love.keyboard.isDown("a") then self.x = self.x - self.speed * dt end
    if love.keyboard.isDown("d") then self.x = self.x + self.speed * dt end

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

function Player:draw()
    love.graphics.setColor(0.2, 0.6, 1)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    if self.isAttacking then
        love.graphics.setColor(1,1,0,0.3)
        love.graphics.circle("fill", self:getCenterX(), self:getCenterY(), self.attackRange)
    end

    love.graphics.setColor(1,1,1)

    
end

return Player
