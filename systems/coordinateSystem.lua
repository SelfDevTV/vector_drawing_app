local numFont = love.graphics.newFont(10)
love.graphics.setFont(numFont)

local fontWidth = numFont:getWidth("0")
local fontHeight = numFont:getHeight("0")

local coordinateSystem = {
    -- size in pixels per unit
    unitSize = 20,

}

function coordinateSystem:drawPoint(x, y)
    local ux, uy = self:getPoint(x, y)
    love.graphics.circle("fill", ux, uy, 3)
    love.graphics.print("(" .. x .. ", " .. y .. ")", ux + 5, uy - 5)
end

function coordinateSystem:getPoint(x, y)
    local unitX, unitY = x * self.unitSize + love.graphics.getWidth() / 2,
        love.graphics.getHeight() / 2 - y * self.unitSize
    return unitX, unitY
end

function coordinateSystem:draw()
    love.graphics.setColor(0.5, 0.5, 0.5, 0.2)
    for x = 0, love.graphics.getWidth(), self.unitSize do
        love.graphics.line(x, 0, x, love.graphics.getHeight())
    end
    for y = 0, love.graphics.getHeight(), self.unitSize do
        love.graphics.line(0, y, love.graphics.getWidth(), y)
    end

    -- draw the numbers (whole numbers, 0,0 is on center)

    love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
    for x = 0, love.graphics.getWidth(), self.unitSize do
        love.graphics.print(x / self.unitSize - love.graphics.getWidth() / 2 / self.unitSize,
            x,
            love.graphics.getHeight() / 2)
    end
    for y = 0, love.graphics.getHeight(), self.unitSize do
        love.graphics.print(love.graphics.getHeight() / 2 / self.unitSize - y / self.unitSize,
            love.graphics.getWidth() / 2, y)
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.line(love.graphics.getWidth() / 2, 0, love.graphics.getWidth() / 2, love.graphics.getHeight())
    love.graphics.line(0, love.graphics.getHeight() / 2, love.graphics.getWidth(), love.graphics.getHeight() / 2)
end

return coordinateSystem
