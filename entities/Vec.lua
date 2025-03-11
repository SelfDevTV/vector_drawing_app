local Vec = Class {
    init = function(self, startPoint, endPoint)
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.highlighted = false
    end
}

function Vec:draw(coordinateSystem)
    if self.highlighted then
        love.graphics.setColor(1, 0, 0)
    else
        love.graphics.setColor(1, 1, 1)
    end
    local ux, uy = coordinateSystem:getPointCoordinates(self.startPoint.position.x, self.startPoint.position.y)
    local vx, vy = coordinateSystem:getPointCoordinates(self.endPoint.position.x, self.endPoint.position.y)
    love.graphics.line(ux, uy, vx, vy)
end

return Vec
