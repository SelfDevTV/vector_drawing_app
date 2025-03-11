local coordinateSystem = require "systems.coordinateSystem"
local inputSystem = {
    mouseDown = false,
    mouseDownX = 0,
    mouseDownY = 0,
}

function inputSystem:update(dt)
    if love.mouse.isDown(1) then
        if not self.mouseDown then
            self.mouseDown = true
            self.mouseDownX = love.mouse.getX()
            self.mouseDownY = love.mouse.getY()
        end
    else
        if self.mouseDown then
            self.mouseDown = false
            local x = love.mouse.getX()
            local y = love.mouse.getY()
            -- create a vector
            print(x, y)
            local unitStartX, unitStartY = coordinateSystem:pixelToUnit(self.mouseDownX, self.mouseDownY)
            local unitEndX, unitEndY = coordinateSystem:pixelToUnit(x, y)

            coordinateSystem:addVector(unitStartX, unitStartY, unitEndX, unitEndY)
        end
    end
end

function inputSystem:getNearestPointToMouse()
    local x, y = love.mouse.getPosition()
    local unitX, unitY = coordinateSystem:pixelToUnit(x, y)
    local pixelX, pixelY = coordinateSystem:getPoint(unitX, unitY)
    return pixelX, pixelY
end

function inputSystem:drawMouseHoverPointIndicator()
    local currentX, currentY = self:getNearestPointToMouse()
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", currentX, currentY, 3)
end

function inputSystem:drawFromStartToCurrentMouse()
    local currentX, currentY = self:getNearestPointToMouse()
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", currentX, currentY, 3)
    if love.mouse.isDown(1) and self.mouseDown then
        local unitStartX, unitStartY = coordinateSystem:pixelToUnit(self.mouseDownX, self.mouseDownY)
        local startX, startY = coordinateSystem:getPoint(unitStartX, unitStartY)
        love.graphics.setColor(1, 0, 0)
        love.graphics.line(startX, startY, currentX, currentY)
    end
end

function inputSystem:draw()
    self:drawMouseHoverPointIndicator()
    self:drawFromStartToCurrentMouse()
end

return inputSystem
