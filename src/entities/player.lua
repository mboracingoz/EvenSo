local Player = {}
Player.__index = Player

function Player.new()
    local self = setmetatable({}, Player)

    self.x = 960
    self.y = 540
    self.width = 32
    self.height = 32
    self.speed = 200

    return self
end


function Player:update(dt)
    if love.keyboard.isDown("w") then self.y = self.y - self.speed * dt end
    if love.keyboard.isDown("s") then self.y = self.y + self.speed * dt end
    if love.keyboard.isDown("a") then self.x = self.x - self.speed * dt end
    if love.keyboard.isDown("d") then self.x = self.x + self.speed * dt end
end

function Player:draw()
    love.graphics.setColor(0.2, 0.6, 1)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1,1,1)

    
end

return Player
