local Hud = {}
Hud.__index = Hud

function Hud.new()
    local self = setmetatable({}, Hud)

    self.barWidth = 200
    self.barHeight = 20
    self.x = 20
    self.y = 20

    return  self
end


function Hud:draw(player, totalCoins)
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", self.x, self.y, self.barWidth, self.barHeight)

    local ratio = math.max(0, player.hp / player.maxHp)
    love.graphics.setColor(0.8, 0.1, 0.1)
    love.graphics.rectangle("fill", self.x, self.y, self.barWidth * ratio, self.barHeight)

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", self.x, self.y, self.barWidth, self.barHeight)

    love.graphics.print("HP: " .. math.floor(player.hp) .. " / " .. player.maxHp, self.x + 5, self.y + 2)
    love.graphics.print("Coins: " .. totalCoins, self.x, self.y + self.barHeight + 8)
end

return Hud