local coordinateSystem = require "systems.coordinateSystem"
local inputSystem = {
    mouseDown = false,
    mouseDownX = 0,
    mouseDownY = 0,
    currentSelectedVec = nil,
    lastSelectedVec = nil,
    mouseOverVector = false
}

function inputSystem:update(dt)
    if love.mouse.isDown(1) then
        if not self.mouseDown then
            self.mouseDown = true
            self.mouseDownX = love.mouse.getX()
            self.mouseDownY = love.mouse.getY()
            self:onmousedown()
        elseif self.mouseDown then
            self:onDrag()
        end
    else
        if self.mouseDown then
            self.mouseDown = false
            local x = love.mouse.getX()
            local y = love.mouse.getY()
            self:onmouserelease()
        end
        if not self.currentSelectedVec then
            self:hoverVector(love.mouse.getX(), love.mouse.getY())
        end
    end
end

function inputSystem:onmousedown()
    inputSystem:trySelectVector(love.mouse.getX(), love.mouse.getY())
    if self.currentSelectedVec then
        self:highlightSelectedVector()
    end
end

function inputSystem:onDrag()
    if not self.currentSelectedVec then
        self:drawFromStartToCurrentMouse()
    else
        self:moveSelectedVector()
    end
end

function inputSystem:onmouserelease()
    if not self.currentSelectedVec then
        local dist = math.sqrt((self.mouseDownX - love.mouse.getX()) ^ 2 + (self.mouseDownY - love.mouse.getY()) ^ 2)
        if dist < 20 then

        else
            self:createVector()
        end
    else
        self:snapVectorToGrid()
    end
end

function inputSystem:snapVectorToGrid()
    local startPxX, startPxY = coordinateSystem:getPointCoordinates(self.currentSelectedVec.startPoint.position.x,
        self.currentSelectedVec.startPoint.position.y)
    local endPxX, endPxY = coordinateSystem:getPointCoordinates(self.currentSelectedVec.endPoint.position.x,
        self.currentSelectedVec.endPoint.position.y)

    local startUnitX, startUnitY = coordinateSystem:pixelToUnit(startPxX, startPxY)
    local endUnitX, endUnitY = coordinateSystem:pixelToUnit(endPxX, endPxY)

    self.currentSelectedVec.startPoint.position.x = startUnitX
    self.currentSelectedVec.startPoint.position.y = startUnitY
    self.currentSelectedVec.endPoint.position.x = endUnitX
    self.currentSelectedVec.endPoint.position.y = endUnitY
end

function inputSystem:getNearestPointToMouse()
    local x, y = love.mouse.getPosition()
    local unitX, unitY = coordinateSystem:pixelToUnit(x, y)
    local pixelX, pixelY = coordinateSystem:getPointCoordinates(unitX, unitY)
    return pixelX, pixelY
end

function inputSystem:hoverVector(x, y)
    local vec = coordinateSystem:getVectorAtPosition(x, y)
    if vec then
        self.mouseOverVector = true
    else
        self.mouseOverVector = false
    end
end

function inputSystem:trySelectVector(x, y)
    local vec = coordinateSystem:getVectorAtPosition(x, y)
    if vec then
        if self.lastSelectedVec then
            self.lastSelectedVec.highlighted = false
        else
            self.lastSelectedVec = vec
        end
        self.currentSelectedVec = vec
        return true
    else
        self.currentSelectedVec = nil
        self.lastSelectedVec = nil
        return false
    end
end

function inputSystem:onclick(x, y)
    local vec = coordinateSystem:getVectorAtPosition(x, y)

    if vec then
        self.currentSelectedVec = vec
        self:highlightSelectedVector()
    else
        self.currentSelectedVec = nil
        if self.lastSelectedVec then
            self.lastSelectedVec.highlighted = false
        end
    end
end

function inputSystem:highlightSelectedVector()
    if self.lastSelectedVec then
        self.lastSelectedVec.highlighted = false
        self.lastSelectedVec = self.currentSelectedVec
        self.currentSelectedVec.highlighted = true
    else
        self.currentSelectedVec.highlighted = true
        self.lastSelectedVec = self.currentSelectedVec
    end
end

function inputSystem:moveSelectedVector()
    if self.mouseDown and love.mouse.isDown(1) and self.currentSelectedVec then
        local dx = love.mouse.getX() - self.mouseDownX
        local dy = love.mouse.getY() - self.mouseDownY

        -- update the vector's position in pixels
        local startPointInPixelsX, startPointInPixelsY = coordinateSystem:getPointCoordinates(
            self.currentSelectedVec.startPoint.position.x,
            self.currentSelectedVec.startPoint.position.y)
        local endPointInPixelsX, endPointInPixelsY = coordinateSystem:getPointCoordinates(
            self.currentSelectedVec.endPoint.position.x,
            self.currentSelectedVec.endPoint.position.y)

        startPointInPixelsX = startPointInPixelsX + dx
        startPointInPixelsY = startPointInPixelsY + dy
        endPointInPixelsX = endPointInPixelsX + dx
        endPointInPixelsY = endPointInPixelsY + dy

        -- convert the updated pixel positions back to units
        local startUnitX, startUnitY = coordinateSystem:fpixelToUnit(startPointInPixelsX, startPointInPixelsY)
        local endUnitX, endUnitY = coordinateSystem:fpixelToUnit(endPointInPixelsX, endPointInPixelsY)

        -- update the vector's position in units
        self.currentSelectedVec.startPoint.position.x = startUnitX
        self.currentSelectedVec.startPoint.position.y = startUnitY
        self.currentSelectedVec.endPoint.position.x = endUnitX
        self.currentSelectedVec.endPoint.position.y = endUnitY

        -- update the last mouse position
        self.mouseDownX = love.mouse.getX()
        self.mouseDownY = love.mouse.getY()
    end
end

function inputSystem:drawMouseHoverPointIndicator()
    local currentX, currentY = self:getNearestPointToMouse()
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", currentX, currentY, 3)
end

function inputSystem:drawFromStartToCurrentMouse()
    local currentX, currentY = self:getNearestPointToMouse()
    if love.mouse.isDown(1) and self.mouseDown then
        local unitStartX, unitStartY = coordinateSystem:pixelToUnit(self.mouseDownX, self.mouseDownY)
        local startX, startY = coordinateSystem:getPointCoordinates(unitStartX, unitStartY)
        love.graphics.setColor(1, 0, 0)
        love.graphics.line(startX, startY, currentX, currentY)
    end
end

function inputSystem:drawMouseCursor()
    if self.mouseOverVector then
        love.mouse.setCursor(love.mouse.getSystemCursor("hand"))
    else
        love.mouse.setCursor(love.mouse.getSystemCursor("arrow"))
    end
end

function inputSystem:createVector()
    local currentX, currentY = self:getNearestPointToMouse()
    local unitStartX, unitStartY = coordinateSystem:pixelToUnit(self.mouseDownX, self.mouseDownY)
    local unitEndX, unitEndY = coordinateSystem:pixelToUnit(currentX, currentY)

    local vec = coordinateSystem:addVector(unitStartX, unitStartY, unitEndX, unitEndY)
    self.currentSelectedVec = vec
    self:highlightSelectedVector()
end

function inputSystem:draw()
    self:drawMouseCursor()
    if not self.currentSelectedVec then
        print(" no selected vector")
        self:drawMouseHoverPointIndicator()
    end
    self:drawFromStartToCurrentMouse()
end

return inputSystem
