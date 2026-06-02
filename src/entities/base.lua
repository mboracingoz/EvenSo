local Base = {}
Base.__index = Base

function Base.new()
    local self = setmetatable({}, Base)

    self.width = 100
    self.height = 100
    self.x = 1920 / 2 - self.width / 2
    self.y = 1080 / 2 - self.height / 2 
    self.hp = 10
    self.alive = true

    return self
end


function Base:takeDamage(amount)
    self.hp = math.max(0, self.hp - amount)
    if self.hp <= 0 then
        self.alive = false
    end
end


function Base:draw()
    if not self.alive then return end 
        love.graphics.setColor(0.6, 0.4, 0.1) 
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        love.graphics.setColor(1,1,1)
end

return Base 