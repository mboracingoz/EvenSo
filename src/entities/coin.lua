local Coin = {}
Coin.__index = Coin

function Coin.new(x, y)
    local self = setmetatable({}, Coin)

    self.x = x
    self.y = y
    self.width = 10
    self.height = 10

    return self
end


function Coin:draw()
    if self.collected then return end

    love.graphics.setColor(1, 0.85, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1,1,1)
end

return Coin