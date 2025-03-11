local numFont = love.graphics.newFont(10)
love.graphics.setFont(numFont)

local fontWidth = numFont:getWidth("0")
local fontHeight = numFont:getHeight("0")

local coordinateSystem = {
    pixelToUnit = 20,

}

function coordinateSystem:getUnit(x, y)
    return x * self.pixelToUnit, y * self.pixelToUnit
end

function coordinateSystem:draw()
    love.graphics.setColor(0.5, 0.5, 0.5, 0.2)
    for x = 0, love.graphics.getWidth(), self.pixelToUnit do
        love.graphics.line(x, 0, x, love.graphics.getHeight())
    end
    for y = 0, love.graphics.getHeight(), self.pixelToUnit do
        love.graphics.line(0, y, love.graphics.getWidth(), y)
    end

    -- draw the numbers (whole numbers, 0,0 is on center)
    love.graphics.setLineStyle("dot")
    love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
    for x = 0, love.graphics.getWidth(), self.pixelToUnit do
        love.graphics.print(x / self.pixelToUnit - love.graphics.getWidth() / 2 / self.pixelToUnit,
            x + fontWidth / 2,
            love.graphics.getHeight() / 2 + fontHeight / 2)
    end
    for y = 0, love.graphics.getHeight(), self.pixelToUnit do
        love.graphics.print(love.graphics.getHeight() / 2 / self.pixelToUnit - y / self.pixelToUnit,
            love.graphics.getWidth() / 2 + fontWidth / 2, y + fontHeight / 2)
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.line(love.graphics.getWidth() / 2, 0, love.graphics.getWidth() / 2, love.graphics.getHeight())
    love.graphics.line(0, love.graphics.getHeight() / 2, love.graphics.getWidth(), love.graphics.getHeight() / 2)
end

return coordinateSystem
