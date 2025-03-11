local Point   = require "entities.Point"
local Vec     = require "entities.Vec"
local numFont = love.graphics.newFont(10)
love.graphics.setFont(numFont)

-- when user clicks on a vector how much pixel can it be offset to still detect it
local detectionRadius = 5


local coordinateSystem = {
    -- size in pixels per unit
    unitSize = 20,
    points = {},
    vectors = {}
}

-- gets a point in unit coordinates rounded to the nearest whole number
function coordinateSystem:pixelToUnit(pixelX, pixelY)
    local unitX = pixelX / self.unitSize - love.graphics.getWidth() / 2 / self.unitSize
    local unitY = love.graphics.getHeight() / 2 / self.unitSize - pixelY / self.unitSize

    unitX = math.floor(unitX + 0.5)
    unitY = math.floor(unitY + 0.5)

    return unitX, unitY
end

-- gets a point in unit coordinates
function coordinateSystem:fpixelToUnit(pixelX, pixelY)
    local unitX = pixelX / self.unitSize - love.graphics.getWidth() / 2 / self.unitSize
    local unitY = love.graphics.getHeight() / 2 / self.unitSize - pixelY / self.unitSize



    return unitX, unitY
end

function coordinateSystem:addPoint(x, y)
    local newPoint = Point(x, y)
    table.insert(self.points, newPoint)
    return newPoint
end

function coordinateSystem:addVector(startX, startY, endX, endY)
    local p1 = Point(startX, startY)
    local p2 = Point(endX, endY)
    local newVector = Vec(p1, p2)
    table.insert(self.vectors, newVector)

    return newVector
end

function coordinateSystem:removeVector(index)
    table.remove(self.vectors, index)
end

function coordinateSystem:getVectorAtPosition(pixelX, pixelY)
    -- along the vector check if the clicked point is on the vector + the detection radius
    for i, v in ipairs(self.vectors) do
        local ux, uy = self:getPointCoordinates(v.startPoint.position.x, v.startPoint.position.y)
        local vx, vy = self:getPointCoordinates(v.endPoint.position.x, v.endPoint.position.y)
        local dx = vx - ux
        local dy = vy - uy
        local lengthSquared = dx * dx + dy * dy
        if lengthSquared > 0 then
            local t = ((pixelX - ux) * dx + (pixelY - uy) * dy) / lengthSquared
            if t < 0 then t = 0 end
            if t > 1 then t = 1 end
            local projX = ux + t * dx
            local projY = uy + t * dy
            local distance = math.sqrt((pixelX - projX) ^ 2 + (pixelY - projY) ^ 2)
            if distance < detectionRadius then
                return v, i
            end
        end
    end
    return nil
end

-- gets a point in pixel coordinates
function coordinateSystem:getPointCoordinates(x, y)
    local unitX, unitY = x * self.unitSize + love.graphics.getWidth() / 2,
        love.graphics.getHeight() / 2 - y * self.unitSize
    return unitX, unitY
end

function coordinateSystem:drawCoordinateGrid()
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

function coordinateSystem:drawPoints()
    for index, point in ipairs(self.points) do
        point:draw(self)
    end
end

function coordinateSystem:drawVectors()
    for index, v in ipairs(self.vectors) do
        v:draw(self)
    end
end

function coordinateSystem:draw()
    coordinateSystem:drawCoordinateGrid()
    coordinateSystem:drawPoints()
    coordinateSystem:drawVectors()
end

return coordinateSystem
